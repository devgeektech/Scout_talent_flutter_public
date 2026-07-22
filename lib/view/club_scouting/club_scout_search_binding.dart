import 'package:get/get.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_search__logic.dart';

class ClubScoutSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ClubScoutSearchLogic(parser: Get.find()),
    );
  }
}



