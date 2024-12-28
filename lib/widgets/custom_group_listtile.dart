import 'package:attendo_app/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGroupListTile extends StatelessWidget {
  final Widget? avatar; // Hình đại diện
  final String title; // Tên nhóm
  final String description; // Mô tả nhóm
  final String memberCount; // Số lượng thành viên
  final String actCount; // Số lượng hoạt động
  final VoidCallback? onTap; // Hành động khi nhấn vào ô này
  final VoidCallback? onOption; // Hành động khi nhấn vào nút xóa

  const CustomGroupListTile({
    super.key,
    this.avatar,
    required this.title,
    required this.description,
    required this.memberCount,
    required this.actCount,
    this.onTap,
    this.onOption,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 100,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.2), 
              //     offset: const Offset(0, 4),
              //     blurRadius: 6,
              //   ),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            title,
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 16),
                                overflow: TextOverflow.ellipsis
                          ),
                          Text(
                            description,
                            style: GoogleFonts.openSans(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                memberCount,
                                style: GoogleFonts.openSans(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                actCount,
                                style: GoogleFonts.openSans(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  )
                ],
              ),
            )));
  }
}
