import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:attendo_app/screens/activity/create_activity_screen.dart';
import 'package:attendo_app/screens/invite/invite_screen.dart';
import 'package:attendo_app/widgets/circle_avatar.dart';
import 'package:attendo_app/widgets/group_detail_screen/all_activity_card.dart';
import 'package:attendo_app/widgets/group_detail_screen/today_activity_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fw_tab_bar/fw_tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  GroupDetailScreen({
    required this.groupId,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Đồng bộ giao diện khi tab thay đổi
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GroupDetailBloc(FirebaseFirestore.instance)
            ..add(LoadGroupDetail(widget.groupId)),
        ),
        BlocProvider(
          create: (context) => ActivityBloc(FirebaseFirestore.instance)
            ..add(LoadActivities(groupId: widget.groupId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          //Remove appbar color changed when scroll
          surfaceTintColor: Colors.transparent,
          //Remove padding between leading icon and text
          titleSpacing: 0,
          toolbarHeight: 150,
          backgroundColor: Colors.grey[300],
          title: BlocBuilder<GroupDetailBloc, GroupDetailState>(
            builder: (context, state) {
              if (state is GroupDetailLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GroupDetailLoaded) {
                final members = state.groupData['member'] as List<dynamic>?;
                final memberCount = members?.length ?? 0;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCircleAvatar(
                        width: 70,
                        height: 70,
                        photoURL:
                            'https://i.pinimg.com/564x/e2/dc/3c/e2dc3cb5cb84093a9496f21ba5cc6743.jpg',
                      ),
                      Text(
                        '${state.groupData['name'] ?? 'Unknown'}',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$memberCount member${memberCount == 1 ? '' : 's'}',
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is GroupDetailError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('Unknown state'));
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InviteScreen(groupId: widget.groupId)));
                },
                icon: Icon(Icons.info))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Center(
                  child: TabBarWidget(
                    firstTab: 'Today',
                    secondTab: 'All',
                    currentIndex: _tabController.index,
                    onTabChanged: (int index) {
                      _tabController.animateTo(
                          index); // Đồng bộ TabController khi người dùng nhấn
                    },
                    backgroundBoxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.cyan),
                    selectedTabTextStyle: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    unselectedTabTextStyle:
                        GoogleFonts.openSans(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              BlocListener<ActivityBloc, ActivityState>(
                listener: (context, state) {
                  if (state is ActivityLoaded) {
                    setState(() {});
                  } else if (state is ActivityError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<ActivityBloc, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return Expanded(
                        child: Container(
                            color: Colors.white,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    } else if (state is ActivityLoaded) {
                      if (state.activities.isEmpty) {
                        return Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Let's create activity"),
                              ],
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  itemCount: state.activities.length,
                                  itemBuilder: (context, index) {
                                    final activity = state.activities[index];
                                    return TodayActivityCard(
                                        actName: activity['name'],
                                        description: activity['description'],
                                        time: activity['actTime'],
                                        frequency: activity['frequency']);
                                  },
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  itemCount: state.activities.length,
                                  itemBuilder: (context, index) {
                                    final activity = state.activities[index];
                                    return AllActivityCard(
                                        actName: activity['name'],
                                        description: activity['description'],
                                        time: activity['actTime'],
                                        frequency: activity['activeDate'],
                                        status: activity['status'],);
                                  },
                                ),
                              ),
                            ]),
                      );
                    } else if (state is ActivityError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.cyan,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateActivityScreen(groupId: widget.groupId)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
