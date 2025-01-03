/* eslint-disable no-unused-vars */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {DateTime} = require("luxon");
const {getTodayActivities} = require("../utils/getTodayActivities");

exports.checkAndSendActivityReminders = functions.pubsub
    .schedule("every 10 minutes")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      try {
        // Lấy danh sách tất cả các nhóm
        console.time("fetchData");
        const groupsRef = admin.firestore().collectionGroup("groups");
        console.timeEnd("fetchData");
        const groupsSnapshot = await groupsRef.get();

        // Tạo một map để nhóm các nhóm có cùng múi giờ
        const groupsByTimezone = new Map();

        // Duyệt qua tất cả các nhóm và phân nhóm theo múi giờ
        console.time("processTimeZone");
        groupsSnapshot.docs.forEach((groupDoc) => {
          const groupData = groupDoc.data();
          const groupTimezone = groupData.timeZone || "Asia/Saigon"; // Múi giờ mặc định nếu không có

          if (!groupsByTimezone.has(groupTimezone)) {
            groupsByTimezone.set(groupTimezone, []);
          }
          groupsByTimezone.get(groupTimezone).push(groupDoc);
        });
        console.timeEnd("processTimeZone");

        // Log danh sách múi giờ và số lượng nhóm trong từng múi giờ
        console.log("Timezones and number of groups:", Array.from(groupsByTimezone.entries()).map(([tz, groups]) => ({
          timezone: tz,
          groupCount: groups.length,
        })));

        // Xử lý từng múi giờ
        console.time("processCheckAndSendMessage");
        const promises = Array.from(groupsByTimezone.entries()).map(async ([timezone, groups]) => {
          const now = DateTime.now().setZone(timezone);

          // Log thời gian hiện tại cho timezone
          console.log(`Processing timezone "${timezone}"\nCurrent time is ${now.toISO()}`);


          const todayStartOfDay = now.startOf("day");
          const todayEndOfDay = now.endOf("day");

          console.log(`${timezone} {\n    todayStartOfDay: ${todayStartOfDay.toISO()},\n    todayEndOfDay: ${todayEndOfDay.toISO()}\n}`);

          const oneHourLater = now.plus({hours: 1}).set({day: 1, month: 1, year: 2000});
          const seventyMinutesLater = now.plus({minutes: 70}).set({day: 1, month: 1, year: 2000});

          const oneHourLaterTimestamp = admin.firestore.Timestamp.fromDate(oneHourLater.toJSDate());
          const seventyMinutesLaterTimestamp = admin.firestore.Timestamp.fromDate(seventyMinutesLater.toJSDate());


          // Duyệt qua từng group trong múi giờ
          const groupPromises = groups.map(async (groupDoc) => {
            const groupRef = groupDoc.ref;
            const groupData = groupDoc.data();
            const activitiesRef = groupRef.collection("activities");
            const activitiesSnapshot = await activitiesRef.get();

            // Lọc hoạt động hôm nay
            const todayActivities = activitiesSnapshot.docs.filter((doc) => {
              const activity = doc.data();


              // Daily
              if (activity.frequency === "Daily") {
                console.log(`Activity ${activity.name} is Daily.`);
                return true;
              }


              // Once
              if (activity.frequency === "Once") {
                const onceDate = activity.onceDate;
                console.log(`Once date: `, onceDate);
                const onceDateInMilliseconds = onceDate._seconds * 1000;
                const onceDateInTimeZone = DateTime.fromMillis(onceDateInMilliseconds).setZone(timezone);
                console.log(`Converted onceDateInTimeZone ${timezone}: ${onceDateInTimeZone.toISO()}`);
                const onceDateInJSDate = onceDateInTimeZone.toJSDate();
                console.log(`Activity ${activity.name} is Once. onceDateInTimeZone: ${onceDateInTimeZone.toISO()}`);
                if (onceDateInJSDate >= todayStartOfDay.toJSDate() && onceDateInJSDate <= todayEndOfDay.toJSDate()) {
                  console.log(`Activity ${activity.name} is today.`);
                  return true;
                }
              }

              // Weekly
              if (activity.frequency === "Weekly" && activity.weeklyDate.includes(now.weekday)) {
                console.log(`Activity ${activity.name} is Weekly.`);
                return true;
              }

              // Monthly
              if (activity.frequency === "Monthly") {
                console.log(`Activity ${activity.name} is Monthly.`);
                const monthlyDate = DateTime.fromJSDate(activity.monthlyDate.toDate()).setZone(timezone);
                return monthlyDate.day === now.day;
              }
              return false;
            });

            console.log(`Found ${todayActivities.length} activities for today in group ${groupData.name}, timezone ${timezone}.`);


            // Lọc hoạt động diễn ra trong 60-70 phút tới
            const activitiesToNotify = todayActivities.filter((doc) => {
              const activity = doc.data();
              const actTime = activity.actTime;
              const actDate = actTime.toDate();
              const actTimeInTimeZone = DateTime.fromJSDate(actDate).setZone(timezone);

              console.log(`   ${activity.name} {\n
                Original actTime:  ${actTime}\n
                Formatted actTime: , ${actDate.toISOString()}\n
                actTime in time zone ${timezone}: ${actTimeInTimeZone.toString()}\n
                oneHourLaterTimeStamp: ${oneHourLaterTimestamp.toDate().toString()}\n
                seventyMinutesLaterTimeStamp: ${seventyMinutesLaterTimestamp.toDate().toString()}\n}`);
              return actTimeInTimeZone >= oneHourLater && actTimeInTimeZone <= seventyMinutesLater;
            });

            console.log(`Found ${activitiesToNotify.length} activities to notify in group ${groupData.name}, timezone ${timezone}.`);

            // Gửi thông báo
            await Promise.all(activitiesToNotify.map(async (activityDoc) => {
              const activity = activityDoc.data();
              const groupData = groupDoc.data();
              const userPromises = groupData.member.map(async (member) => {
                const userDoc = await admin.firestore().collection("users").doc(member.userId).get();
                if (!userDoc.exists || !userDoc.data().fcmToken) return null;
                return {userId: member.userId, token: userDoc.data().fcmToken};
              });

              const usersWithTokens = (await Promise.all(userPromises)).filter((user) => user !== null);
              if (usersWithTokens.length === 0) return;

              const notifications = usersWithTokens.map((user) => {
                const message = {
                  notification: {
                    title: `Reminder: ${activity.name}`,
                    body: `Your activity "${activity.name}" starts about 1 hour!`,
                  },
                  token: user.token,
                };
                return admin.messaging().send(message);
              });

              await Promise.all(notifications);

              // Cập nhật lastNotifiedAt
              await activityDoc.ref.update({lastNotifiedAt: admin.firestore.Timestamp.now()});
              console.log(`Notification sent for activity ${activity.name}.`);
            }));
          });

          await Promise.all(groupPromises);
        });
        console.timeEnd("processCheckAndSendMessage");

        await Promise.all(promises);
        console.log("checkAndSendActivityReminders function completes.");
      } catch (error) {
        console.error("Error processing activities:", error.message);
      }
      return null;
    });
