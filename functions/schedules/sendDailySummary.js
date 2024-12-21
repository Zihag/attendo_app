/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();

exports.sendDailySummary = functions.pubsub
    .schedule("0 6 * * *")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const activitiesRef = db.collectionGroup("activities");
      const snapshot = await activitiesRef
          .where("date", "==", admin.firestore.Timestamp.fromDate(today))
          .get();

      if (snapshot.empty) {
        console.log("No activities found for today.");
        return null;
      }

      const notifications = {};
      snapshot.forEach((doc) => {
        const activity = doc.data();
        const groupId = doc.ref.parent.parent.id;

        if (!notifications[groupId]) {
          notifications[groupId] = [];
        }
        notifications[groupId].push(activity.name);
      });

      const promises = Object.entries(notifications).map(async ([groupId, activities]) => {
        const groupDoc = await db.collection("groups").doc(groupId).get();
        const groupData = groupDoc.data();

        if (!groupData || !groupData.members) {
          console.log(`No members found for group: ${groupId}`);
          return;
        }

        const memberPromises = groupData.members.map(async (member) => {
          const message = {
            notification: {
              title: `Today's activities`,
              body: `You have ${activities.length} activities today: ${activities.join(", ")}`,
            },
            token: member.token,
          };

          try {
            await admin.messaging().send(message);
            console.log(`Notification sent to ${member.userId}`);
          } catch (error) {
            console.error(`Error sending notification to ${member.userId}`, error);
          }
        });
        await Promise.all(memberPromises);
      });
      await Promise.all(promises);
      return null;
    });
