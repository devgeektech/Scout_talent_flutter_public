import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/model/playerAllVideosList.dart';
import '../../main.dart';
import '../../widget/commomLoader.dart';
import 'player_all_videos_state.dart';

class PlayerAllVideosLogic extends GetxController {
  final PlayerAllVideosState state;
  PlayerAllVideosLogic({required this.state});

  List<PlayerAllVideosData> playerVideosList = [];
  int currentPage = 1;
  PlayerAllVideosRes playerAllVideosRes = PlayerAllVideosRes();
  String playerId = "";


  @override
  void onInit() {
    super.onInit();
    playerId = Get.arguments;
    print("playerId:::$playerId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPlayersAllVideosList(getContext, page: currentPage);
    });

  }

  getPlayersAllVideosList(BuildContext context, {required int page}) async{
    if (context.mounted && page == 1) LoaderDialog.show(context);
    final response = await state.latestVideos(page,playerId);
    if (context.mounted && page == 1) LoaderDialog.hide(context);

    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);

      playerAllVideosRes = PlayerAllVideosRes.fromJson(myMap);

      if (page == 1) {
        playerVideosList.clear();
      }
      playerVideosList.addAll(playerAllVideosRes.data ?? []);
      update();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }

  bool onScrollingPage(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${playerAllVideosRes.totalRecord.toString()}");
      int listItems = playerAllVideosRes.totalRecord ?? - playerVideosList.length;
      if (listItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          getPlayersAllVideosList(getContext, page: currentPage);
        });
      } else {}
    }
    return false;
  }
}
