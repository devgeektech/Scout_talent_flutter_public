import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/theme.dart';
import 'commontext.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 3.w),
          decoration: BoxDecoration(
            color: isSelected ? ThemeProvider.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: CommonTextWidget(
              heading: title,
              fontSize: 16.sp,
              fontFamily: "Montserrat",
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
