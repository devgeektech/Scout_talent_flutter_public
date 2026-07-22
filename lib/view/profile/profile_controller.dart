import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/view/profile/profile_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend/model/ProfileResponseModel.dart';
import '../../backend/model/addPlayerFields/careerFields.dart';
import '../../backend/model/addPlayerFields/trophyFields.dart';
import '../../backend/model/add_note_model.dart';
import '../../backend/model/getClubPlayerList.dart';

import 'package:scouttalent2/backend/model/getClubPlayerList.dart' as player;

import '../../backend/model/get_saved_list_model.dart';
import '../../backend/model/update_player_profile.dart';
import '../../utils/api_exception.dart';
import '../../utils/constants.dart';
import '../../utils/string.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../add_player_screen/add_player_screen_logic.dart';

class  ProfileController extends GetxController with WidgetsBindingObserver {
  final ProfileParser parser;

  ProfileController({required this.parser});

  RxString subscriptionStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(Get.context!);
    loadNotificationStatus(); // ✅ restore saved value first

    WidgetsBinding.instance.addObserver(this);
    initNotificationStatus();
    ever(isUnder18, (value) {
      if (value == false) {
        clearParentFields();
      }
    });
  }
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }


  /// 🔄 Called when user returns from App Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        try {
          final settings = await FirebaseMessaging.instance.getNotificationSettings();
          final prefs = await SharedPreferences.getInstance();

          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            notificationsEnabled.value = true;
            await prefs.setBool('notifications_enabled', true);
          } else {
            notificationsEnabled.value = false;
            await prefs.setBool('notifications_enabled', false);
            // Optionally show a UI prompt to guide user
          }
        } catch (e) {
          debugPrint("Error checking notification permission: $e");
          notificationsEnabled.value = false;
        }
      });
    }
  }

  Future<void> saveNotificationStatus(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', isEnabled);
  }
  Future<void> loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('notifications_enabled');
    if (saved != null) {
      notificationsEnabled.value = saved;
    }
  }


  Future<void> initNotificationStatus() async {
    final status = await Permission.notification.status;
    notificationsEnabled.value = status.isGranted;
  }


  final RxBool notificationsEnabled = false.obs;



  Future<void> toggleNotifications(bool enable, BuildContext context) async {
    if (enable) {
      final result = await AppSettings.Permission.notification.request();
      if (result.isGranted) {
        notificationsEnabled.value = true;
        await saveNotificationStatus(true);
      } else {
        notificationsEnabled.value = false;
        await saveNotificationStatus(false);
        _showSettingsDialog(context);
      }
    } else {
      _showDisableDialog(context);
    }
  }


  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enable Notifications"),
        content: const Text(
          "Please enable notifications from app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void _showDisableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Disable Notifications"),
        content: const Text(
          "To disable notifications, please turn them off from app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              notificationsEnabled.value = true;
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }


  final GlobalKey firstNameKey = GlobalKey();
  final GlobalKey lastNameKey = GlobalKey();
  final GlobalKey emailKey = GlobalKey();
  final GlobalKey dobKey = GlobalKey();
  final GlobalKey careerKey = GlobalKey();
  final GlobalKey youtubeKey = GlobalKey();
  final GlobalKey trophiesKey = GlobalKey();
  final GlobalKey parentsKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  RxString selectedPreferredFoot = ''.obs;

  final Rx<ProfileResModel?> profile = Rx<ProfileResModel?>(null);
  // List of positions
  final List<Position> positions = const [
    Position(en: 'Goalkeeper', ro: 'Portar'),
    Position(en: 'Right Back', ro: 'Fundas dreapta'),
    Position(en: 'Left Back', ro: 'Fundas stanga'),
    Position(en: 'Center Back', ro: 'Fundas central'),
    Position(en: 'Defensive Midfield', ro: 'Mijlocas defensiv'),
    Position(en: 'Right Wing/Forward', ro: 'Extrema dreapta/Atacant'),
    Position(en: 'Central Midfield', ro: 'Mijlocas central'),
    Position(en: 'Striker', ro: 'Atacant'),
    Position(en: 'Attacking Midfield', ro: 'Mijlocas ofensiv'),
    Position(en: 'Left Wing/Forward', ro: 'Extrema stnga/Atacant'),
    Position(en: 'Right Midfielder', ro: 'Mijlocaș dreapta'),
    Position(en: 'Left Midfielder', ro: 'Mijlocaș stânga'),
  ];



  RxBool allFieldsValid = false.obs;


  // Currently selected position
  Position? selectedPosition;

  // Update by English name
  //Update selected position
  void updateSelectedPositionByEn(String en) {
    selectedPosition = positions.firstWhere((p) => p.en == en);
    update();
  }

  void updateSelectedPositionByRo(String ro) {
    selectedPosition = positions.firstWhere((p) => p.ro == ro);
    update();
  }
  RxString selectedExperienceLevel = ''.obs;

  final Map<String, String> experienceLevelMap = {
    'Professional': 'experience_level_professional'.tr,
    'SemiProfessional': 'experience_level_semi_professional'.tr,
    'Amateur': 'experience_level_amateur'.tr,
  };
  RxList<TrophyFields> trophies = <TrophyFields>[].obs;


  //Playing Style
  final List<SecondaryPosition> playingStyle = const [
    SecondaryPosition(en: 'Ball Winner', ro: 'Recuperator de minge', value: 'ballWinner',),
    SecondaryPosition(en: 'Box-to-Box Midfielder', ro: 'Mijlocaș box-to-box', value: 'boxToBoxMidfielder',),
    SecondaryPosition(en: 'Target Man', ro: 'Atacant de referință', value: 'targetMan',),
    SecondaryPosition(en: 'Playmaker', ro: 'Coordonator de joc', value: 'playmaker',),
    SecondaryPosition(en: 'Pace Winger', ro: 'Extremă rapidă', value: 'paceWinger',),
    SecondaryPosition(en: 'Inverted Winger', ro: 'Extremă inversată', value: 'invertedWinger',),
    SecondaryPosition(en: 'Poacher', ro: 'Atacant oportunist', value: 'poacher',),
    SecondaryPosition(en: 'Pressing Forward', ro: 'Atacant de pressing', value: 'pressingForward',),
    SecondaryPosition(en: 'Sweeper Keeper', ro: 'Portar-libero', value: 'sweeperKeeper',),
  ];



  bool get hasPrefilledCareerStats {
    bool isFilled(String? v) =>
        v != null &&
            v.trim().isNotEmpty &&
            v.trim() != '0' &&
            v.trim().toLowerCase() != 'null';

    return [
      matchPlayedController.text,
      goalsController.text,
      assistsController.text,
      minutesController.text,
    ].any(isFilled);
  }


// Assuming positions is List<SecondaryPosition>

// Consistency options
  final Map<String, String> consistencyMap = {
    'Low': 'consistency_low'.tr,
    'Medium': 'consistency_medium'.tr,
    'High': 'consistency_high'.tr,
  };

// Stores the selected key (English) for API
  RxString selectedConsistency = ''.obs;

