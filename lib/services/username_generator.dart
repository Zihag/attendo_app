import 'dart:math';

import 'package:attendo_app/services/username_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';

class UsernameGenerator {
  Future<String> generateUsername(String baseName) async {
    final random = Random();
    String username = removeDiacritics(baseName).toLowerCase().replaceAll('', '').replaceAll(' ', '');

    username += '${random.nextInt(10000)}';

    while (await UsernameService(FirebaseFirestore.instance).isUsernameTaken(username)){
      username = baseName.toLowerCase().replaceAll('from', '').replaceAll(' ', '')+'_${random.nextInt(10000)}';
    }
    return username;
  }
}