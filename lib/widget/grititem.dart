import 'package:flutter/material.dart';
class GridItemCard extends StatelessWidget {
  final Widget child; 
  final VoidCallback onTap; 
  const GridItemCard({Key? key, required this.child, required this.onTap})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), 
              blurRadius: 10, 
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