// Update method
  void updateSelectedConsistency(String key) {
    selectedConsistency.value = key;
    update();
  }
  // Add new trophy field

  bool areAllTrophyFieldsCompleted() {
    return trophies.every((field) {
      return field.trophyNameController.text.trim().isNotEmpty &&
          field.trophyYearController.text.trim().isNotEmpty &&
          // field.trophyImage != null &&
          field.trophyImageFileName != null;
    });
  }
  void addNewTrophyField() {
    if (!areAllTrophyFieldsCompleted()) {
      successToast("Please complete all trophy details before adding a new trophy.");
      return;
    }
    final newTrophy = TrophyFields(
      trophyNameController: TextEditingController(),
      trophyYearController: TextEditingController(),
      trophyImage: null, // Start with no image
      trophyImageFileName: null, // Start with no image
    );
    trophies.add(newTrophy);
    update(); // Optional if using Obx
  }

  // Remove trophy field at index
  void removeTrophyField(int index) {
    if (index >= 0 && index < trophies.length) {
      trophies.removeAt(index);
      update(); // Optional if using Obx
    }
  }



  final List<SecondaryPosition> technicalAttributes = const [
    SecondaryPosition(en: 'Passing', ro: 'Pasare', value: 'passing'),
    SecondaryPosition(en: 'Dribbling', ro: 'Dribling', value: 'dribbling'),
    SecondaryPosition(en: 'Shooting', ro: 'Șut', value: 'shooting'),
    SecondaryPosition(en: 'Ball Control', ro: 'Controlul mingii', value: 'ballControl'),
    SecondaryPosition(en: 'First Touch', ro: 'Prima atingere', value: 'firstTouch'),
    SecondaryPosition(en: 'Vision', ro: 'Viziune', value: 'vision'),
    SecondaryPosition(en: 'Technique', ro: 'Tehnică', value: 'technique'),
    SecondaryPosition(en: 'Crossing', ro: 'Centrare', value: 'crossing'),
    SecondaryPosition(en: 'Finishing', ro: 'Finalizare', value: 'finishing'),
    SecondaryPosition(en: 'Long Shots', ro: 'Șuturi de la distanță', value: 'longShots'),
    SecondaryPosition(en: 'Tackling', ro: 'Abordarea', value: 'tackling'),
    SecondaryPosition(en: 'Heading', ro: 'Joc aerian', value: 'heading'),
    SecondaryPosition(en: 'Marking', ro: 'Marcaj', value: 'marking'),
  ];
  final RxList<SecondaryPosition> selectedTechnicalAttributes = <SecondaryPosition>[].obs;
  final RxList<String> selectedTechnicalAttributesValues = <String>[].obs;


  void updateSelectedExperienceLevel(String value) {
    selectedExperienceLevel.value = value;
    update();
  }


  void updateSelectedTechnicalAttributes(
      List<String> selectedLabels,
      bool isEnglish,
      ) {
    final selectedItems = technicalAttributes.where((p) {
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedTechnicalAttributes.assignAll(selectedItems);
    selectedTechnicalAttributesValues.assignAll(
      selectedItems.map((e) => e.value).toList(),
    );

    debugPrint("Selected Technical API Values: $selectedTechnicalAttributesValues");
  }

  final RxList<SecondaryPosition> selectedPlayingStyle = <SecondaryPosition>[].obs;
  final RxList<String> selectedPlayingStyleValues = <String>[].obs;
  List<String> transferStatus = ["Available","Free Agent","On Loan"];
  RxString SelectedtransferStatus = ''.obs;
  RxString selectedLanguage = 'en'.obs;
  void updateSelectedPlayingStyle(
      List<String> selectedLabels,
      bool isEnglish,
      ) {
    final selectedItems = playingStyle.where((p) {   // ✅ CORRECT LIST
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedPlayingStyle.assignAll(selectedItems);
    selectedPlayingStyleValues.assignAll(
      selectedItems.map((e) => e.value).toList(),     // ✅ CORRECT API VALUE
    );

    debugPrint("Selected Playing Style API Values: $selectedPlayingStyleValues");
  }

  final List<SecondaryPosition> secondaryPositions = const [
    SecondaryPosition(en: 'Box-to-Box Midfielder', ro: 'Mijlocaș box-to-box', value: 'boxToBoxMidfielder',),
    SecondaryPosition(en: 'Deep-Lying Playmaker', ro: 'Creator de joc adânc', value: 'deepLyingPlaymaker',),
    SecondaryPosition(en: 'Inverted Winger', ro: 'Extremă inversată', value: 'invertedWinger',),
    SecondaryPosition(en: 'Target Man', ro: 'Omul țintă', value: 'targetMan',),
    SecondaryPosition(en: 'Ball Winning Midfielder', ro: 'Mijlocaș câștigător de minge', value: 'ballWinningMidfielder',),
    SecondaryPosition(en: 'Shadow Striker', ro: 'Atacant din umbră', value: 'shadowStriker',),
  ];


  final RxList<SecondaryPosition> selectedSecondaryPositions = <SecondaryPosition>[].obs;
  final RxList<String> selectedSecondaryPositionsValues = <String>[].obs;
  void updateSelectedSecondaryPositions(List<String> selectedLabels, bool isEnglish) {
    final selectedItems = secondaryPositions.where((p) {
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedSecondaryPositions.assignAll(selectedItems);
    selectedSecondaryPositionsValues.assignAll(selectedItems.map((e) => e.value).toList());

    debugPrint("Selected Secondary Positions API Values: $selectedSecondaryPositionsValues");
    update();
  }


  NationalityOption? findNationalityFromApi(String? enValue, String? roValue) {
    if ((enValue == null || enValue.isEmpty) &&
        (roValue == null || roValue.isEmpty)) return null;

    // Compare case-insensitively
    return nationalityOptions.firstWhereOrNull(
          (p) =>
      (enValue != null && p.en.toLowerCase() == enValue.toLowerCase()) ||
          (roValue != null && p.ro.toLowerCase() == roValue.toLowerCase()),
    );
  }

  //bools to show greencheckmark

  ///Personal info check
  bool personalInfoCompleted = false;
  void evaluatePersonalInfoSection() {
    final user = profile.value?.data;

    if (user == null) {
      personalInfoCompleted = false;
      return;
    }

    print("---------- PERSONAL INFO DEBUG ----------");

    print("firstName: ${user.firstName}");
    print("lastName: ${user.lastName}");
    print("email: ${user.email}");
    print("dob: ${user.dob}");
    print("phone: ${user.phone}");
    print("county: ${user.county}");
    print("nationality: ${user.nationality}");
    print("countryCode: ${user.countryCode}");
    print("playerPosition: ${user.position}");
    print("playerPosition: ${user.roPosition}");

    print("secondaryPosition: ${user.secondaryPosition}");
    print("secondaryPosition isNotEmpty: ${user.secondaryPosition.isNotEmpty}");

    print("technicalAttributes: ${user.technicalAttributes}");
    print("technicalAttributes isNotEmpty: ${user.technicalAttributes.isNotEmpty}");

    print("playingStyle: ${user.playingStyle}");
    print("playingStyle isNotEmpty: ${user.playingStyle.isNotEmpty}");

    print("playerHeight: ${user.playerHeight}");
    print("weight: ${user.weight}");
    print("playerLeg: ${user.playerLeg}");
    print("experienceLevel: ${user.experienceLevel}");
    print("consistency: ${user.consistency}");
    print("squadNumber: ${user.squadNumber}");
    print("competitionLevel: ${user.competitionLevel}");
    print("roCompetitionLevel: ${user.roCompetitionLevel}");
    print("contractStart: ${user.contractStart}");
    print("contractEnd: ${user.contractEnd}");
    print("transferStatus: ${user.transferStatus}");

    print("----------------------------------------");


    personalInfoCompleted =
        (user.firstName?.trim().isNotEmpty ?? false) &&
            (user.lastName?.trim().isNotEmpty ?? false) &&
            (user.email?.trim().isNotEmpty ?? false) &&
            (user.dob != null) &&
            (user.phone?.trim().isNotEmpty ?? false) &&
            (user.county?.trim().isNotEmpty ?? false) &&
            (user.nationality?.trim().isNotEmpty ?? false) &&
            (user.countryCode?.trim().isNotEmpty ?? false) &&
            (user.position?.trim().isNotEmpty ?? false) &&
            (user.roPosition?.trim().isNotEmpty ?? false) &&
            (user.secondaryPosition.isNotEmpty) &&
            (user.technicalAttributes.isNotEmpty) &&
            (user.playingStyle.isNotEmpty) &&
            (user.playerHeight != null) &&
            (user.weight != null) &&
            (user.playerLeg?.trim().isNotEmpty ?? false) &&
            (user.experienceLevel?.trim().isNotEmpty ?? false) &&
            (user.consistency?.trim().isNotEmpty ?? false) &&
            (user.squadNumber != null) &&
            (user.competitionLevel?.trim().isNotEmpty ?? false) &&
            (user.roCompetitionLevel?.trim().isNotEmpty ?? false) &&
            (user.contractStart != null) &&
            (user.contractEnd != null) &&
            (user.transferStatus?.trim().isNotEmpty ?? false);
  }

  ///Career
  RxBool careerCompleted = false.obs;
  void evaluateCareerSection() {
    final user = profile.value?.data;

    if (user == null) {
      careerCompleted.value = false;
      return;
    }

    careerCompleted.value = (user.career.isNotEmpty);
  }

  ///Stats
  RxBool statsCompleted = false.obs;
  void evaluateStatsSection() {
    final user = profile.value?.data;

    if (user == null) {
      statsCompleted.value = false;
      return;
    }

    statsCompleted.value =
        (user.matchesPlayed != null && user.matchesPlayed != 0) &&
            (user.goals != null && user.goals != 0) &&
            (user.assists != null && user.assists != 0) &&
            (user.minutes != null && user.minutes != 0);
  }

  ///National team
  RxBool nationalTeamCompleted = false.obs;
  void evaluateNationalTeamSection() {
    final user = profile.value?.data;

    if (user == null) {
      nationalTeamCompleted.value = false;
      return;
    }

    nationalTeamCompleted.value =
        (user.callUps != null && user.callUps != 0) &&
            (user.caps != null && user.caps != 0);
  }

  ///Performance Percentages
  RxBool performanceCompleted = false.obs;
  void evaluatePerformanceSection() {
    final user = profile.value?.data;

    if (user == null) {
      performanceCompleted.value = false;
      return;
    }

    performanceCompleted.value =
        (user.passCompletion ?? 0) > 0 &&
            (user.duelsWon ?? 0) > 0 &&
            (user.passAccuracy ?? 0) > 0 &&
            (user.shotsOnTarget ?? 0) > 0 &&
            (user.dribblesCompleted ?? 0) > 0;
  }

  ///Youtube links
  RxBool youtubeCompleted = false.obs;
  void evaluateYoutubeSection() {
    final user = profile.value?.data;

    if (user == null) {
      youtubeCompleted.value = false;
      return;
    }

    youtubeCompleted.value = (user.youtubeLinks.isNotEmpty);
  }

  ///Achievements
  RxBool achievementsCompleted = false.obs;
  void evaluateAchievementsSection() {
    final user = profile.value?.data;

    if (user == null) {
      achievementsCompleted.value = false;
      return;
    }

    final isClubFilled = (user.club?.trim().isNotEmpty ?? false);
    final isSeasonFilled = (user.season?.trim().isNotEmpty ?? false);
    final isMatchesFilled = (user.matches ?? 0) > 0;

    // At least ONE trophy must have valid data
    final hasAnyTrophy =
        user.trophies.any((trophy) =>
        (trophy.name?.trim().isNotEmpty ?? false) ||
            (trophy.year ?? 0) > 0 ||
            (trophy.icon?.trim().isNotEmpty ?? false)) ??
            false;

    achievementsCompleted.value =
        isClubFilled &&
            isSeasonFilled &&
            isMatchesFilled &&
            hasAnyTrophy;
  }

  Future<void> loadUserProfile(BuildContext context) async {
    try {
      final langCode = parser.getLanguage();
      selectedLanguage.value = (langCode != null && langCode.isNotEmpty) ? langCode : 'en';

      final userId = parser.getUid();
      final fetchedProfile = await getUserProfile(userId: "users/profile/$userId");

      if (fetchedProfile == null) return;

      profile.value = fetchedProfile;
      final user = fetchedProfile.data;
      /// ---- CAREER (ONE PLACE ONLY) ----
      fields.clear();

      final careerList = user?.career ?? [];

      print(">>>>>Length ${careerList.length}");

      /// ---- CAREER (ONE PLACE ONLY) ----
      fields.clear(); // clear old UI fields


      if (careerList.isNotEmpty) {
        // Add career from API
        for (final c in careerList) {
          fields.add(
            CareerFields(
              careerSeasonController: TextEditingController(text: c.season ?? ''),
              careerClubController: TextEditingController(text: c.club ?? ''),
              careerMatchesController: TextEditingController(text: c.matches ?? ''),
              careerGoalsController: TextEditingController(text: c.goals ?? ''),
              careerMinutesController: TextEditingController(text: c.minutes ?? ''),
              careerAssistsController: TextEditingController(text: c.assists ?? ''),
            ),
          );
        }
      } else {
        // If API empty → show ONE empty career
        //addNewCareerFieldSet();
      }

      update();



      /// BASIC FIELDS
      firstNameController.text = user?.firstName ?? '';
      lastNameController.text = user?.lastName ?? '';
      emailController.text = user?.email ?? '';
      phoneNumController.text = user?.phone ?? '';
      teamController.text = user?.currentTeam ?? '';
      clubController.text = user?.club ?? '';
      await parser.sharedPreferencesManager.sharedPreferences
          ?.setString('avatar', user?.avatar ?? '');



      if (!isPlayer) {
        update();
        return;
      }

      /// PLAYER FIELDS
      // playerAgeController.text = user?.playerAge ?? '';
      if (user?.dob != null) {
        //playerAgeController.text = formatDobFromDateTime(user!.dob!);
        final localDob = user!.dob!.toLocal();

        selectedDob.value = localDob;
        playerAgeController.text = DateFormat('MMMM dd, yyyy').format(user!.dob!);
      }


      evaluateAgeVisibility();
      playerHeightController.text = user?.playerHeight != null ? user!.playerHeight.toString() : '';

      if (isUnder18.value == true){
        parentFirstName.text = user?.parentFirstName ?? '';
        parentLastName.text = user?.parentLastName ?? '';
        parentEmail.text = user?.parentEmail ?? '';
        parentPhone.text = user?.parentPhone ?? '';
        //selectedRelation = user?.parentRelation;

        final rawRelation = user?.parentRelation ?? '';
        if (rawRelation.isNotEmpty) {
          // Map of all possible Romanian/English values → English key
          const relationNormMap = {
            'Father': 'Father', 'Tată': 'Father',
            'Mother': 'Mother', 'Mamă': 'Mother',
            'Brother': 'Brother', 'Frate': 'Brother',
          };
          selectedRelation = relationNormMap[rawRelation] ?? rawRelation;
        } else {
          selectedRelation = null;
        }
      }

      clubController.text = user?.club ?? '';

      countryCodeController.text = user?.country ?? '';

      selectedConsistency.value = user?.consistency?.capitalizeFirst ?? '';

// Preferred Foot
      selectedPreferredFoot.value = user?.playerLeg ?? '';

      teamController.text = user?.currentTeam ?? '';

      squadNumController.text = user?.squadNumber?.toString() ?? '';

      competitionLevelENController.text = user?.competitionLevel ?? '';
      competitionLevelROController.text = user?.roCompetitionLevel ?? '';

      playerWeightController.text = user?.weight?.toString() ?? '';

      matchPlayedController.text = user?.matchesPlayed?.toString() ?? '';
      goalsController.text = user?.goals?.toString() ?? '';
      assistsController.text = user?.assists?.toString() ?? '';
      minutesController.text = user?.minutes?.toString() ?? '';
      callUpsController.text = user?.callUps?.toString() ?? '';
      capsController.text = user?.caps?.toString() ?? '';

      passCompletionController.text = user?.passCompletion?.toString() ?? '';
      duelsWonController.text = user?.duelsWon?.toString() ?? '';
      passAccuracyController.text = user?.passAccuracy?.toString() ?? '';
      shotsOnTargetController.text = user?.shotsOnTarget?.toString() ?? '';
      dribblesCompletedController.text = user?.dribblesCompleted?.toString() ?? '';

      seasonController.text = user?.season?.toString() ?? '';
      matchesController.text = user?.matches?.toString() ?? '';
      selectedPosition = findPositionFromApi(
        user?.position,
        user?.roPosition,
      );

      // if (user?.career != null) {
      //   for (var c in user!.career!) {
      //     final item = CareerFields(
      //       careerSeasonController: TextEditingController(text: c.season ?? ''),
      //       careerClubController: TextEditingController(text: c.club ?? ''),
      //       careerMatchesController: TextEditingController(text: c.matches ?? ''),
      //       careerGoalsController: TextEditingController(text: c.goals ?? ''),
      //       careerMinutesController: TextEditingController(text: c.minutes ?? ''),
      //       careerAssistsController: TextEditingController(text: c.assists ?? ''),
      //     );
      //     fields.add(item);
      //     update();
      //   }
      // }
      final links = user?.youtubeLinks;

      // if (links != null && links.isNotEmpty && links.first.trim().isNotEmpty) {
      //   youtubeLinkController.text = links.first;
      //   showYoutubeField.value = true;
      // } else {
      //   youtubeLinkController.clear();
      //   showYoutubeField.value = false;
      // }
      youtubeControllers.clear();

      if (links != null && links.isNotEmpty) {
        for (final link in links) {
          if (link.trim().isNotEmpty) {
            youtubeControllers.add(
              TextEditingController(text: link.trim()),
            );
          }
        }
      }
      selectedCVFileName =
      (user?.cv?.trim().isNotEmpty ?? false)
          ? user!.cv!.split('/').last
          : null;
      apiCVFileName =
      (user?.cv?.trim().isNotEmpty ?? false)
          ? user!.cv!.split('/').last
          : null;


      selectedMedicalFileName =
      (user?.medicalCertificate?.trim().isNotEmpty ?? false)
          ? user?.medicalCertificate?.split('/').last
          : null;
      apiMedicalFileName =
      (user?.medicalCertificate?.trim().isNotEmpty ?? false)
          ? user?.medicalCertificate?.split('/').last
          : null;

      print(">>JKLL${user?.weight.toString()}");
// Country Code
      countryCodeController.text = user?.countryCode ?? '';
// Career Matches
      statsMatches.text =
      user?.matchesPlayed != null ? user!.matchesPlayed.toString() : '';
      /// PRIMARY POSITION
      selectedPrimaryPosition.value = user?.playerPosition ?? '';
      /// TRANSFER STATUS
      SelectedtransferStatus.value = user?.transferStatus ?? '';
      countryCodeController.text = (user?.countryCode ?? '').toString();
      countryController.text = (user?.country ?? '').toString();

      // selectedNationalityValue=user?.nationality.toString();
      selectedNationalityOption = findNationalityFromApi(
        user?.nationality,    // "British"
        user?.roNationality,  // "Britanic"
      );
      countyNameController.text = user?.county ?? '';

      print(">>>>>>>>>${selectedNationalityOption?.en}"); // Should print "British"
      print(">>>>>>>>>${selectedNationalityOption?.ro}"); // Should print "Britanic"
      update(); // Refresh UI if using GetX


      update(); // 🔥 REQUIRED


      /// EXPERIENCE LEVEL (API KEY)
      final apiValue = user?.experienceLevel ?? '';
      selectedExperienceLevel.value = capitalizeFirstLetter(apiValue);
      // Contract Dates
      if (user?.contractStart != null && user!.contractStart.toString().isNotEmpty) {
        try {
          DateTime startDate = DateTime.parse(user.contractStart.toString());
          startContractDateController.text = DateFormat('MMMM dd, yyyy').format(startDate);
        } catch (_) {
          startContractDateController.text = user.contractStart.toString();
        }
      } else {
        startContractDateController.text = '';
      }

      if (user?.contractEnd != null && user!.contractEnd.toString().isNotEmpty) {
        try {
          DateTime endDate = DateTime.parse(user.contractEnd.toString());
          endContractDateController.text = DateFormat('MMMM dd, yyyy').format(endDate);
        } catch (_) {
          endContractDateController.text = user.contractEnd.toString();
        }
      } else {
        endContractDateController.text = '';
      }
// Secondary Positions
      if (user?.secondaryPosition != null && (user!.secondaryPosition as List).isNotEmpty) {
        final List<dynamic> apiPositions = user.secondaryPosition;
        selectedSecondaryPositions.assignAll(
          secondaryPositions.where((p) => apiPositions.contains(p.value)).toList(),
        );
        selectedSecondaryPositionsValues.assignAll(
          selectedSecondaryPositions.map((e) => e.value).toList(),
        );
      } else {
        selectedSecondaryPositions.clear();
        selectedSecondaryPositionsValues.clear();
      }

      // Playing Style
      selectedPlayingStyle.assignAll(
        playingStyle.where((p) =>
            (user?.playingStyle ?? []).contains(p.value)),
      );

// Technical Attributes
      selectedTechnicalAttributes.assignAll(
        technicalAttributes.where((p) =>
            (user?.technicalAttributes ?? []).contains(p.value)),
      );
      // Trophies
      trophies.clear();
      if (user?.trophies != null) {
        for (var t in user!.trophies!) {
          final item = TrophyFields(
              trophyNameController: TextEditingController(text: t.name ?? ''),
              trophyYearController: TextEditingController(text: t.year?.toString() ?? ''),
              trophyImageFileName: t.icon
          );
          trophies.add(item);
          update();
        }
      }

      evaluatePersonalInfoSection();
      evaluateCareerSection();
      evaluateStatsSection();
      evaluateNationalTeamSection();
      evaluatePerformanceSection();
      evaluateYoutubeSection();
      evaluateAchievementsSection();
      update();

      update();
    } catch (e) {
      debugPrint("Profile Load Error: $e");
    }
  }


  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  RxBool isUnder18 = false.obs;
  void evaluateAgeVisibility() {
    if (selectedDob.value == null) {
      isUnder18.value = false;
      return;
    }

    final today = DateTime.now();
    final dob = selectedDob.value!;

    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    isUnder18.value = age < 18;
    debugPrint("Is under 18: ${isUnder18.value}");
  }



  Future<ProfileResModel?> getUserProfile({required String userId}) async {
    String? currentLang = parser.getLanguage();

    // final String endpoint = "http://192.168.1.36:9000/api/v1/users/profile/${userId}";
    try {
      final response = await parser.apiService.getApiWithHeader(userId);

      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        // Parse into ProfileResModel
        final profile = ProfileResModel.fromJson(data);
        num playerLimit = profile?.data?.playerLimit ?? 0;
        subscriptionStatus.value = profile.data?.subscriptionStatus??'';

        if (kDebugMode) {
          print("Player limit is >>${playerLimit}");
          print("subscriptionStatus is >>${subscriptionStatus.value}");
        }
        await parser.sharedPreferencesManager
            .putInt(AppString.playerLimit, playerLimit.toInt());

        debugPrint("profile response>>${profile.data}");
        return profile;
      } else {
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }

  // Update Profile section
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController countyNameController = TextEditingController();
  TextEditingController teamController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController currentTeam = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController playerAgeController = TextEditingController();
  TextEditingController playerHeightController = TextEditingController();
  TextEditingController playerWeightController = TextEditingController();
  TextEditingController parentFirstName = TextEditingController();
  TextEditingController parentLastName = TextEditingController();
  TextEditingController parentEmail = TextEditingController();
  TextEditingController parentPhone = TextEditingController();
  TextEditingController parentRelation = TextEditingController();
  String? selectedRelation;
  TextEditingController playerAge = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController startContractDateController = TextEditingController();
  TextEditingController endContractDateController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController careerMatchesController = TextEditingController();
  TextEditingController squadNumController = TextEditingController();
  TextEditingController competitionLevelENController = TextEditingController();
  TextEditingController competitionLevelROController = TextEditingController();
  TextEditingController matchPlayedController = TextEditingController();
  TextEditingController goalsController = TextEditingController();
  TextEditingController assistsController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  TextEditingController callUpsController = TextEditingController();
  TextEditingController capsController = TextEditingController();
  TextEditingController passCompletionController = TextEditingController();
  TextEditingController duelsWonController = TextEditingController();
  TextEditingController passAccuracyController = TextEditingController();
  TextEditingController shotsOnTargetController = TextEditingController();
  TextEditingController dribblesCompletedController = TextEditingController();
  TextEditingController seasonController = TextEditingController();
  TextEditingController matchesController = TextEditingController();
  TextEditingController statsMatches = TextEditingController();


  //Career fields
  TextEditingController careerSeasonController = TextEditingController();
  TextEditingController careerClubController = TextEditingController();
  TextEditingController careerGoalsController = TextEditingController();
  TextEditingController careerMinutesController = TextEditingController();
  TextEditingController careerAssistsController = TextEditingController();
  //Trophy fields
  TextEditingController trophyNameController = TextEditingController();
  TextEditingController trophyYearController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();

  //youtube link
  RxBool showYoutubeField = false.obs;

  //Multiple youtube link
  RxList<TextEditingController> youtubeControllers = <TextEditingController>[].obs;
  //Document File
  File? selectedCVPdf;
  String? selectedCVFileName;
  String? apiCVFileName;

  //Medical File
  File? selectedMedicalPdf;
  String? selectedMedicalFileName;
  String? apiMedicalFileName;



  File? pickedImage;
  RxString selectedPrimaryPosition = ''.obs;
  // Method to toggle selected relation
  void updateSelectedRelation(String value) {
    selectedRelation = value;
    update(); // Trigger UI update using GetBuilder
  }

  void removeYoutubeField(int index) {
    youtubeControllers[index].dispose();
    youtubeControllers.removeAt(index);
  }

  bool areAllYoutubeFieldsCompleted() {
    return youtubeControllers.every((controller) {
      return controller.text.trim().isNotEmpty;
    });
  }
  void addYoutubeField(BuildContext context) {
    if (!areAllYoutubeFieldsCompleted()) {
      successToast("Please fill all existing YouTube links before adding a new one.");
      return;
    }
    youtubeControllers.add(TextEditingController());
    update();
  }

  RxList<CareerFields> fields = <CareerFields>[].obs;
  bool areAllCareerFieldsCompleted() {
    return fields.every((field) {
      return [
        field.careerSeasonController.text,
        field.careerClubController.text,
        field.careerMatchesController.text,
        field.careerGoalsController.text,
        field.careerMinutesController.text,
        field.careerAssistsController.text,
      ].every((text) => text.trim().isNotEmpty);
    });
  }
  void addNewCareerFieldSet() {
    if (!areAllCareerFieldsCompleted()) {
      successToast("Please complete all career fields before adding a new career.");
      return;
    }
    final newFields = CareerFields(
      careerSeasonController: TextEditingController(),
      careerClubController: TextEditingController(),
      careerMatchesController: TextEditingController(),
      careerGoalsController: TextEditingController(),
      careerMinutesController: TextEditingController(),
      careerAssistsController: TextEditingController(),
    );
    fields.add(newFields);
    update();
  }
  void removeCareerFieldSet(int index) {
    if (index >= 0 && index < fields.length) {
      final updatedList = List<CareerFields>.from(fields)..removeAt(index);
      fields.value = updatedList;
      update();
    }
  }
  Rx<DateTime?> selectedDob = Rx<DateTime?>(null);

  Future<void> pickDob(BuildContext context,TextEditingController textController) async {
    DateTime initialDate;

    // If already selected earlier, use that date as initial date
    if (textController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('MMMM dd, yyyy').parse(textController.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Convert to local just to be safe
      final localPicked = picked.toLocal();
      int age = calculateAge(localPicked);

      if (age < 3) {
        errorToast("Player must be at least 3 years old.");
        textController.clear();
        selectedDob.value = null;
        return;
      }

      selectedDob.value = localPicked;

      // Display nicely in MMMM dd, yyyy format
      playerAgeController.text =
          DateFormat('MMMM dd, yyyy').format(localPicked);

      evaluateAgeVisibility(); // recalc parent section visibility
    }

  }
  void clearParentFields() {
    parentFirstName.clear();
    parentLastName.clear();
    parentEmail.clear();
    parentPhone.clear();
    selectedRelation = null;

    debugPrint("🧹 Parent fields cleared (Player is 18+)");
  }


  //Nationality
  final List<NationalityOption> nationalityOptions = [
    NationalityOption(value: "romanian", en: "Romanian", ro: "Român"),
    NationalityOption(value: "english", en: "English", ro: "Englez"),
    NationalityOption(value: "british", en: "British", ro: "Britanic"),
    NationalityOption(value: "spanish", en: "Spanish", ro: "Spaniol"),
    NationalityOption(value: "french", en: "French", ro: "Francez"),
    NationalityOption(value: "german", en: "German", ro: "German"),
    NationalityOption(value: "italian", en: "Italian", ro: "Italian"),
    NationalityOption(value: "portuguese", en: "Portuguese", ro: "Portughez"),
    NationalityOption(value: "brazilian", en: "Brazilian", ro: "Brazilian"),
    NationalityOption(value: "argentinian", en: "Argentinian", ro: "Argentinian"),
    NationalityOption(value: "dutch", en: "Dutch", ro: "Olandez"),
    NationalityOption(value: "belgian", en: "Belgian", ro: "Belgian"),
    NationalityOption(value: "croatian", en: "Croatian", ro: "Croat"),
    NationalityOption(value: "serbian", en: "Serbian", ro: "Sârb"),
    NationalityOption(value: "hungarian", en: "Hungarian", ro: "Ungur"),
    NationalityOption(value: "bulgarian", en: "Bulgarian", ro: "Bulgar"),
    NationalityOption(value: "polish", en: "Polish", ro: "Polonez"),
    NationalityOption(value: "czech", en: "Czech", ro: "Ceh"),
    NationalityOption(value: "slovak", en: "Slovak", ro: "Slovac"),
    NationalityOption(value: "austrian", en: "Austrian", ro: "Austriac"),
    NationalityOption(value: "swiss", en: "Swiss", ro: "Elvețian"),
    NationalityOption(value: "swedish", en: "Swedish", ro: "Suedez"),
    NationalityOption(value: "norwegian", en: "Norwegian", ro: "Norvegian"),
    NationalityOption(value: "danish", en: "Danish", ro: "Danez"),
    NationalityOption(value: "finnish", en: "Finnish", ro: "Finlandez"),
    NationalityOption(value: "turkish", en: "Turkish", ro: "Turc"),
    NationalityOption(value: "greek", en: "Greek", ro: "Grec"),
    NationalityOption(value: "ukrainian", en: "Ukrainian", ro: "Ucrainean"),
    NationalityOption(value: "russian", en: "Russian", ro: "Rus"),
    NationalityOption(value: "american", en: "American", ro: "American"),
    NationalityOption(value: "canadian", en: "Canadian", ro: "Canadian"),
    NationalityOption(value: "mexican", en: "Mexican", ro: "Mexican"),
    NationalityOption(value: "japanese", en: "Japanese", ro: "Japonez"),
    NationalityOption(value: "korean", en: "Korean", ro: "Coreean"),
    NationalityOption(value: "chinese", en: "Chinese", ro: "Chinez"),
    NationalityOption(value: "australian", en: "Australian", ro: "Australian"),
    NationalityOption(value: "nigerian", en: "Nigerian", ro: "Nigerian"),
    NationalityOption(value: "ghanaian", en: "Ghanaian", ro: "Ghanez"),
    NationalityOption(value: "senegalese", en: "Senegalese", ro: "Senegalez"),
    NationalityOption(value: "egyptian", en: "Egyptian", ro: "Egiptean"),
  ];
  String? selectedNationalityValue;
  NationalityOption ? selectedNationalityOption;

  void updateSelectedNationalityByRo(String ro) {
    final option = nationalityOptions.firstWhere(
          (p) => p.ro == ro,
      orElse: () => nationalityOptions.first, // fallback
    );

    selectedNationalityOption = option;   // for UI
    selectedNationalityValue = option.value;    // for backend
    update();
  }
  void updateSelectedNationalityByEn(String en) {
    final option =
    nationalityOptions.firstWhere((p) => p.en == en);

    selectedNationalityOption = option;       // for UI
    selectedNationalityValue = option.value;  // for backend
    update();
  }





  List<String> preferredFoot = ["Left","Right","Both"];
  final Map<String, String> preferredFootMap = {
    'Left': 'preferred_foot_left'.tr,
    'Right': 'preferred_foot_right'.tr,
    'Both': 'preferred_foot_both'.tr,
  };

  String? selectedTransferStatus;
  String? selectedPrivacy;

  var playerIsMinor = false.obs;


  // Method to toggle selected preferred foot
  void updateSelectedPreferredFoot(String key) {
    selectedPreferredFoot.value = key; // English key saved for API
    update(); // refresh UI
  }



  pickedDateOnly(
      BuildContext context,
      TextEditingController textController,
      AddPlayerScreenLogic controller, {
        String type = 'past', // 'past', 'future', 'both'
      }) async {
    DateTime initialDate;

    // If already selected earlier, use that date as initial date
    if (textController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('MMMM dd, yyyy').parse(textController.text);
      } catch (_) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    DateTime firstDate;
    DateTime lastDate;

    // ✅ Date range logic
    switch (type) {
      case 'future':
        firstDate = DateTime.now();
        lastDate = DateTime.now().add(const Duration(days: 365 * 5));
        break;

      case 'both':
        firstDate = DateTime(DateTime.now().year - 100);
        lastDate = DateTime.now();
        break;

      default: // 'past'
        firstDate = DateTime(DateTime.now().year - 100);
        lastDate = DateTime.now();
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MMMM dd, yyyy').format(pickedDate);
      textController.text = formattedDate;
      //controller.dobController = textController;

      // ✅ Age validation ONLY for DOB
      if (type == 'past' && textController == controller.dobController) {
        int age = calculateAge(pickedDate);
        if (age < 3) {
          errorToast("Player must be at least 3 years old.");
          textController.clear();
          return;
        }

        controller.playerAge = age;
        controller.playerIsMinor.value = age < 18;
        controller.update();

        debugPrint("Age: $age, Minor: ${controller.playerIsMinor.value}");
      }

      debugPrint("Selected date: $formattedDate");
    } else {
      debugPrint("Date selection canceled");
    }
  }

  /// Helper to set picked image
  void setProfileImage(File file) {
    pickedImage = file;
    update(); // refresh UI
  }

  // Notes>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  // ================= PLAYERS =================

  GetClubPlayersList getClubPlayersList = GetClubPlayersList();

  // players dropdown list
  RxList<player.ClubPlayers> playersList = <player.ClubPlayers>[].obs;

  // selected player (SINGLE, not list)
  Rx<player.ClubPlayers?> selectedPlayer = Rx<player.ClubPlayers?>(null);
  Rx<SavedListBody?> selectedSavedPlayer = Rx<SavedListBody?>(null);

  // dropdown selected value (String for UI)
  RxString selectedPlayerName = ''.obs;

  // errors
  RxString selectedPlayerError = ''.obs;
  RxString noteError = ''.obs;

  // note controller
  TextEditingController noteController = TextEditingController();

  /// Fetch players
  Future<GetClubPlayersList?> getClubPlayersApi({
    int currentPage = 1,
    int limit = 50,
    String? searchText,
  }) async {
    try {
      final response = await parser.getClubPlayers(
        page: currentPage,
        limit: limit,
        search: searchText,
      );

      if (response == null) return null;

      dynamic data = response.data;
      if (data is String) data = jsonDecode(data);

      getClubPlayersList = GetClubPlayersList.fromJson(data);

      if (getClubPlayersList.responseCode == 200) {
        playersList.value = getClubPlayersList.data ?? [];
      }

      return getClubPlayersList;
    } catch (e) {
      debugPrint("Error fetching players: $e");
      return null;
    }
  }

  /// select player
  void updateSelectedPlayer(player.ClubPlayers playerData) {
    selectedPlayer.value = playerData;
    selectedPlayerName.value = playerData.sId ?? '';
    if (kDebugMode) {
      print("SELECT PLAYER ${selectedPlayerName.value}");
    }
    selectedPlayerError.value = '';
  }
  void updateSelectedSavedPlayer(SavedListBody playerData) {
    selectedSavedPlayer.value = playerData;
    selectedPlayerName.value = playerData.playerInfo?.id ?? '';
    if (kDebugMode) {
      print("SELECT PLAYER ${selectedPlayerName.value}");
    }
    selectedPlayerError.value = '';
  }


  /// submit note
  void submitNote() {
    if (selectedPlayer.value == null) {
      selectedPlayerError.value = "Please select a player";
      return;
    }

    if (noteController.text.trim().isEmpty) {
      noteError.value = "Please add a note";
      return;
    }

    debugPrint("Note: ${noteController.text}");

    // TODO API CALL
    // parser.saveNote(playerId: selectedPlayer.value!.id, note: noteController.text);

    noteController.clear();
    selectedPlayer.value = null;

    Get.snackbar("Success", "Note added successfully");
  }

  Future<AddNoteModel?> addPlayerNote(
    BuildContext context, {
    required String playerId,
    required String note,
  }) async {
    try {
      // 🔄 Show loader
      LoaderDialog.show(context);

      final response = await parser.apiService.postApiWithBody(
        'settings/playerNote',
        body: {"playerId": playerId, "note": note},
      );

      if (response == null) {
        LoaderDialog.hide(context);
        errorToast("No response from server");
        return null;
      }

      // ✅ Success
      if (response.statusCode == 200) {
        final addNoteModel = AddNoteModel.fromJson(response.data);

        // Clear state
        selectedPlayer.value = null;
        selectedSavedPlayer.value = null;
        selectedPlayerName.value = '';
        noteController.clear();

        LoaderDialog.hide(context);

        // Show success or error based on API response
        if ((addNoteModel.responseCode ?? 0) == 200) {
          successToast(
            addNoteModel.responseMessage ?? "Note added successfully",
          );
        } else {
          errorToast(addNoteModel.responseMessage ?? "Something went wrong");
        }

        // Print full response
        print("Add Note API Response: ${response.data}");

        return addNoteModel;
      }

      // ❌ Failure — extract message
      LoaderDialog.hide(context);
      String message = "Something went wrong";

      try {
        if (response.data is String) {
          final dataMap = jsonDecode(response.data);
          message = dataMap["responseMessage"]?.toString() ?? message;
        } else if (response.data is Map<String, dynamic>) {
          message = response.data["responseMessage"]?.toString() ?? message;
        }
      } catch (_) {}

      errorToast(message);
      return null;
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
      return null;
    }
  }

  //Saved Player list
  GetSavedListModel getSavedPlayerListModel = GetSavedListModel();
  //List<SavedListBody> savedPlayerList = [];
  RxList<SavedListBody> savedPlayerList = <SavedListBody>[].obs;
  getSavePlayerList(BuildContext context, {required int page}) async{
   LoaderDialog.show(context);
    final response = await parser.fetchingSavedPlayList(page);
   LoaderDialog.hide(context);
   savedPlayerList.clear();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);

      getSavedPlayerListModel = GetSavedListModel.fromJson(myMap);
      savedPlayerList.addAll(getSavedPlayerListModel.data ?? []);
      update();

      if (kDebugMode) {
        print("savedPlayerList count --->${savedPlayerList.length}");
      }
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }


// Logout API
  Future<void> logout() async {
    try {
      final response = await parser.logoutApi();
      if (response.statusCode == 200) {
        final message = response.data['responseMessage'] ?? "Logged out successfully";
        successToast(message);
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AppString.authToken);
        await prefs.remove(AppString.uid);
        await prefs.remove(AppString.playerLimit);
        Get.offAllNamed(AppRouter.login);
      } else {
        errorToast(response.data['responseMessage'] ?? "Logout failed. Please try again.",
        );
      }
    } catch (error) {
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }


  //Delete Api
// Delete Account API
  Future<void> deleteAccount(BuildContext context) async {
    try {
      LoaderDialog.show(Get.overlayContext!);

      final response = await parser.deleteAccount();

      if (response != null && response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AppString.authToken);
        await prefs.remove(AppString.uid);
        await prefs.remove(AppString.playerLimit);

        // Close loader before navigation
        LoaderDialog.hide(Get.overlayContext!);

        // Navigate to login
        Get.offAllNamed(AppRouter.login);

        // Show success message after navigation
        Future.delayed(const Duration(milliseconds: 300), () {
          successToast(
            response.data['responseMessage'] ?? "Account deleted successfully",
          );
        });
      } else {
        LoaderDialog.hide(Get.overlayContext!);
        errorToast("Failed to delete account");
      }
    } catch (e) {
      LoaderDialog.hide(Get.overlayContext!);
      errorToast("Something went wrong. Please try again.");
    }
  }
  bool get isPlayer => profile.value?.data?.role == "player";

  String lowerFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toLowerCase() + value.substring(1);
  }
  // Update Academy profile
  Future<void> updateProfile(BuildContext context) async {
    try {
      LoaderDialog.show(context);

      final userId = parser.getUid();
      final isPlayer =
          parser.sharedPreferencesManager.getString(
            'selectedUserRole',
          ) ==
              Constants.userRolePlayer;
      /// ================= BASIC FIELDS =================
      final Map<String, dynamic> fieldsMap = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneNumController.text.trim(),
        "club": clubController.text.trim(),
        "currentTeam": teamController.text.trim(),
      };

      /// ================= FILES =================
      // 🔥 Declare files map at the very top to avoid "referenced before declared"
      final Map<String, File> files = {};
      if (pickedImage != null) {
        files["avatar"] = pickedImage!;
      }

      /// ================= PLAYER FIELDS =================
      if (isPlayer) {
        fieldsMap.addAll({

          //"dob": selectedDob.value?.toIso8601String(),
          "dob":convertReadableDateToIso(playerAgeController.text) ,
          "playerHeight": playerHeightController.text.trim(),
          "weight": playerWeightController.text.trim(),
          "playerLeg": selectedPreferredFoot.value,
          // "roPlayerLeg":selectedPreferredFoot?.tr,
          "transferStatus": SelectedtransferStatus.value,
          "experienceLevel": lowerFirst(selectedExperienceLevel.value),
          "consistency": selectedConsistency.value.toLowerCase(),
           "matches": matchesController.text.trim(),
           "season": seasonController.text.trim(),
          "matchesPlayed": statsMatches.text.trim(),
          "minutes": minutesController.text.trim(),
          "goals": goalsController.text.trim(),
          "assists": assistsController.text.trim(),
          "callUps": callUpsController.text.trim(),
          "caps": capsController.text.trim(),
          "dribblesCompleted": dribblesCompletedController.text.trim(),
          "duelsWon": duelsWonController.text.trim(),
          "passCompletion": passCompletionController.text.trim(),
          "passAccuracy": passAccuracyController.text.trim(),
          "shotsOnTarget": shotsOnTargetController.text.trim(),
          "primaryPosition": selectedPrimaryPosition.value,
          "squadNumber": squadNumController.text.trim(),
          "competitionLevel": competitionLevelENController.text.trim(),
          "roCompetitionLevel": competitionLevelROController.text.trim(),
          "countryCode": countryCodeController.text.trim(),
          "country": countryController.text.trim(),
          // "parentFirstName": parentFirstName.text.trim(),
          // "parentLastName": parentLastName.text.trim(),
          // "parentEmail": parentEmail.text.trim(),
          // "parentPhone": parentPhone.text.trim(),
          // "parentRelation":selectedRelation ?? "",
          "nationality": selectedNationalityOption?.en ?? '',
          "roNationality": selectedNationalityOption?.ro ?? '',
          "county": countyNameController.text.trim(),
          "contractStart": convertReadableDateToIso(startContractDateController.text.trim()),
          "contractEnd": convertReadableDateToIso(endContractDateController.text.trim()),
          "position": selectedPosition?.en,
          "roPosition": selectedPosition?.ro,
          "secondaryPosition": jsonEncode(selectedSecondaryPositions.map((e) => e.value).toList()),
          "playingStyle": jsonEncode(selectedPlayingStyleValues),
          "technicalAttributes": jsonEncode(selectedTechnicalAttributes.map((e) => e.value).toList()),
          // "cv": selectedCVPdf?.path,
          // "medicalCertificate": selectedMedicalPdf?.path,
          // "youtubeLinks[0]": youtubeLinkController.text.trim().isNotEmpty
          //     ? [youtubeLinkController.text.trim().toString()]
          //     : null,
        });
        if (selectedCVPdf != null) {
          files["cv"] = selectedCVPdf!;
        }

        if (selectedMedicalPdf != null) {
          files["medicalCertificate"] = selectedMedicalPdf!;
        }
        if (isUnder18.value == true) {
          fieldsMap.addAll({
            "parentFirstName": parentFirstName.text.trim(),
            "parentLastName": parentLastName.text.trim(),
            "parentEmail": parentEmail.text.trim(),
            "parentPhone": parentPhone.text.trim(),
            "parentRelation": selectedRelation ?? "",
          });
        }

        /// ================= CAREER =================
        for (int i = 0; i < fields.length; i++) {
          final c = fields[i];

          final season = c.careerSeasonController.text.trim();
          final club = c.careerClubController.text.trim();
          final matches = c.careerMatchesController.text.trim();
          final goals = c.careerGoalsController.text.trim();
          final minutes = c.careerMinutesController.text.trim();
          final assists = c.careerAssistsController.text.trim();

          // DEBUG: Print the values
          debugPrint("Career[$i] => season: $season, club: $club, matches: $matches, goals: $goals, minutes: $minutes, assists: $assists");

          if (season.isNotEmpty) fieldsMap["career[$i][season]"] = season;
          if (club.isNotEmpty) fieldsMap["career[$i][club]"] = club;
          if (matches.isNotEmpty) fieldsMap["career[$i][matches]"] = matches;
          if (goals.isNotEmpty) fieldsMap["career[$i][goals]"] = goals;
          if (minutes.isNotEmpty) fieldsMap["career[$i][minutes]"] = minutes;
          if (assists.isNotEmpty) fieldsMap["career[$i][assists]"] = assists;
        }

        /// ================= YOUTUBE LINKS =================
        for (int i = 0; i < youtubeControllers.length; i++) {
          final text = youtubeControllers[i].text.trim();

          if (text.isNotEmpty) {
            fieldsMap['youtubeLinks[$i]'] = text;
          }
        }

        /// ================= TROPHIES =================
        for (int i = 0; i < trophies.length; i++) {
          final t = trophies[i];
          fieldsMap["trophies[$i][name]"] = t.trophyNameController.text.trim();
          fieldsMap["trophies[$i][year]"] = t.trophyYearController.text.trim();

          // Add trophy icon to files map
          if (t.trophyImage != null) {
            files["trophies[$i][icon]"] = t.trophyImage!;
          }
        }
      }

      /// ================= DEBUG =================
      debugPrint("\n📤 FINAL PAYLOAD");
      fieldsMap.forEach((k, v) => debugPrint("   $k => $v"));
      debugPrint("\n📤 FILES PAYLOAD");
      files.forEach((k, f) => debugPrint("   $k => ${f.path}"));

      /// ================= API =================
      final String? role = parser.sharedPreferencesManager.getString('selectedUserRole');
      final String url = role == Constants.userRolePlayer
          ? "player/updateProfile/$userId"
          : "users/$userId";

      final response = await parser.apiService.putMultipartApi(
        url,
        fields: fieldsMap,
        files: files,
      );

      LoaderDialog.hide(context);

      /// ================= RESPONSE =================
      if (response != null && response.statusCode == 200) {
        final updateModel = UpdateProfileModel.fromJson(response.data);

        if (updateModel.responseCode == 200) {
          successToast(updateModel.responseMessage ?? "Profile updated");
          await loadUserProfile(context);

          pickedImage = null;
          update();
        } else {
          errorToast(updateModel.responseMessage ?? "Update failed");
        }
      } else {
        errorToast("Profile update failed");
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("❌ UPDATE ERROR: $e");
      errorToast("Something went wrong");
    }
  }
  Position? findPositionFromApi(String? en, String? ro) {
    if (en == null && ro == null) return null;

    return positions.firstWhereOrNull(
          (p) =>
      (en != null && p.en == en) ||
          (ro != null && p.ro == ro),
    );
  }
  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        alignment: 0.4,
        curve: Curves.easeInOut,
      );
    }
  }
  Future<void> openAppleSubscriptions() async {
    final Uri url = Uri.parse(
      'https://apps.apple.com/account/subscriptions',
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open subscriptions';
    }
  }
}
extension StringCasing on String {
  String toLowerFirst() {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }
}
