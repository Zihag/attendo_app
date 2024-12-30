import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 200),
      child: Stack(
        children: [
          Positioned.fill(
            child: Builder(
              builder: (context) => Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20))),
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(20))),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          Slidable(
            key: UniqueKey(),
            direction: Axis.horizontal,
            endActionPane: ActionPane(
              motion: BehindMotion(),
              extentRatio: 0.4,
              children: [
                SlidableAction(
                  backgroundColor: Colors.transparent,
                  autoClose: true,
                  onPressed: (BuildContext context) {},
                  icon: Icons.group,
                  flex: 1,
                ),
                SlidableAction(
                  backgroundColor: Colors.transparent,
                  autoClose: true,
                  onPressed: (BuildContext context) {},
                  icon: Icons.group,
                  flex: 1,
                ),
              ],
            ),
            child: Stack(
              children: [Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  'assets/vector/activity_card1.svg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 130,
                child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255),
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
                                    'time',
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              )),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 26,
                              width: 110,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/vector/icon_calendar.svg',
                                    height: 16,
                                  ),
                                  Expanded(
                                    // Kiểm tra độ dài văn bản để hiển thị Marquee hoặc Text
                                    child: ClipRect(
                                      child: "frequency".length <=
                                              10 // Kiểm tra nếu text ngắn
                                          ? Center(
                                              child: Text(
                                                "frequency",
                                                style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow
                                                    .ellipsis, // Dự phòng cho text dài
                                                maxLines: 1,
                                                softWrap: false,
                                              ),
                                            )
                                          : Marquee(
                                              text: "frequency",
                                              style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 30.0,
                                              pauseAfterRound:
                                                  const Duration(seconds: 2),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                                  const Duration(seconds: 1),
                                              accelerationCurve: Curves.easeIn,
                                              decelerationDuration:
                                                  const Duration(
                                                      milliseconds: 500),
                                              decelerationCurve: Curves.easeOut,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 60),
                            SvgPicture.asset(
                              'assets/vector/example_category.svg',
                              height: 45,
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'actName',
                            style: GoogleFonts.openSans(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 26,
                              width: 100,
                              child: Center(
                                child: Text(
                                  'status',
                                  style: GoogleFonts.openSans(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              )
              ]
            ),
          ),
        ],
      ),
    );
  }
}


