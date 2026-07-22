import 'package:flutter/material.dart';

class CommonBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const CommonBackButton({
    super.key,
    required this.onTap,
    this.color = Colors.white,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.arrow_back_ios,
        color: color,
        size: size,
      ),
    );
  }
}
