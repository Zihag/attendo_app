import 'package:attendo_app/app_blocs/invite_member/link_invite/bloc/member_invite_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class InviteScreen extends StatefulWidget {
  final String groupId;

  InviteScreen({required this.groupId});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemberInviteBloc(FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(title: Text('Invite to Group')),
        body: BlocConsumer<MemberInviteBloc, MemberInviteState>(
          listener: (context, state) {
            if (state is MemberInviteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is InviteLinkCreated) {
              Share.share(state.inviteLink, subject: 'Join my group!');
            }
            if (state is MemberInviteSentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invite sent successfully!')),
              );
            }
          },
          builder: (context, state) {
            if (state is MemberInviteLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<MemberInviteBloc>().add(CreateInviteLink(widget.groupId));
                    },
                    child: Text('Create and Share Invite Link'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter email to invite',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.read<MemberInviteBloc>().add(SendInviteByEmail(widget.groupId, email));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid email.')),
                        );
                      }
                    },
                    child: Text('Send Invite by Email'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
