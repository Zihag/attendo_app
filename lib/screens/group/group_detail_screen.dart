import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/screens/activity/create_activity_screen.dart';
import 'package:attendo_app/screens/invite/invite_screen.dart';
import 'package:attendo_app/widgets/custom_group_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  GroupDetailScreen({
    required this.groupId,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
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
          backgroundColor: Colors.blue[200],
          title: BlocBuilder<GroupDetailBloc, GroupDetailState>(
            builder: (context, state) {
              if (state is GroupDetailLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GroupDetailLoaded) {
                final members = state.groupData['member'] as List<dynamic>?;
                final memberCount = members?.length ?? 0;
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.groupData['name'] ?? 'Unknown'}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$memberCount member${memberCount == 1 ? '' : 's'}',
                        style: TextStyle(fontSize: 13),
                      )
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
                icon: Icon(Icons.share))
          ],
        ),
        body: BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is ActivityLoaded) {
              setState(() {});
            } else if (state is ActivityError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Column(
            children: [
              BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  if (state is ActivityLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ActivityLoaded) {
                    if (state.activities.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Let's create activity"),
                        ],
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.activities.length,
                        itemBuilder: (context, index) {
                          final activity = state.activities[index];
                          return ListTile(
                            title: Text(activity['name'] ?? 'No name'),
                            subtitle: Text(
                                activity['description'] ?? 'No description'),
                          );
                        },
                      ),
                    );
                  } else if (state is ActivityError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return SizedBox();
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
