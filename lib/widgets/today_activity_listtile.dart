import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityListtile extends StatelessWidget {
  final String activityName;
  final String groupName;
  final String time;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  const TodayActivityListtile({
    super.key,
    required this.activityName,
    required this.groupName,
    required this.time,
    this.onYes,
    this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 160,
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 20,
                offset: const Offset(0, 4))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activityName,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              groupName,
              style:
                  GoogleFonts.openSans(fontSize: 14, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              time,
              style:
                  GoogleFonts.openSans(fontSize: 13, color: Colors.grey[600]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: onYes,
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: onNo,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
