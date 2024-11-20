

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityListTile extends StatelessWidget {
  final String activityName;
  final String groupName;
  final String time;
  final String frequency;


  const TodayActivityListTile({
    super.key,
    required this.activityName,
    required this.groupName,
    required this.time,
    required this.frequency,
  });


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 300,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/vector/today_act_tile.svg',
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 23, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                          child: Text(
                            groupName,
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 75),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/564x/3c/6e/49/3c6e499eedf2eee062a3f0cc095e11a7.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          time,
                          style: GoogleFonts.openSans(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: Center(
                            child: Text(
                            activityName,
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/vector/frequency_tag.svg',
                              height: 15,
                            ),
                            Text(
                            frequency,
                              style: GoogleFonts.openSans(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                    
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
