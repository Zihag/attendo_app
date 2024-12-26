  import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingContainer extends StatelessWidget {
  final List<Map<String, dynamic>> functions;

  const SettingContainer({super.key, required this.functions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        
      ),
      child: Column(
        children: functions
            .map((function) => Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        function['icon'] as String,
                        width: 30,
                        height: 30,
                      ),
                      title: Text(
                        function['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.black,
                      ),
                      onTap: function['onTap'] as VoidCallback?,
                    ),
                    if (function != functions.last)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(height: 1, color: Colors.grey[300]),
                      ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}