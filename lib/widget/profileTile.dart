import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scouttalent2/widget/commontext.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:sizer/sizer.dart';

class ProfileTile extends StatelessWidget {
  final dynamic icon; // Can be String (SVG path) or Widget
  final String title;
  final VoidCallback? onTap;
  final bool? isRead;
  final bool? toggle;

  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isRead,
    this.toggle,
    this.toggleValue,
    this.onToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (icon is String) {
      // Treat as SVG path
      leadingWidget = SvgPicture.asset(icon);
    } else if (icon is Widget) {
      leadingWidget = icon;
    } else {
      leadingWidget = const SizedBox.shrink();
    }
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: leadingWidget,
          title: CommonTextWidget(
            heading: title,
            color:isRead == true ?Colors.red:  ThemeProvider.blackColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
          trailing: toggle == true
              ?Switch(
            value: toggleValue ?? false,
            onChanged: onToggleChanged,
            thumbColor:
            WidgetStateProperty.all(Colors.white),
            trackColor:
            WidgetStateProperty.resolveWith(
                  (states) => states
                  .contains(WidgetState.selected)
                  ? ThemeProvider.primary
                  : Colors.grey.shade400,
            ),
          )

              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        title == "Account Settings"
        ?SizedBox.shrink()
        :Divider(
          color: ThemeProvider.blackColor.withAlpha(10),
        ),
      ],
    );
  }
}
