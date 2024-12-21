/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {DateTime} = require("luxon");

exports.checkAndSendActivityReminders = functions.pubsub
    .schedule("every 10 minutes")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      const now = DateTime.now().setZone("Asia/Saigon");
      const oneHourLater = now.plus({hours: 1}).set({day: 1, month: 1, year: 2000});
      const seventyMinutesLater = now.plus({minutes: 70}).set({day: 1, month: 1, year: 2000});

      console.log("Current Time: ", now.toISO());
      // In giá trị sau khi cộng thêm thời gian
      console.log("oneHourLater:", oneHourLater.toISO());
      console.log("seventyMinutesLater:", seventyMinutesLater.toISO());
      const oneHourLaterTimestamp = admin.firestore.Timestamp.fromDate(oneHourLater.toJSDate());
      const seventyMinutesLaterTimestamp = admin.firestore.Timestamp.fromDate(seventyMinutesLater.toJSDate());

      try {
      // Query activities from firestore
        const activitiesRef = admin.firestore().collectionGroup("activities");
        const snapshot = await activitiesRef
            .where("actTime", ">=", oneHourLaterTimestamp)
            .where("actTime", "<=", seventyMinutesLaterTimestamp)
            .get();

        if (snapshot.empty) {
          console.log("No activities found within the range.");
          return null;
        } else {
          console.log(`Found ${snapshot.size} activities within the range.`);

          // Executing each document
          const promises = snapshot.docs.map(async (doc) => {
            const activity = doc.data();
            const activitiesRef = doc.ref;
            const groupRef = doc.ref.parent.parent;

            console.log(`Processing activity: ${activity.name}, ID: ${doc.id}`);

            // Check lastNotifiedAt
            if (activity.lastNotifiedAt && activity.lastNotifiedAt instanceof admin.firestore.Timestamp) {
              const lastNotifiedAt = activity.lastNotifiedAt.toDate();
              if (now - lastNotifiedAt < 10 * 60 * 1000) {
                console.log(`Activity "${activity.name} was notified recently, skipping`);
                return null;
              }
            }

            // Get group data
            const groupDoc = await groupRef.get();
            // console.log(`Group ${groupRef.id} has ${groupData.member.length} members`);

            if (!groupDoc.exists) {
              console.error(`Group document does not exist for activity Id: ${doc.id}`);
              return null;
            }

            const groupData = groupDoc.data();

            // Fetch tokens from users collection
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

            // Send notifications
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
                console.log(`Notification send to ${user.userId} for activity "${activity.name}"`);
              } catch (error) {
                console.error(`Error sending notification to ${user.userId}: ${error.message}`);
              }
            });

            // Wait for all notifications to be sent
            await Promise.all(notifications);

            // Update lastNotifiedAt
            await activitiesRef.update({
              lastNotifiedAt: admin.firestore.Timestamp.now(),
            });
            console.log(`Activity "${activity.name}" updated with lastNotifiedAt`);

            await Promise.all(promises);
            console.log("All activities processed successfully");
          });
          await Promise.all(promises);
          console.log("All activities processed successfully");
        }
      } catch (error) {
        console.error("Error processing activities: ", error.message);
      }
      console.log("checkAndSendActivityReminders function completes");
      return null;
    });
