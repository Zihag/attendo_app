/* eslint-disable max-len */
const {DateTime} = require("luxon");
const admin = require("firebase-admin");
const db = admin.firestore();

/**
 * Fetches all activities scheduled for today based on their frequency and actTime.
 * @return {Promise<Array<Object>>} A promise that resolves to an array of today's activities.
 */
async function getTodayActivities() {
  const now = DateTime.now().setZone("Asia/Saigon");
  const todayDayOfWeek = now.weekday;
  const todayDayOfMonth = now.day;

  const activitiesRef = db.collectionGroup("activities");

  const queries = [
    activitiesRef.where("frequency", "==", "Daily").get(),
    activitiesRef
        .where("frequency", "==", "Once")
        .where("onceDate", ">=", now.startOf("day").toJSDate())
        .where("onceDate", "<=", now.endOf("day").toJSDate())
        .get(),
    activitiesRef
        .where("frequency", "==", "Weekly")
        .where("weeklyDate", "array-contains", todayDayOfWeek)
        .get(),
    activitiesRef.where("frequency", "==", "Monthly").get(),
  ];

  const results = await Promise.all(queries);

  const monthlyActivities = results[3].docs.filter((doc) => {
    const activity = doc.data();
    if (activity.monthlyDate) {
      const monthlyDate = activity.monthlyDate.toDate();
      const monthlyDateInSaigon = DateTime.fromJSDate(monthlyDate).setZone("Asia/Saigon");
      return monthlyDateInSaigon.day === todayDayOfMonth;
    }
    return false;
  });

  const todayActivities = [
    ...results[0].docs,
    ...results[1].docs,
    ...results[2].docs,
    ...monthlyActivities,
  ];

  console.log(`Found ${todayActivities.length} activities for today`);
  return todayActivities.map((doc) => ({
    id: doc.id,
    ref: doc.ref,
    ...doc.data(),
  }));
}

module.exports = {getTodayActivities};
