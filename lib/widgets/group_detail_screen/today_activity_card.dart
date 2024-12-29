import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityCard extends StatelessWidget {
  final String actName;
  final String description;
  final String time;
  final String frequency;
  const TodayActivityCard(
      {super.key,
      required this.actName,
      required this.description,
      required this.time,
      required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        height: 130,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/vector/activity_card.svg',
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFC1C1C1),
                            borderRadius: BorderRadius.circular(10)),
                        height: 26,
                        width: 80,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/vector/icon_clock.svg',
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              time,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        )),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFC1C1C1),
                            borderRadius: BorderRadius.circular(10)),
                        height: 26,
                        width: 100,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/vector/icon_calendar.svg',
                              height: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              frequency,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      actName,
                      style: GoogleFonts.openSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [SizedBox(width: 20,),
                  GestureDetector(
                    child: SvgPicture.asset('assets/vector/group_detail_activity_button_yes_stroke.svg',width: 80,),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    child: SvgPicture.asset('assets/vector/group_detail_activity_button_no_stroke.svg', width: 80,),
                  ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
