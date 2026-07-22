import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'manage_videos_state.dart';

class ManageVideosLogic extends GetxController {
  final ManageVideosState state;
  ManageVideosLogic({required this.state});

  String? selectedRelation;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Method to toggle selected relation
  void updateSelectedRelation(String value) {
    selectedRelation = value;
    update(); // Trigger UI update using GetBuilder
  }
}
