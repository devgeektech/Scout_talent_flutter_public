import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/view/players_list/players_list_logic.dart';
import 'package:scouttalent2/view/players_list/players_list_state.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:sizer/sizer.dart';
import '../../backend/model/compare_model.dart';
import '../../backend/model/player_model.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';

class ComparePlayersScreen extends StatefulWidget {
  const ComparePlayersScreen({super.key});

  @override
  State<ComparePlayersScreen> createState() => _ComparePlayersScreenState();
}

class _ComparePlayersScreenState extends State<ComparePlayersScreen> {
  late PlayersListLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.put(PlayersListLogic(state: Get.find()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.getPlayerList(context,page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.bgColor,
      appBar: AppBar(
        leading: CommonBackButton(
          onTap: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<PlayersListLogic>(
        builder: (_) {
          final state = logic.state;
         /* if (state.leftPlayer == null) {
            return const Center(child: CircularProgressIndicator());
          }*/
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _playerSelectionRow(state),
                  const SizedBox(height: 15),
                  _playerComparisonCards(state),
                  const SizedBox(height: 15),
                  if (state.rightPlayer != null) _basicComparisonTable(state),
                  SizedBox(height: 2.h),
                  if (state.rightPlayer != null) _expandableStats(state),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _playerSelectionRow(PlayersListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                textAlign: TextAlign.center,
                heading: "Compare".tr,
                fontSize: Utils.responsiveFontSize(context, 20.sp),
                fontWeight: FontWeight.w500,
                color: ThemeProvider.whiteColor,
                fontFamily: "Montserrat",
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: ThemeProvider.primary),
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  logic.clearPlayers(context);
                },
                child: CommonTextWidget(
                  heading: "Clear".tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.whiteColor,
                ),
              ),


            ],
          ),
        ),

        Obx(() {
          final expanded = logic.isPlayersExpanded.value;
          return Container(
            constraints: BoxConstraints(maxHeight: Get.height * .3,minHeight: Get.height * .05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Flexible(child: expanded
                    ? AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child :NotificationListener<ScrollNotification>(
                      onNotification: logic.onScrollingPage,
                      child: GridView.builder(
                        shrinkWrap: true,
                        // physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                        ),
                        itemCount: logic.playerListBody.length,
                        itemBuilder: (_, index) {
                          final player = logic.playerListBody[index];
                          final isSelected = state.rightPlayer?.data?.id == player.playerId;
                          final isSelected1 = state.leftPlayer?.data?.id == player.playerId;
                          return _playerSelectorItem(player, isSelected,isSelected1);
                        },
                      ),
                    )
                )
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: logic.playerListBody.length > 5 ? 5 : logic.playerListBody.length,
                  itemBuilder: (_, index) {
                    final player = logic.playerListBody[index];
                    final isSelected = state.rightPlayer?.data?.id == player.playerId;
                    final isSelected1 = state.leftPlayer?.data?.id == player.playerId;
                    return _playerSelectorItem(player, isSelected,isSelected1);
                  },
                )),


                GestureDetector(
                  onTap: logic.isPlayersExpanded.toggle,
                  child: Container(
                    margin: EdgeInsets.only(right: 8,top: 2.h),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: AnimatedRotation(
                      turns: expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _playerComparisonCards(PlayersListState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: CommonTextWidget(
            textAlign: TextAlign.center,
            heading: "Player Comparison".tr,
            fontSize: Utils.responsiveFontSize(context, 20.sp),
            fontWeight: FontWeight.w500,
            color: ThemeProvider.whiteColor,
            fontFamily: "Montserrat",
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            GestureDetector(
              onTap: () {
                logic.initialUser = true;
                logic.selectedIndex = 0;
                logic.update();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(17)),
                    border: logic.selectedIndex == 0 ? Border.all(color: ThemeProvider.primary,width: 2) : null
                ),
                child:  state.leftPlayer != null ? _playerCard(state.leftPlayer!) : _emptyCard(),
              ),
            ),

            GestureDetector(
              onTap: () {
                logic.initialUser = false;
                logic.selectedIndex = 1;
                logic.update();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(17)),
                    border: logic.selectedIndex == 1 ? Border.all(color: ThemeProvider.primary,width: 2) : null
                ),
                child:state.rightPlayer != null ? _playerCard(state.rightPlayer!) : _emptyCard(),
              ),
            ),
            ],
        ),
      ],
    );
  }

