import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart'; // <-- For SVG
import '../utils/theme.dart';
import '../utils/utils.dart';

class CustomDropdownButton extends StatelessWidget {
  final bool translateItems; // NEW
  final String? hintText;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool isExpanded;
  final FocusNode? focusNode;

  /// Optional leading SVG icon
  final String? svgIconPath;
  final double? svgIconSize;

  const CustomDropdownButton({
    super.key,
    this.hintText,
    this.focusNode,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.onSaved,
    this.validator,
    required this.isExpanded,
    this.svgIconPath,
    this.svgIconSize,
    this.translateItems = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField2<String>(
              focusNode: focusNode,
              isExpanded: isExpanded,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: ThemeProvider.primary),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: ThemeProvider.blackColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: ThemeProvider.blackColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                fillColor: ThemeProvider.whiteColor,
                filled: true,
              ),
              hint: Row(
                children: [
                  if (svgIconPath != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        svgIconPath!,
                        width: svgIconSize ?? 20,
                        height: svgIconSize ?? 20,
                        color: ThemeProvider.hintText,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      hintText?.tr ?? 'Select an option',
                      style: TextStyle(
                        fontSize: Utils.responsiveFontSize(context, 16.sp),
                        fontFamily: "Montserrat",
                        color: ThemeProvider.hintText,
                      ),
                    ),
                  ),
                ],
              ),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  translateItems ? item.tr : item,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    color: ThemeProvider.hintText,
                  ),
                ),
              ))
                  .toList(),
              // value: translateItems ? selectedValue?.tr : selectedValue,
              value: selectedValue,        // ✅ NOT translated

              onChanged: onChanged,
              onSaved: onSaved,
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded, // Always on right
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                overlayColor: WidgetStatePropertyAll(ThemeProvider.whiteColor),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: Utils.responsiveFontSize(context, 14.sp),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
