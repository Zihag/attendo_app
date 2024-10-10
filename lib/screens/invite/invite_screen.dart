import 'package:attendo_app/app_blocs/link_invite/bloc/invite_bloc.dart';
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
      create: (context) => InviteBloc(FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(title: Text('Invite to Group')),
        body: BlocConsumer<InviteBloc, InviteState>(
          listener: (context, state) {
            if (state is InviteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is InviteLinkCreated) {
              Share.share(state.inviteLink, subject: 'Join my group!');
            }
            if (state is InviteSentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invite sent successfully!')),
              );
            }
          },
          builder: (context, state) {
            if (state is InviteLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<InviteBloc>().add(CreateInviteLink(widget.groupId));
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
                        context.read<InviteBloc>().add(SendInviteByEmail(widget.groupId, email));
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
