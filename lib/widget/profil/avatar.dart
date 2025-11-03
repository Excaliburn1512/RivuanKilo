import 'package:flutter/material.dart';
import 'package:rivu_v1/colors.dart';

class ProfileAvatar extends StatelessWidget {

  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.person, size: 60, color: Colors.grey.shade600),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary, //
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
