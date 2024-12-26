/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const {getTodayActivities} = require("../utils/getTodayActivities");

exports.sendDailySummary = functions.pubsub
    .schedule("0 6 * * *")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      try {
        // Lấy danh sách hoạt động hôm nay
        const todayActivities = await getTodayActivities();
        console.log(`Found ${todayActivities.length} activities for today's summary.`);

        if (todayActivities.length === 0) {
          console.log("No activities found for today.");
          return null;
        }


        // Gom nhóm các hoạt động theo groupId
        const notifications = {};
        todayActivities.forEach((activity) => {
          const groupId = activity.ref.parent.parent.id;

          if (!notifications[groupId]) {
            notifications[groupId] = [];
          }

          // Get each activity field
          notifications[groupId].push({
            name: activity.name,
            actTime: activity.actTime,
          });
        });

        console.log(`Notifications prepared for ${Object.keys(notifications).length} groups.`);

        // Xử lý gửi thông báo cho từng nhóm
        const promises = Object.entries(notifications).map(async ([groupId, activities]) => {
          const groupDoc = await db.collection("groups").doc(groupId).get();
          const groupData = groupDoc.data();
          const groupName = groupData.name;

          if (!groupData || !Array.isArray(groupData.member)) {
            console.log(`No valid members found for group: ${groupId}`);
            return null;
          }

          // Gửi thông báo cho từng thành viên trong nhóm
          const memberPromises = groupData.member.map(async (member) => {
            if (!member.userId) {
              console.warn(`Member in group ${groupId} missing userId, skipping.`);
              return null;
            }

            try {
              const userDoc = await db.collection("users").doc(member.userId).get();

              if (!userDoc.exists) {
                console.warn(`User ${member.userId} does not exist.`);
                return null;
              }

              const userData = userDoc.data();
              if (!userData.fcmToken) {
                console.warn(`No token found for user ${member.userId}, skipping notification.`);
                return null;
              }

              const message = {
                notification: {
                  title: `Today's Activities in group ${groupName} 🔥`,
                  body: `You have ${activities.length} activities today:\n${activities
                      .map((activity) =>
                        `${activity.name}   🕐 ${new Date(activity.actTime.seconds * 1000)
                            .toLocaleTimeString("en-US", {
                              timeZone: "Asia/Saigon",
                              hour12: false,
                              hour: "2-digit",
                              minute: "2-digit",
                            })}`,
                      )
                      .join("\n")}`,
                },
                token: userData.fcmToken,
              };

              await admin.messaging().send(message);
              console.log(`Notification sent to ${member.userId} for group ${groupId}.`);
            } catch (error) {
              console.error(`Error sending notification to ${member.userId}: ${error.message}`);
            }
          });

          await Promise.all(memberPromises);
        });

        await Promise.all(promises);
        console.log("Daily summary notifications sent successfully.");
      } catch (error) {
        console.error("Error in sendDailySummary function: ", error.message);
      }

      return null;
    });
