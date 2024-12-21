/* eslint-disable no-unused-vars */
/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK (chỉ thực hiện 1 lần)
if (!admin.apps.length) {
  admin.initializeApp();
}

// Import schedule functions
const {sendDailySummary} = require("./schedules/sendDailySummary");
const {checkAndSendActivityReminders} = require("./schedules/checkAndSendReminders");
const {logTodayActivities} = require("./schedules/logTodayActivities");

// Export functions
exports.sendDailySummary = sendDailySummary;
exports.checkAndSendActivityReminders = checkAndSendActivityReminders;
exports.logTodayActivities = logTodayActivities;
