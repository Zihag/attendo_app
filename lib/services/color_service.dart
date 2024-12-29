import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class ColorService {
  static Color getStatusColor(String status){
    switch(status){
      case 'Completed':
        return AppColors.green;
      case 'Upcoming':
        return AppColors.yellow;
      case 'Today':
        return AppColors.orange;
      default:
        return Colors.grey[300]!;
    }
  }
}