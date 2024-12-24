/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {DateTime} = require("luxon");
const {getTodayActivities} = require("../utils/getTodayActivities");

exports.checkAndSendActivityReminders = functions.pubsub
    .schedule("every 10 minutes")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      const now = DateTime.now().setZone("Asia/Saigon");
      const oneHourLater = now.plus({hours: 1}).set({day: 1, month: 1, year: 2000});
      const seventyMinutesLater = now.plus({minutes: 70}).set({day: 1, month: 1, year: 2000});

      console.log("Current Time: ", now.toISO());
      console.log("oneHourLater:", oneHourLater.toISO());
      console.log("seventyMinutesLater:", seventyMinutesLater.toISO());

      const oneHourLaterTimestamp = admin.firestore.Timestamp.fromDate(oneHourLater.toJSDate());
      const seventyMinutesLaterTimestamp = admin.firestore.Timestamp.fromDate(seventyMinutesLater.toJSDate());

      try {
        // Lấy danh sách hoạt động hôm nay
        const todayActivities = await getTodayActivities();
        console.log(`Found ${todayActivities.length} activities for today.`);

        const activitiesToNotify = todayActivities.filter((activity) => {
          const actTime = activity.actTime; // actTime ở dạng Timestamp
          return (
            actTime >= oneHourLaterTimestamp &&
            actTime <= seventyMinutesLaterTimestamp
          );
        });

        console.log(`Found ${activitiesToNotify.length} activities to notify.`);

        const promises = activitiesToNotify.map(async (activity) => {
          const groupRef = activity.ref.parent.parent;
          const groupDoc = await groupRef.get();

          const groupData = groupDoc.data();
          const userPromises = groupData.member.map(async (member) => {
            try {
              const userDoc = await admin.firestore().collection("users").doc(member.userId).get();
              if (!userDoc.exists) {
                console.warn(`User ${member.userId} does not exist, skipping notification`);
                return null;
              }

              const userData = userDoc.data();
              if (!userData.fcmToken) {
                console.warn(`No token found for user ${member.userId}, skipping notification`);
                return null;
              }

              return {userId: member.userId, token: userData.fcmToken};
            } catch (error) {
              console.error(`Error fetching user ${member.userId}: ${error.message}`);
              return null;
            }
          });

          const usersWithTokens = (await Promise.all(userPromises)).filter((user) => user !== null);

          if (usersWithTokens.length === 0) {
            console.log(`No valid tokens found for group ${groupRef.id}`);
            return null;
          }

          const notifications = usersWithTokens.map(async (user) => {
            const message = {
              notification: {
                title: `Reminder: ${activity.name}`,
                body: `Your activity "${activity.name}" starts at ${new Date(activity.actTime.seconds * 1000)
                    .toLocaleTimeString("en-US", {
                      timeZone: "Asia/Saigon",
                      hour12: false,
                      hour: "2-digit",
                      minute: "2-digit",
                    })}!`,
                imageUrl: "https://i.pinimg.com/736x/07/bd/b2/07bdb22f3eb3be673ce681d52f1b0336.jpg",
              },
              token: user.token,
            };
            try {
              await admin.messaging().send(message);
              console.log(`Notification sent to ${user.userId} for activity "${activity.name}"`);
            } catch (error) {
              console.error(`Error sending notification to ${user.userId}: ${error.message}`);
            }
          });

          await Promise.all(notifications);

          // Cập nhật lastNotifiedAt
          await activity.ref.update({
            lastNotifiedAt: admin.firestore.Timestamp.now(),
          });
          console.log(`Activity "${activity.name}" updated with lastNotifiedAt.`);
        });

        await Promise.all(promises);
        console.log("All notifications processed successfully.");
      } catch (error) {
        console.error("Error processing activities: ", error.message);
      }
      console.log("checkAndSendActivityReminders function completes.");
      return null;
    });
