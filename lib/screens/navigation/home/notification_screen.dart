import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/app_blocs/invite_member/invitation/bloc/invitation_bloc.dart';
import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InvitationBloc(FirebaseFirestore.instance)..add(LoadInvitations()),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<InvitationBloc, InvitationState>(
            builder: (context, state) {
              if (state is InvitationLoading) {
                return CircularProgressIndicator();
              } else if (state is InvitationLoaded) {
                if (state.invitations.isEmpty) {
                  return Text('No notification now');
                }
                return ListView.builder(
                  itemCount: state.invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = state.invitations[index];
                    final groupId = invitation['groupId'];
                    final inviterId = invitation['inviterId'];

                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => GroupDetailBloc(FirebaseFirestore.instance)..add(LoadGroupDetail(groupId)),
                        ),
                        BlocProvider(
                          create: (context) => UserBloc(FirebaseFirestore.instance)..add(FetchUserData(inviterId)),
                        ),
                      ],
                      child: BlocBuilder<GroupDetailBloc, GroupDetailState>(
                          builder: (context, groupState) {
                        return BlocBuilder<UserBloc, UserState>(
                          builder: (context, userState) {
                            if (groupState is GroupDetailLoading ||
                                userState is UserLoading) {
                              return CircularProgressIndicator();
                            } else if (groupState is GroupDetailLoaded &&
                                userState is UserLoaded) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://i.pinimg.com/564x/0d/8b/5a/0d8b5a6f0f0b53c6e092a4133fed4fef.jpg'),
                                ),
                                title: Text(
                                    "${userState.displayName} invited you to ${groupState.groupData['name']}"),
                              );
                            } else if (groupState is GroupDetailError) {
                              return Text(groupState.message);
                            } else if (userState is UserError) {
                              return Text(userState.error);
                            }
                            return SizedBox.shrink();
                          },
                        );
                      }),
                    );
                  },
                );
              } else if (state is InvitationError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return Center(
                child: Text('No notification found'),
              );
            },
          ),
        ),
      ),
    );
  }
}