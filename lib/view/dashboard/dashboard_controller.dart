import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/main.dart';
import 'package:scouttalent2/view/chat_inbox/chat_inbox_view.dart';
import 'package:scouttalent2/view/players_list/players_list_view.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';
import '../club_scouting/club_scout_seach_page.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import 'dashboard_parser.dart';

class DashboardController extends GetxController {

  final DashboardParser parser;
  DashboardController({required this.parser});

  UserRole userRole = UserRole.player; // default
  var currentIndex = 0.obs;
  List<Widget> pages = [];

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    refreshFcmToken(getContext);
  }

  void updateIndex(int index) {
    currentIndex.value = index;
    update();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("selectedUserRole");
    // role='academy';
    debugPrint("current role is $role");
    if (role != null) {
      switch (role) {
        case "player":
          userRole = UserRole.player;
          break;
        case "scout":
          userRole = UserRole.clubScout;
          break;
        case "club":
          userRole = UserRole.academy;
          break;
        case "agent":
          userRole = UserRole.agent;
          break;
      }
    }

    pages = _getPages(userRole);
    update();
  }

  List<Widget> _getPages(UserRole role) {
    switch (role) {
      case UserRole.player:
        return [
          HomeScreen(),
          VideosScreenPage(),
          ChatInboxPage(),
          ProfileScreen(),
        ];

      case UserRole.clubScout:
        return [
          HomeScreen(),
          ClubScoutSearchPage(),
          ChatInboxPage(),
          ProfileScreen(),
        ];

      case UserRole.academy:
      case UserRole.agent:
        return [
          HomeScreen(),
          VideosScreenPage(),
          PlayersListPage(),
          ChatInboxPage(),
          ProfileScreen(),
        ];
    }
  }


  Future<void> refreshFcmToken(BuildContext context) async {
    final response = await parser.apiService.putDataHeaders(
      "$notifications/refreshFcm", // backend endpoint
      data: {
        "fcmToken": parser.getFCM(),
      },
    );

    print("tokenn on referesh----->${parser.getFCM()}");
    if (response != null && response.statusCode == 200) {
      debugPrint('FCM token updated successfully');
    }
  }
}
enum UserRole {
  player,
  clubScout,
  academy,
  agent,
}
