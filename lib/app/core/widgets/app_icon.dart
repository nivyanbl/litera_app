import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor; 
  final Color iconColor;       
  final double size;
  final double iconSize;
  final Color borderColor;
  final double borderWidth;

  const AppIcon({
    super.key,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.iconColor =  Colors.black,
    this.size = 40,
    this.iconSize = 18,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize
      ),
    );
  }
}