import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fw_tab_bar/fw_tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Activity Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          clipBehavior: Clip.antiAlias,
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
                                      left: Radius.circular(10))),
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10))),
                            ),
                            flex: 1,
                          ),
                        ],
                      )),
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
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  'assets/vector/activity_card1.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
