import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_assets.dart';
import 'videos_screen_state.dart';

class VideosScreenLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final VideosScreenState state;
  VideosScreenLogic({required this.state});

  final List<Map<String, dynamic>> filters = [
    {"title": "Position", "icon": AssetPath.player,},
    {"title": "Foot", "icon": AssetPath.player,},
    {"title": "Height", "icon": AssetPath.player,},
    {"title": "Age", "icon": AssetPath.player,},
    {"title": "Country", "icon": AssetPath.player,},
    {"title": "County (Romania)", "icon": AssetPath.player,},
    {"title": "Video Type", "icon": AssetPath.player,},
    {"title": "Under Contract", "icon": AssetPath.player,},
    {"title": "Available for Loan", "icon": AssetPath.player,},
    {"title": "Playing Style", "icon": AssetPath.player,},
    {"title": "Primary Position", "icon": AssetPath.player,},
    {"title": "Secondary Role", "icon": AssetPath.player,},
    {"title": "Nationality", "icon": AssetPath.player,},
    {"title": "Verified", "icon": AssetPath.player,},
    {"title": "Experience Level", "icon": AssetPath.player,},
    {"title": "League Level Played", "icon": AssetPath.player,},
    {"title": "Consistency", "icon": AssetPath.player,},
    {"title": "Acceleration", "icon": AssetPath.player,},
    {"title": "Speed", "icon": AssetPath.player,},
    {"title": "Strength", "icon": AssetPath.player,},
  ];
  final positions = [
    "Goalkeeper",
    "Defender – Left Back",
    "Defender – Center Back",
    "Midfielder – Central Midfielder",
    "Forward – Striker",
  ];

  TabController? tabController;
  RxString? selectedFilter = RxString("");
  final RxString selectedPosition = "".obs;



  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }


  chooseFilter(String filter){
    selectedFilter?.value = filter;
  }





}
