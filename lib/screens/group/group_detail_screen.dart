import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/screens/invite/invite_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailScreen extends StatelessWidget {
  final String groupId;

  GroupDetailScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupDetailBloc(FirebaseFirestore.instance)
        ..add(LoadGroupDetail(groupId)),
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
                              InviteScreen(groupId: groupId)));
                },
                icon: Icon(Icons.share))
          ],
        ),
        body: BlocBuilder<GroupDetailBloc, GroupDetailState>(
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
                      'Group Name: ${state.groupData['name'] ?? 'Unknown'}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description: ${state.groupData['description'] ?? 'No description'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Add more group details here
                  ],
                ),
              );
            } else if (state is GroupDetailError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