  Widget _playerSelectorItem(CompareBody player, bool isSelected, bool isSelected1) {
    return GestureDetector(
      onTap: () {
        final leftId = logic.state.leftPlayer?.data?.id;
        final rightId = logic.state.rightPlayer?.data?.id;

        // 🚫 Prevent selecting same player for both
        if (logic.initialUser && player.playerId == rightId) {
          errorToast("This player is already selected for comparison.");
          return;
        }

        if (!logic.initialUser && player.playerId == leftId) {
          errorToast("This player is already selected for comparison.");
          return;
        }
        logic.getPlayerDetail(context, id: player.playerId!, initialUser: logic.initialUser);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: (isSelected || isSelected1) ? ThemeProvider.primary : Colors.transparent, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: player.avatar != null && player.avatar!.isNotEmpty
                    ? NetworkImage(Utils.imageUrl + player.avatar!)
                    : const AssetImage('assets/images/dummyPerson.png') as ImageProvider,
              ),
            ),
            //const SizedBox(height: 5),
            CommonTextWidget(
              maxLines: 1,
              textAlign: TextAlign.center,
              heading: "${player.firstName ?? ""} ${player.lastName ?? ""}",
              fontSize: Utils.responsiveFontSize(context, 12.sp),
              color: (isSelected || isSelected1) ? ThemeProvider.primary : ThemeProvider.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      width: Get.size.width * 0.4,
      height: Get.size.height * 0.2,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
      child: Icon(Icons.account_box_outlined, size: 50, color: Colors.white),
    );
  }

