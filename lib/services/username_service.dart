import 'package:cloud_firestore/cloud_firestore.dart';

class UsernameService {
  final FirebaseFirestore _firebaseFirestore;

  UsernameService(this._firebaseFirestore);

  Future<bool> isUsernameTaken(String username) async {
    try {
      final querySnapshot = await _firebaseFirestore
      .collection('users')
      .where('username', isEqualTo: username)
      .limit(1)
      .get();

      return querySnapshot.size > 0;
    } catch (e) {
      print('Error in username checking: $e');
      throw Exception("Can't check taken username now");
    }
  }
}