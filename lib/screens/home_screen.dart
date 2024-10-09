import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/screens/group/group_detail_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:attendo_app/screens/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              bool confirmSignOut = await _showSignOutDialog(context);
              if (confirmSignOut) {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return Center(
                child: CircularProgressIndicator()); // Hiển thị vòng tròn tải
          } else if (state is GroupLoaded) {
            // Hiển thị danh sách nhóm khi tải thành công
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return ListTile(
                  title: Text(group['name']),
                  subtitle: Text(group['description']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Xóa nhóm
                      BlocProvider.of<GroupBloc>(context)
                          .add(DeleteGroup(group['id']));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupDetailScreen(groupId: group['id']),
                        ));
                  },
                );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context), // Tạo nhóm mới
        child: Icon(Icons.add),
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
