/* eslint-disable max-len */
const functions = require("firebase-functions");
const {DateTime} = require("luxon");
const {getTodayActivities} = require("../utils/getTodayActivities");

/**
 * Hàm Cloud Function ghi lại danh sách hoạt động của ngày hôm nay
 */
exports.logTodayActivities = functions.pubsub
    .schedule("every 24 hours") // Chạy mỗi 24 giờ
    .timeZone("Asia/Saigon")
    .onRun(async (context) => {
      try {
        console.log("Fetching today's activities...");
        const todayActivities = await getTodayActivities();

        if (todayActivities.length === 0) {
          console.log("No activities found for today.");
          return null;
        }

        console.log("Today's Activities:");
        todayActivities.forEach((activity, index) => {
          console.log(
              `${index + 1}. Name: ${activity.name}, Frequency: ${activity.frequency}`,
          );

          if (activity.onceDate) {
            const onceDateInSaigon = DateTime.fromJSDate(activity.onceDate.toDate())
                .setZone("Asia/Saigon")
                .toISO(); // Chuyển onceDate về múi giờ Asia/Saigon
            console.log(`   OnceDate: ${onceDateInSaigon}`);
          }

          if (activity.weeklyDate) {
            console.log(
                `   WeeklyDate: ${activity.weeklyDate.join(", ")}`,
            );
          }

          if (activity.monthlyDate) {
            const monthlyDateInSaigon = DateTime.fromJSDate(activity.monthlyDate.toDate())
                .setZone("Asia/Saigon")
                .toISO(); // Chuyển monthlyDate về múi giờ Asia/Saigon
            console.log(`   MonthlyDate: ${monthlyDateInSaigon}`);
          }
        });

        return null;
      } catch (error) {
        console.error("Error fetching today's activities:", error);
        throw new Error("Failed to fetch today's activities.");
      }
    });
