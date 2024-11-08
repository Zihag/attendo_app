import 'package:attendo_app/app_blocs/app_colors/app_colors.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/today_activity/bloc/today_activity_bloc.dart';
import 'package:attendo_app/app_blocs/user/bloc/user_bloc.dart';
import 'package:attendo_app/screens/group/group_detail_screen.dart';
import 'package:attendo_app/widgets/circle_avatar.dart';
import 'package:attendo_app/widgets/custom_group_listtile.dart';
import 'package:attendo_app/widgets/today_activity_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        context.read<GroupBloc>().add(LoadGroups());
        context.read<TodayActivityBloc>().add(LoadTodayActivities());
        context.read<UserBloc>().add(FetchUserData(user.uid));
      }
    });
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  CustomCircleAvatar(
                      photoURL: user.photoURL ??
                          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Hello, ',
                          style: GoogleFonts.openSans(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoaded) {
                            return Text(
                              state.username,
                              style: GoogleFonts.openSans(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            );
                          } else if (state is UserLoading){
                            return CircularProgressIndicator();
                          } else if (state is UserError){
                            return Text(state.error);
                          }
                          return Text('User not found');
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    'assets/vector/noti_icon.svg',
                    height: 30,
                  )
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Today activity',
                    style: GoogleFonts.openSans(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.grey[400],
                ))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Are you joining them today?'),
              ),
            ],
          ),
          BlocListener<TodayActivityBloc, TodayActivityState>(
            listener: (context, state) {
              if (state is TodayActivityError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SizedBox(
                height: 220,
                child: BlocBuilder<TodayActivityBloc, TodayActivityState>(
                  builder: (context, state) {
                    if (state is TodayActivityLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TodayActivityLoaded) {
                      if (state.activities.isEmpty) {
                        return Center(
                          child: Text('No activities today...'),
                        );
                      }
                      final activities = state.activities;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TodayActivityListTile(
                              activityName: activity['activityName'],
                              groupName: activity['groupName'],
                              time: activity['actTime'],
                              frequency: activity['frequency'],
                            ),
                          );
                        },
                      );
                    } else if (state is TodayActivityError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text('No activities for today'),
                      );
                    }
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'Your groups',
                    style: GoogleFonts.openSans(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.grey[400],
                ))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return Center(
                      child: LottieBuilder.asset(
                    'assets/Lottie/loading.json',
                    height: 200,
                  ));
                } else if (state is GroupLoaded) {
                  if (state.groups.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Let's create a group!")],
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: state.groups.length,
                    itemBuilder: (context, index) {
                      final group = state.groups[index];
                      final members = group['member'] as List<dynamic>;

                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('groups')
                              .doc(group['id'])
                              .collection('activities')
                              .get(),
                          builder: (context, snapshot) {
                            final actCount = snapshot.data?.docs.length ?? 0;
                            return CustomGroupListTile(
                              title: group['name'],
                              avatar: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/564x/0d/8b/5a/0d8b5a6f0f0b53c6e092a4133fed4fef.jpg'),
                              ),
                              description: group['description'],
                              memberCount:
                                  ('${members.length} member${members.length > 1 ? 's' : ''}'),
                              actCount: ('${actCount} activity'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupDetailScreen(
                                      groupId: group['id'],
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                BlocProvider.of<GroupBloc>(context)
                                    .add(DeleteGroup(group['id']));
                              },
                            );
                          });
                    },
                  );
                } else if (state is GroupError) {
                  // Hiển thị thông báo lỗi nếu có
                  return Center(child: Text(state.message));
                }
                // Mặc định nếu không có dữ liệu
                return Center(child: Text('No groups found'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: FloatingActionButton(
          backgroundColor: AppColors.cyan,
          onPressed: () => _showCreateGroupDialog(context), // Tạo nhóm mới
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final groupNameController = TextEditingController();
    final groupDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: groupDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Thêm nhóm mới
              BlocProvider.of<GroupBloc>(context).add(CreateGroup(
                groupNameController.text,
                groupDescriptionController.text,
              ));
              Navigator.of(context).pop(); // Đóng hộp thoại sau khi tạo nhóm
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Sign Out'),
            content: Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Người dùng hủy, không đăng xuất
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Người dùng xác nhận, đăng xuất
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ) ??
        false; // Trả về false nếu dialog bị đóng mà không chọn
  }
}
