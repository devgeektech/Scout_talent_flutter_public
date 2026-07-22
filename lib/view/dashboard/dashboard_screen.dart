import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../view/dashboard/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        if (controller.pages.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          body: controller.pages[controller.currentIndex.value],
          bottomNavigationBar: _buildBottomNavBar(controller),
        );
      },
    );
  }

  Widget _buildBottomNavBar(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.currentIndex.value,
          selectedItemColor: ThemeProvider.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => controller.updateIndex(index),
          items: _bottomNavItems(controller),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavItems(DashboardController controller) {
    Color selected = ThemeProvider.primary;
    Color unselected = Colors.grey;

    // Helper to colorize SVG icons
    BottomNavigationBarItem item(String asset, String label, bool isSelected) {
      return BottomNavigationBarItem(
        icon: SvgPicture.asset(
          asset,
          color: isSelected ? selected : unselected,
        ),
        label: "",
      );
    }

    int i = controller.currentIndex.value;

    switch (controller.userRole) {

    /// PLAYER ROLE
      case UserRole.player:
        return [
          item(AssetPath.dashboard, "Dashboard", i == 0),
          item(AssetPath.videos, "Videos", i == 1),
          item(AssetPath.chat, "Chat", i == 2),
          item(AssetPath.settings, "Settings", i == 3),
        ];

    /// CLUB SCOUT ROLE
      case UserRole.clubScout:
        return [
          item(AssetPath.dashboard, "Dashboard", i == 0),
          item(AssetPath.search, "Search", i == 1),
          item(AssetPath.chat, "Chat", i == 2),
          item(AssetPath.settings, "Settings", i == 3),
        ];

    /// ACADEMY / AGENT ROLE
      case UserRole.academy:
      case UserRole.agent:
        return [
          item(AssetPath.dashboard, "Dashboard", i == 0),
          item(AssetPath.videos, "Videos", i == 1),
          item(AssetPath.players, "Add Players", i == 2),
          item(AssetPath.chat, "Chat", i == 3),
          item(AssetPath.settings, "Settings", i == 4),
        ];
    }
  }
}
