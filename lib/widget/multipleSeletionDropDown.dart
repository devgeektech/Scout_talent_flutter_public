import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/theme.dart';
import '../utils/utils.dart';

class MultiSelectDropdown extends StatefulWidget {
  final String? hintText;
  final List<String> items;
  final List<String> selectedValues;
  final ValueChanged<List<String>>? onChanged;

  const MultiSelectDropdown({
    super.key,
    this.hintText,
    required this.items,
    required this.selectedValues,
    this.onChanged,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(covariant MultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValues != widget.selectedValues) {
      setState(() {
        _selectedValues = List.from(widget.selectedValues);
      });
    }
  }

  Future<void> _showMultiSelectDialog() async {
    final List<String> selectedValues = List.from(_selectedValues);
    final List<String> items = widget.items;

    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ThemeProvider.whiteColor,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.hintText ?? 'Select options',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "SourceSansRegular",
                        color: ThemeProvider.hintText,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 40.h,
                      child: ListView(
                        children: items.map((item) {
                          return CheckboxListTile(
                            title: Text(item),
                            value: selectedValues.contains(item),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected != null) {
                                  if (selected) {
                                    selectedValues.add(item);
                                  } else {
                                    selectedValues.remove(item);
                                  }
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close without saving
                          },
                          child: Text('Cancel'.tr,style: TextStyle(color: ThemeProvider.blackColor),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(selectedValues);
                          },
                          child: Text('Done'.tr,style: TextStyle(color: ThemeProvider.blackColor),),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedValues = result;
      });
      widget.onChanged?.call(List.from(_selectedValues));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showMultiSelectDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
          fillColor: ThemeProvider.whiteColor,
          filled: true,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ThemeProvider.blackColor.withOpacity(0.2),
              width: 0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedValues.isEmpty
                    ? widget.hintText ?? 'Select options'
                    : _selectedValues.join(', '),
                style: _selectedValues.isEmpty
                    ? TextStyle(
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  fontFamily: "Montserrat",
                  color: ThemeProvider.hintText,
                )
                    : TextStyle(
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  fontFamily: "Montserrat",
                  color: ThemeProvider.hintText,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
