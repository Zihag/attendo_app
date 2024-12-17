import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMTokenService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> saveUserTokenToFirestore(String userId) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'fcmToken': token});
        print("FCM Token saved: $token");
      } else {
        print("Failed to retrieve FCm Token");
      }
    } catch (e) {
      print("Error saving FCM Token: $e");
    }
  }

  void setupTokenRefresh(String userId){
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      try {
        await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'fcmToken': newToken});
        print("FCM Token refreshed: $newToken");
      } catch (e){
        print("Error updating refreshed FCM Token: $e");
      }
    });
  }

  Future<void> removeUserTokenFromFirestore(String userId) async {
    try{
      await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({'fcmToken': FieldValue.delete()});
      print("FCM Token removed for user: $userId");
    } catch (e){
      print("Error removing FCM Token: $e");
    }
  }
}
