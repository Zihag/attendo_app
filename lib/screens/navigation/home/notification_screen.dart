import 'package:attendo_app/app_blocs/app_colors/app_colors.dart';
import 'package:attendo_app/app_blocs/groupdetail/bloc/groupdetail_bloc.dart';
import 'package:attendo_app/app_blocs/invite_member/invitation/bloc/invitation_bloc.dart';
import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:attendo_app/widgets/choice_button.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InvitationBloc(FirebaseFirestore.instance)..add(LoadInvitations()),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Center(
            child: Text(
              "Notification",
              style: GoogleFonts.openSans(fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Colors.grey[300],
        ),
        body: Center(
          child: BlocListener<InvitationBloc, InvitationState>(
            listener: (context, state) {
              if(state is InvitationAccepted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: AwesomeSnackbarContent(title: 'Accepted', message: "Let's explore your new group", contentType: ContentType.success,), backgroundColor: Colors.transparent, elevation: 0,duration: Duration(seconds: 1),));
              }
            },
            child: BlocBuilder<InvitationBloc, InvitationState>(
              builder: (context, state) {
                if (state is InvitationLoading) {
                  return const CircularProgressIndicator();
                } else if (state is InvitationLoaded) {
                  if (state.invitations.isEmpty) {
                    return const Text('No notification now');
                  }
                  return ListView.builder(
                    itemCount: state.invitations.length,
                    itemBuilder: (context, index) {
                      final invitation = state.invitations[index];
                      final invitationId = invitation['id'];
                      final groupId = invitation['groupId'];
                      final inviterId = invitation['inviterId'];

                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                GroupDetailBloc(FirebaseFirestore.instance)
                                  ..add(LoadGroupDetail(groupId)),
                          ),
                          BlocProvider(
                            create: (context) =>
                                UserBloc(FirebaseFirestore.instance)
                                  ..add(FetchUserData(inviterId)),
                          ),
                        ],
                        child: BlocBuilder<GroupDetailBloc, GroupDetailState>(
                            builder: (context, groupState) {
                          return BlocBuilder<UserBloc, UserState>(
                            builder: (context, userState) {
                              if (groupState is GroupDetailLoading ||
                                  userState is UserLoading) {
                                return const CardLoading(
                                  height: 80,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  margin: EdgeInsets.only(bottom: 10),
                                );
                              } else if (groupState is GroupDetailLoaded &&
                                  userState is UserLoaded) {
                                return Container(
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://i.pinimg.com/564x/0d/8b/5a/0d8b5a6f0f0b53c6e092a4133fed4fef.jpg'),
                                                  radius: 30,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${userState.displayName} invited you to ${groupState.groupData['name']}",
                                                    style: GoogleFonts.openSans(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                            overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      ChoiceButton(
                                                          text: 'Accept',
                                                          color: AppColors.cyan,
                                                          height: 30,
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                        InvitationBloc>(
                                                                    context)
                                                                .add(AcceptInvitation(
                                                                    invitationId));
                                                          }),
                                                      ChoiceButton(
                                                          text: 'Decline',
                                                          color:
                                                              Colors.grey[700]!,
                                                          height: 30,
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                        InvitationBloc>(
                                                                    context)
                                                                .add(RejectInvitation(
                                                                    invitationId));
                                                          })
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                            child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              } else if (groupState is GroupDetailError) {
                                return Text(groupState.message);
                              } else if (userState is UserError) {
                                return Text(userState.error);
                              }
                              return const SizedBox.shrink();
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
                return const Center(
                  child: Text('No notification found'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
