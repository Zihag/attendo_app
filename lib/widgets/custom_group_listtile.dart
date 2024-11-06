import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGroupListTile extends StatelessWidget {
  final Widget? avatar; // Hình đại diện
  final String title; // Tên nhóm
  final String description; // Mô tả nhóm
  final String memberCount; // Số lượng thành viên
  final String actCount; // Số lượng hoạt động
  final VoidCallback? onTap; // Hành động khi nhấn vào ô này
  final VoidCallback? onDelete; // Hành động khi nhấn vào nút xóa

  const CustomGroupListTile({
    super.key,
    this.avatar,
    required this.title,
    required this.description,
    required this.memberCount,
    required this.actCount,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar ở phía start
            Container(
              margin: EdgeInsets.only(right: 12),
              child: avatar ??
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/0d/8b/5a/0d8b5a6f0f0b53c6e092a4133fed4fef.jpg'),
                  ),
            ),
            // Phần chứa thông tin nhóm và các nút đếm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên nhóm và nút xóa (option)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  // Mô tả nhóm
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      description,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  // Khoảng cách để phần thông tin thành viên và hoạt động nằm dưới cùng bên phải
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        memberCount,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        actCount,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
