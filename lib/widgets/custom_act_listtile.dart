// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomActListTile extends StatelessWidget {
//   final Widget? leading;
//   final String name;
//   final String description;
//   final String frequency;
//   final VoidCallback? onTap;
//   final VoidCallback? onDelete;
//   const CustomActListTile(
//       {super.key,
//       this.leading,
//       required this.title,
//       required this.subtitle,
//       this.trailing,
//       this.onTap, this.onDelete, required this.memberCount});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ListTile(
//           contentPadding: EdgeInsets.all(16),
//           leading: leading,
//           title: Text(
//             title,
//             style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(subtitle,style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 13),),
//               Text(memberCount,style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 13),)
//             ],
//           ),
//           trailing: IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: onDelete,
//           ),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
// }
