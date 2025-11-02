import 'package:flutter/material.dart';

class PlantGridItem extends StatelessWidget {
  const PlantGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.asset(
        "assets/placeholder/plant.png",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(Icons.local_florist, color: Colors.grey[600]),
            ),
          );
        },
      ),
    );
  }
}
