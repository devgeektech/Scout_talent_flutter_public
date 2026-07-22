import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/get_saved_list_model.dart';
import '../../backend/model/playerActivityModel.dart';
import '../../main.dart';
import '../../widget/commomLoader.dart';
import 'player_activity_page_state.dart';

class PlayerActivityPageLogic extends GetxController {
  final PlayerActivityPageState state;
  PlayerActivityPageLogic({required this.state});



  //GetSavedListModel getSavedPlayerListModel = GetSavedListModel();
  PlayerActivityResponse playerActivityResponse = PlayerActivityResponse();
  List<PlayerActivitiesData> playerActivitiesList = [];
  int currentPage = 1;
  RxString selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedCredentials();
      getPlayersActivitiesList(getContext, page: currentPage);
    });

  }

  Future<void> loadSavedCredentials() async {
    String? langCode = state.getLanguage();
    print("langCode====>$langCode");
    if (langCode.isNotEmpty) {
      selectedLanguage.value = langCode;
      Get.updateLocale(Locale(langCode));
    } else {
      selectedLanguage.value = 'en';
      Get.updateLocale(const Locale('en'));
    }
    update();
  }

  getPlayersActivitiesList(BuildContext context, {required int page}) async{
    if (context.mounted && page == 1) LoaderDialog.show(context);
    final response = await state.activitiesList(page);
    if (context.mounted && page == 1) LoaderDialog.hide(context);

    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);

      playerActivityResponse = PlayerActivityResponse.fromJson(myMap);

      if (page == 1) {
        playerActivitiesList.clear();
      }
      playerActivitiesList.addAll(playerActivityResponse.data ?? []);
      update();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }

  bool onScrollingPage(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${playerActivityResponse.totalRecord.toString()}");
      int listItems = playerActivityResponse.totalRecord ?? - playerActivitiesList.length;
      if (listItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          getPlayersActivitiesList(getContext, page: currentPage);
        });
      } else {}
    }
    return false;
  }
}
