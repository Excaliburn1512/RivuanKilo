import 'package:flutter/material.dart';

class LiveCameraView extends StatelessWidget {
  const LiveCameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.asset(
        "assets/placeholder/fish_camera.png",
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.videocam_off, color: Colors.grey[600]),
            ),
          );
        },
      ),
    );
  }
}
