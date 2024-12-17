/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

// Send Daily Summary Notification
exports.sendDailySummary = functions.pubsub
    .schedule("0 6 * * *") // Runs every day at 6:00 AM
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Set to the start of the day

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

      const promises = Object.entries(notifications).map(
          async ([groupId, activities]) => {
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
                  body: `You have ${activities.length
                  } activities today: ${activities.join(", ")}`,
                },
                token: member.token,
              };

              try {
                await admin.messaging().send(message);
                console.log(`Notification sent to ${member.userId}`);
              } catch (error) {
                console.error(
                    `Error sending notification to ${member.userId}`, error);
              }
            });
            await Promise.all(memberPromises);
          });
      await Promise.all(promises);
      return null;
    });


// Send Activity Reminder Notification
exports.checkAndSendActivityReminders = functions.pubsub
    .schedule("every 10 minutes")
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      const now = new Date();
      const oneHourLater = new Date(now.getTime() + 60 * 60 * 1000);
      const seventyMinutesLater = new Date(now.getTime() + 70 * 60 * 1000);

      const formatTimeToString = (date) => {
        const formatter = new Intl.DateTimeFormat("en-US", {
          hour: "2-digit",
          minute: "2-digit",
          hour12: false,
          timeZone: "Asia/Saigon",
        });
        const parts = formatter.formatToParts(date);
        let hours = parts.find((part) => part.type === "hour").value;
        const minutes = parts.find((part) => part.type === "minute").value;

        if (hours >= 24) {
          hours = hours - 24;
        }
        return `${String(hours).padStart(2, "0")}:${minutes}`;
      };

      const nowStr = formatTimeToString(now);
      const oneHourLaterStr = formatTimeToString(oneHourLater);
      const seventyMinutesLaterStr = formatTimeToString(seventyMinutesLater);
      console.log("Calculated Time:");
      console.log(`Now: ${nowStr}`);
      console.log(`oneHourLater: ${oneHourLaterStr}`);
      console.log(`seventyMinutesLater: ${seventyMinutesLaterStr}`);


      console.log("Running checkAndSendActivityReminders function...");

      try {
        console.log("Starting activity querying...");

        // Bước 1: Khởi tạo reference Firestore
        let activitiesRef;
        try {
          activitiesRef = admin.firestore().collectionGroup("activities");
          console.log("Activities collection reference initialized.");
        } catch (error) {
          console.error("Error initializing activities reference:", error.message);
          throw error; // Dừng lại nếu lỗi khởi tạo Firestore reference
        }

        // Bước 2: Thực hiện truy vấn Firestore
        let snapshot;
        try {
          console.log(`Searching for activities between ${oneHourLaterStr} and ${seventyMinutesLaterStr}`);
          snapshot = await activitiesRef
              .where("actTime", ">=", oneHourLaterStr)
              .where("actTime", "<=", seventyMinutesLaterStr)
              .get();
          console.log("Query executed successfully.");
        } catch (error) {
          console.error("Error executing Firestore query:", error.message);
          throw error; // Dừng lại nếu truy vấn thất bại
        }

        // Bước 3: Kiểm tra kết quả truy vấn
        if (snapshot.empty) {
          console.log("No activities found between 60 to 70 minutes from now.");
          return null;
        }

        console.log("Logging all fetched activities...");
        snapshot.forEach((doc) => {
          const data = doc.data();
          console.log(`Document ID: ${doc.id}`);
          console.log("Data:", JSON.stringify(data, null, 2)); // Log dữ liệu đầy đủ theo dạng JSON
        });

        console.log(`Found ${snapshot.size} activities matching the criteria.`);
        console.log("Processing activities...");

        // Bước 4: Xử lý từng tài liệu
        const promises = snapshot.docs.map(async (doc) => {
          try {
            const activity = doc.data();
            const activityRef = doc.ref;

            console.log(`Processing activity: ${activity.name}, ID: ${doc.id}`);

            // Check if `lastNotifiedAt` exists
            if (!activity.lastNotifiedAt) {
              console.warn(`Activity "${activity.name}" missing lastNotifiedAt.`);

              // Kiểm tra thời gian hiện tại có nằm trong khoảng cần gửi không
              const actTime = activity.actTime; // Giả định `actTime` là định dạng HH:mm
              if (actTime < oneHourLaterStr || actTime > seventyMinutesLaterStr) {
                console.warn(
                    `Activity "${activity.name}" (actTime: ${actTime}) is out of notification window (${oneHourLaterStr} - ${seventyMinutesLaterStr}), skipping.`,
                );
                return null;
              }
            } else {
              // Nếu đã có `lastNotifiedAt`, kiểm tra xem thông báo đã được gửi trong 10 phút qua chưa
              const lastNotifiedTime = activity.lastNotifiedAt.toDate();
              console.log(
                  `Last notified time for activity "${activity.name}": ${lastNotifiedTime.toISOString()}`,
              );

              if (now - lastNotifiedTime < 10 * 60 * 1000) {
                console.warn(
                    `Notification recently sent for activity "${activity.name}", skipping.`,
                );
                return null;
              }
            }

            // Bước 5: Fetch group data
            let groupDoc;
            try {
              console.log(`Fetching group data for group ID: ${activity.groupId}`);
              groupDoc = await db.collection("groups").doc(activity.groupId).get();

              if (!groupDoc.exists) {
                console.error(`Group with ID ${activity.groupId} not found.`);
                return null;
              }

              const groupData = groupDoc.data();
              if (!groupData || !groupData.member || groupData.member.length === 0) {
                console.error(`No members found in group ID: ${activity.groupId}`);
                return null;
              }

              console.log(`Group ID: ${activity.groupId} has ${groupData.member.length} members.`);
            } catch (error) {
              console.error("Error fetching group data:", error.message);
              return null; // Nếu có lỗi khi lấy group data thì bỏ qua activity này
            }

            // Bước 6: Send notifications
            try {
              const notifications = groupDoc.data().member.map(async (member) => {
                console.log(`Sending notification to member: ${member.userId}, token: ${member.token}`);
                const message = {
                  notification: {
                    title: `Reminder: ${activity.name}`,
                    body: `Your activity "${activity.name}" starts at ${new Date(activity.actTime.seconds * 1000).toLocaleString()}!`,
                  },
                  token: member.token,
                };

                try {
                  await admin.messaging().send(message);
                  console.log(`Notification successfully sent to ${member.userId}`);
                } catch (error) {
                  console.error(`Error sending notification to ${member.userId}:`, error.message);
                }
              });

              await Promise.all(notifications);
              console.log("Notifications sent to all members.");
            } catch (error) {
              console.error("Error sending notifications:", error.message);
            }

            // Bước 7: Cập nhật lastNotifiedAt
            try {
              await activityRef.update({
                lastNotifiedAt: admin.firestore.Timestamp.now(),
              });
              console.log(`Activity "${activity.name}" updated with lastNotifiedAt.`);
            } catch (error) {
              console.error("Error updating lastNotifiedAt:", error.message);
            }
          } catch (error) {
            console.error(`Error processing activity "${doc.id}":`, error.message);
          }
        });

        // Chờ tất cả các thông báo hoàn thành
        await Promise.all(promises);
        console.log("All notifications processed successfully.");
      } catch (error) {
        console.error("Error in main try-catch block:", error.message);
      }


      console.log("checkAndSendActivityReminders function completed.");
      return null;
    });
