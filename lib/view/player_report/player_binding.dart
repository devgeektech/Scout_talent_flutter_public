import 'package:get/get.dart';

import 'player_report_logic.dart';

class PlayerReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => PlayerReportController(parser: Get.find()),
    );
  }
}
