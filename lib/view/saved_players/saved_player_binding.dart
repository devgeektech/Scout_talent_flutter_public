import 'package:get/get.dart';
import 'package:scouttalent2/view/saved_players/saved_player_logic.dart';


class SavedPlayersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedPlayerLogic(state: Get.find()));
  }
}