  Widget _playerCard(PlayerModel p) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Get.size.width * 0.4,
          height: Get.size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: p.data?.avatar != null && p.data!.avatar!.isNotEmpty
                  ? NetworkImage(Utils.imageUrl + p.data!.avatar!)
                  : const AssetImage('assets/images/dummyPerson.png') as ImageProvider,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        CommonTextWidget(
          textAlign: TextAlign.center,
          heading: "${p.data?.firstName ?? ""} ${p.data?.lastName ?? ""}",
          fontSize: Utils.responsiveFontSize(context, 18.sp),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _basicComparisonTable(PlayersListState s) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.20), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _tableRow("Age", s.leftPlayer?.data?.age.toString() ?? "N/A", s.rightPlayer?.data?.age.toString() ?? "N/A"),
            _divider(),
            _tableRow("Height", "${s.leftPlayer?.data?.height ?? "N/A"} cm", "${s.rightPlayer?.data?.height ?? "N/A"} cm"),
            _divider(),
            _tableRow("Weight", "${s.leftPlayer?.data?.weight ?? "N/A"} kg", "${s.rightPlayer?.data?.weight ?? "N/A"} kg"),
            _divider(),
            _tableRow("Preferred Foot", s.leftPlayer?.data?.preferredFoot ?? "N/A", s.rightPlayer?.data?.preferredFoot ?? "N/A"),
            _divider(),
            _tableRow(
              "Position",
              (s.leftPlayer?.data?.position?.toString().isNotEmpty ?? false)
                  ? s.leftPlayer!.data!.position.toString()
                  : "N/A",
              (s.rightPlayer?.data?.position?.toString().isNotEmpty ?? false)
                  ? s.rightPlayer!.data!.position.toString()
                  : "N/A",
            ),            _divider(),
            _tableRow("Nationality",
              (s.leftPlayer?.data?.nationality?.isNotEmpty ?? false)
                  ? s.leftPlayer!.data!.nationality!
                  : "N/A",
              (s.rightPlayer?.data?.nationality?.isNotEmpty ?? false)
                  ? s.rightPlayer!.data!.nationality!
                  : "N/A",
            ),          ],
        ),
      ),
    );
  }

  Widget _tableRow(String title, String leftValue, String rightValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonTextWidget(fontWeight: FontWeight.w400, heading: leftValue, fontSize: Utils.responsiveFontSize(context, 14.sp), color: Colors.white),
          CommonTextWidget(
            heading: title,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            color: ThemeProvider.primary,
            fontWeight: FontWeight.w600,
          ),
          CommonTextWidget(fontWeight: FontWeight.w400, heading: rightValue, fontSize: Utils.responsiveFontSize(context, 14.sp), color: Colors.white),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: Colors.white.withValues(alpha: 0.20));
  }

  Widget _expandableStats(PlayersListState s) {
    Map<String, dynamic> stats = {
      "Shooting": [s.leftPlayer?.data?.shooting ?? 0, s.rightPlayer?.data?.shooting ?? 0],
      "Passing": [s.leftPlayer?.data?.passing ?? 0, s.rightPlayer?.data?.passing ?? 0],
      "Dribbling": [s.leftPlayer?.data?.dribbling ?? 0, s.rightPlayer?.data?.dribbling ?? 0],
      "Ball Control": [s.leftPlayer?.data?.ballControl ?? 0, s.rightPlayer?.data?.ballControl ?? 0],
      "Speed": [s.leftPlayer?.data?.speed ?? 0, s.rightPlayer?.data?.speed ?? 0],
      "Strength": [s.leftPlayer?.data?.strength ?? 0, s.rightPlayer?.data?.strength ?? 0],
      "Stamina": [s.leftPlayer?.data?.stamina ?? 0, s.rightPlayer?.data?.stamina ?? 0],
      "Agility": [s.leftPlayer?.data?.agility ?? 0, s.rightPlayer?.data?.agility ?? 0],
      "Tackling": [s.leftPlayer?.data?.tackling ?? 0, s.rightPlayer?.data?.tackling ?? 0],
      "Vision": [s.leftPlayer?.data?.vision ?? 0, s.rightPlayer?.data?.vision ?? 0],
      "Off-the-ball Movement": [s.leftPlayer?.data?.offBallMovement ?? 0, s.rightPlayer?.data?.offBallMovement ?? 0],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...stats.entries.map((entry) {
          final statName = entry.key;
          final values = entry.value;

          return _statRow(statName.tr, values[0], values[1]);
        }),
      ],
    );
  }

  Widget _statRow(String stat, num left, num right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CommonTextWidget(
                fontWeight: FontWeight.w400,
                fontSize: Utils.responsiveFontSize(context, 14.sp),
                heading: "$left",
                color: Colors.white,
                textAlign: TextAlign.center,
              ),

              const SizedBox(width: 6),

              Expanded(child: _bar(left, left >= 50 ? ThemeProvider.primary : ThemeProvider.yellowish)),
              const SizedBox(width: 6),

              CommonTextWidget(
                heading: stat,
                fontSize: Utils.responsiveFontSize(context, 14.sp),
                color: ThemeProvider.primary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 6),

              Expanded(child: _bar(right, right >= 50 ? ThemeProvider.primary : ThemeProvider.yellowish)),

              const SizedBox(width: 6),

              CommonTextWidget(
                heading: "$right",
                fontWeight: FontWeight.w400,

                fontSize: Utils.responsiveFontSize(context, 14.sp),
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(num value, Color color) {
    return Container(
      height: 7,
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(4)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value / 100,
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}


class CompareBodyChecker {
  final String id;

  CompareBodyChecker({required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CompareBody && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

