import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/getClubPlayerList.dart';
import 'package:scouttalent2/backend/model/getClubPlayerList.dart' as player;
import 'package:sizer/sizer.dart';
import '../../backend/model/compare_model.dart';
import '../../backend/model/get_player_list_model.dart';
import '../../backend/model/player_model.dart';
import '../../main.dart';
import '../../utils/app_assets.dart';
import '../../utils/paginationHelper.dart';
 import '../../utils/string.dart';
import '../../utils/theme.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import 'players_list_state.dart';


class PlayersListLogic extends GetxController {
  final PlayersListState state;

  PlayersListLogic({required this.state});

  var playersList = <player.ClubPlayers>[].obs;

  int currentPage = 1;
  int totalCount = 0;
  TextEditingController searchPlayerController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  RxString? selectedFilter = RxString("");

  CompareModel getAllPLayerListModel = CompareModel();
  List<CompareBody> playerListBody = [];
  bool initialUser = true;
  int selectedIndex = -1;
  Timer? _debounce;

  RxBool isPlayersExpanded = false.obs;
  GetClubPlayersList getClubPlayersList = GetClubPlayersList();

  chooseFilter(String filter) {
    selectedFilter?.value = filter;
  }

  getClubPlayersApi(BuildContext context, {int? currentPage}) async {
    if (context.mounted && currentPage == 1) LoaderDialog.show(context);
    await state
        .getClubPlayers(
          page: currentPage,
          search: searchPlayerController.text.trim(),
          position: state.primaryPosition.value,
          foot: state.playerFoot.value,
          height: state.playerHeight.value,
          weight: state.playerWeight.value,
          age: Utils.convert(state.playerAge.value),
          country: toCamelCase(state.playerCountry.value),
          county: state.playerCounty.value,
          underContract: state.playerUnderContract.value,
          availableForLoan: state.playerAvailableForLoan.value,
          nationality: toCamelCase(state.playerNationality.value),
          experience: toCamelCase(state.playerExperienceLevel.value),
          consistency: state.playerConsistency.value,
          playingStyle: state.playingStyle,
          technicalAttributes: state.technicalAttribute,
          secondaryPosition: state.secondaryRole,
        )
        .then((value) async {
          if (context.mounted && currentPage == 1) LoaderDialog.hide(context);
          if (value != null && value.statusCode == 200) {
            getClubPlayersList = GetClubPlayersList.fromJson(value.data);
            if (currentPage == 1) {
              playersList.clear();
            }
            playersList.addAll(getClubPlayersList.data ?? []);
            totalCount = getClubPlayersList.totalRecord ?? 0;
            update();
          }
        });
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      (searchPlayerController.text);
      currentPage = 1;
      getClubPlayersApi(getContext, currentPage: currentPage);
      FocusManager.instance.primaryFocus!.unfocus();
    });
  }

  bool onScrollingPage(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${getClubPlayersList.totalRecord.toString()}");
      int listItems = getClubPlayersList.totalRecord ?? -playerListBody.length;
      if (listItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          getClubPlayersApi(getContext, currentPage: currentPage);
        });
      }
    }
    return false;
  }

  Future<void> deletePlayer(String playerId, int index, BuildContext context) async {
    LoaderDialog.show(context);
    final response = await state.deleteClubPlayers(playerId: playerId);
    if (context.mounted) LoaderDialog.hide(context);
    if (response != null && response.statusCode == 200) {
      // Remove from local list immediately
      playersList.removeAt(index);
      if (totalCount > 0) {
        totalCount = totalCount - 1;
      }
      // refresh UI instantly
      update();

      //Show success dialog
      showCommonDialog(
        closeIconColor: ThemeProvider.blackColor,
        bgColor: ThemeProvider.whiteColor,
        titleColor: ThemeProvider.blackColor,
        messageColor: ThemeProvider.textColor,
        showCloseButton: true,
        circleSize: 80,
        context: Get.context!,
        title: "Success!",
        message: "Your Player has been deleted successfully from the list.",
        svgAsset: AssetPath.successFilled,
      );
    } else {
      errorToast("Failed to delete player");
    }
  }


  int playerLimit = 0;
  bool isUnlimited = false;
  bool hasSubscription = false;
  RxString subscriptionStatus = "".obs;

  void loadPlayerLimit() {
    playerLimit =
        state.sharedPreferencesManager.getInt(AppString.playerLimit) ?? 0;
    isUnlimited = state.sharedPreferencesManager.getBool("isUnlimited");
    hasSubscription = state.sharedPreferencesManager.getBool("hasSubscription");
    subscriptionStatus.value = state.sharedPreferencesManager.getString("subscriptionStatus")!;
    update();
  }

  void scrollListener(BuildContext context) {
    PaginationHelper.handleScroll(
      controller: scrollController,
      limit: state.limit,
      currentPage: currentPage,
      totalCount: totalCount,
      isLoading: isLoading,
      fetchData: (page) async {
        await getClubPlayersApi(context, currentPage: page);
      },
      onUpdateState: (page, loading) {
        currentPage = page;
        isLoading = loading;
        update();
      },
    );
  }

  getPlayerDetail(BuildContext context, {required bool initialUser, required String id}) {
    if (context.mounted && initialUser) LoaderDialog.show(context);
    state.fetchingPlayerDetail(id).then((value) {
      if (context.mounted && initialUser) LoaderDialog.hide(context);
      if (value != null && value.statusCode == 200) {
        // first user details
        if (initialUser) {
          state.leftPlayer = null;
          state.leftPlayer = PlayerModel.fromJson(value.data);
          setLeftPlayer(state.leftPlayer!);
        }
        // second user details
        else {
          state.rightPlayer = null;
          state.rightPlayer = PlayerModel.fromJson(value.data);
          setRightPlayer(state.rightPlayer!);
        }
        update();
      }
    });
  }

  void setLeftPlayer(PlayerModel player) {
    state.leftPlayer = player;
    update();
  }

  void setRightPlayer(PlayerModel player) {
    state.rightPlayer = player;
    update();
  }

  Future<void> getPlayerList(BuildContext context, {required int page}) async {
    if (context.mounted && page == 1) LoaderDialog.show(context);
    final response = await state.fetchingPlayList(page.toString());
    if (context.mounted && page == 1) LoaderDialog.hide(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      if (page == 1) playerListBody.clear();
      getAllPLayerListModel = CompareModel.fromJson(myMap);
      playerListBody.addAll(getAllPLayerListModel.data!);
      update();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }

  clearPlayers(BuildContext context) async {
    if (context.mounted) LoaderDialog.show(context);
    final response = await state.clearFilter();
    if (context.mounted) LoaderDialog.hide(context);
    if (response != null && response.statusCode == 200) {
      Get.back();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }
}
