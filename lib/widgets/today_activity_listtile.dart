import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityListTile extends StatelessWidget {
  final String activityName;
  final String groupName;
  final String time;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  const TodayActivityListTile({
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: GoogleFonts.openSans(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              activityName,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Daily',
                        style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/564x/3c/6e/49/3c6e499eedf2eee062a3f0cc095e11a7.jpg'),
            ),
            SizedBox(width: 5,),
            Text(
              groupName,
              style:
                  GoogleFonts.openSans(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
