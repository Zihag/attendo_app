import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/screens/activity/create_activity_screen.dart';
import 'package:attendo_app/screens/invite/invite_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  GroupDetailScreen({required this.groupId});

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
          title: Text('Group Details'),
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
        body: Column(
          children: [
            BlocBuilder<GroupDetailBloc, GroupDetailState>(
              builder: (context, state) {
                if (state is GroupDetailLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GroupDetailLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Group Name: //${state.groupData['name'] ?? 'Unknown'}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description: ${state.groupData['description'] ?? 'No description'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (state is GroupDetailError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('Unknown state'));
              },
            ),
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                if (state is AcitvityLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ActivityLoaded) {
                  if (state.activities.isEmpty) {
                    return Center(
                      child: Text("Let's create activity"),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Chuyển đến màn hình tạo hoạt động
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateActivityScreen(groupId: widget.groupId),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
