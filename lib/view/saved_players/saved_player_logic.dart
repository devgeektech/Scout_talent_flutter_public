import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/main.dart';
import 'package:scouttalent2/view/saved_players/saved_player_state.dart';

import '../../backend/model/get_saved_list_model.dart';
import '../../widget/commomLoader.dart';


class SavedPlayerLogic extends GetxController {
  final SavedPlayerState state;
  SavedPlayerLogic({required this.state});


  GetSavedListModel getSavedPlayerListModel = GetSavedListModel();
  List<SavedListBody> savedPlayerList = [];
  int currentPage = 1;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSavePlayerList(getContext, page: currentPage);
    });

  }


  getSavePlayerList(BuildContext context, {required int page}) async{
    if (context.mounted && page == 1) LoaderDialog.show(context);
    final response = await state.fetchingSavedPlayList(page);
    if (context.mounted && page == 1) LoaderDialog.hide(context);

    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);

      getSavedPlayerListModel = GetSavedListModel.fromJson(myMap);

      if (page == 1) {
        savedPlayerList.clear();
      }
      savedPlayerList.addAll(getSavedPlayerListModel.data ?? []);
      update();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }

  bool onScrollingPage(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${getSavedPlayerListModel.totalRecord.toString()}");
      int listItems = getSavedPlayerListModel.totalRecord ?? - savedPlayerList.length;
      if (listItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          getSavePlayerList(getContext, page: currentPage);
        });
      } else {}
    }
    return false;
  }

  clearSavedPlayers(BuildContext context) async {
    if (context.mounted) LoaderDialog.show(context);
    final response = await state.clearSaved();
    if (context.mounted) LoaderDialog.hide(context);
    if (response != null && response.statusCode == 200) {
      Get.back();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }
}
