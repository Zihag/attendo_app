import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:attendo_app/widgets/choice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityListTile extends StatefulWidget {
  final String activityName;
  final String groupName;
  final String time;
  final String frequency;
  final Function(String status)? onChoiceSelected;
  const TodayActivityListTile({
    super.key,
    required this.activityName,
    required this.groupName,
    required this.time,
    required this.frequency,
    this.onChoiceSelected,
  });

  @override
  State<TodayActivityListTile> createState() => _TodayActivityListTileState();
}

class _TodayActivityListTileState extends State<TodayActivityListTile> {
  String? selectedChoice;

  void _handleSelection(String choice) {
    setState(() {
      selectedChoice = choice;
    });
    if (widget.onChoiceSelected != null) {
      widget.onChoiceSelected!(choice);
    }
  }

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
                  padding: const EdgeInsets.fromLTRB(20, 13, 0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            widget.groupName,
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 68),
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
                          widget.time,
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
                              widget.activityName,
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
                              widget.frequency,
                              style: GoogleFonts.openSans(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _handleSelection("Yes"),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      selectedChoice == "Yes"
                                          ? 'assets/vector/choice_button_yes.svg'
                                          : 'assets/vector/choice_button_stroke.svg',
                                      height: 30,
                                    ),
                                    Text(
                                      'Yes',
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "+20",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Icon(Icons.group_outlined)
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _handleSelection("No"),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      selectedChoice == "No"
                                          ? 'assets/vector/choice_button_no.svg'
                                          : 'assets/vector/choice_button_stroke.svg',
                                      height: 30,
                                    ),
                                    Text(
                                      'No',
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "  +5",
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Icon(Icons.group_outlined)
                            ],
                          )
                        ],
                      ),
                    )
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
