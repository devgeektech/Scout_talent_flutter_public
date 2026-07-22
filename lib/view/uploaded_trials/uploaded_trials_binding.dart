import 'package:get/get.dart';

import 'uploaded_trials_logic.dart';

class UploadedTrialsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UploadedTrialsLogic(state: Get.find()));
  }
}