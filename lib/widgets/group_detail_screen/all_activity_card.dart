import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:attendo_app/services/color_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class AllActivityCard extends StatelessWidget {
  final String actName;
  final String description;
  final String time;
  final String frequency;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const AllActivityCard(
      {super.key,
      required this.actName,
      required this.description,
      required this.time,
      required this.frequency,
      required this.status,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        height: 130,
        child: Slidable(
          key: ValueKey(actName),
          endActionPane: ActionPane(
            motion: const BehindMotion(), children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AppColors.cyan,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(10)),
            ),
          ]),
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/vector/activity_card1.svg',
                  fit: BoxFit.fitWidth,
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
                                  child: frequency.length <=
                                          10 // Kiểm tra nếu text ngắn
                                      ? Center(
                                          child: Text(
                                            frequency,
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
                                          text: frequency,
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
                                              const Duration(milliseconds: 500),
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
                        actName,
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
                              color: ColorService.getStatusColor(status),
                              borderRadius: BorderRadius.circular(10)),
                          height: 26,
                          width: 100,
                          child: Center(
                            child: Text(
                              status,
                              style: GoogleFonts.openSans(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
