import 'package:cloud_firestore/cloud_firestore.dart';

class InviteUserService{
  final FirebaseFirestore _firebaseFirestore;

  InviteUserService(this._firebaseFirestore);



//check if user already joined in the group
  Future<bool> checkUserInGroup({
    required String groupId, required String userId
  }) async {
    try{
      print('Start check user in group');
      final groupDocRef = _firebaseFirestore.collection('groups')
      .doc(groupId);

      final groupDoc = await groupDocRef.get();

      if(!groupDoc.exists){
        throw Exception("Group not found");
      }

      final List<dynamic> members = groupDoc['member']??[];
      print("Member in group: $members");
      print("User to check: $userId");
      final isUserInGroup = members.any((member){
        if(member is Map<String, dynamic>){
          return member['userId'] == userId;
        }
        return false;
      });
      
      print("Is user in group: $isUserInGroup");
      return isUserInGroup;
    } catch(e){
      print("Error in check userInGroup: $e");
      throw Exception("Error checking user in grou: $e");
    }
  }
}