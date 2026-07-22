import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/backend/model/addPlayerFields/careerFields.dart';
import 'package:scouttalent2/backend/model/playerDetailResponse.dart' as player;
import 'package:scouttalent2/utils/toast.dart';
import '../../backend/model/addPlayerFields/addClubPlayerRequest.dart';
import '../../backend/model/addPlayerFields/trophyFields.dart';
import '../../utils/app_assets.dart';
import '../../utils/string.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import 'add_player_screen_state.dart';

class AddPlayerScreenLogic extends GetxController {
  final AddPlayerScreenState state;
  AddPlayerScreenLogic({required this.state});
  RxString selectedLanguage = 'en'.obs;
  File? profileImageFile;
  String? profileImageUrl;
  RxBool showMoreFields = false.obs;
  List<String> preferredFoot = ["Left","Right","Both"];
  final Map<String, String> preferredFootMap = {
    'Left': 'preferred_foot_left'.tr,
    'Right': 'preferred_foot_right'.tr,
    'Both': 'preferred_foot_both'.tr,
  };
  List<String> transferStatus = ["Available","Free Agent","On Loan"];
  final Map<String, String> transferStatusMap = {
    'Available': 'transfer_status_available'.tr,
    'Free Agent': 'transfer_status_free_agent'.tr,
    'On Loan': 'transfer_status_on_loan'.tr,
  };
  List<String> privacy = ["Private","Link-only","Public"];
  final Map<String, String> privacyMap = {
    'Private': 'privacy_private'.tr,
    'Link-only': 'privacy_link_only'.tr,
    'Public': 'privacy_public'.tr,
  };
  String? selectedPreferredFoot;
  String? selectedTransferStatus;
  String? selectedPrivacy;

  //Player Category
  List<String> playerCategory = ["International","Romanian"];
  final Map<String, String> playerCategoryMap = {
    'International': 'player_category_international'.tr,
    'Romanian': 'player_category_romanian'.tr,
  };

  List<String> experienceLevel = ["Professional","SemiProfessional","Amateur"];
  final Map<String, String> experienceLevelMap = {
    'Professional': 'experience_level_professional'.tr,
    'SemiProfessional': 'experience_level_semi_professional'.tr,
    'Amateur': 'experience_level_amateur'.tr,
  };

  List<String> consistency = ["Low","Medium","High"];
  final Map<String, String> consistencyMap = {
    'Low': 'consistency_low'.tr,
    'Medium': 'consistency_medium'.tr,
    'High': 'consistency_high'.tr,
  };
  String? selectedPlayerCategory;
  String? selectedExperienceLevel;
  String? selectedConsistency;

  //Positions
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
  Position? selectedPosition;

  //Secondary Positions
  final List<SecondaryPosition> secondaryPositions = const [
    SecondaryPosition(en: 'Box-to-Box Midfielder', ro: 'Mijlocaș box-to-box', value: 'boxToBoxMidfielder',),
    SecondaryPosition(en: 'Deep-Lying Playmaker', ro: 'Creator de joc adânc', value: 'deepLyingPlaymaker',),
    SecondaryPosition(en: 'Inverted Winger', ro: 'Extremă inversată', value: 'invertedWinger',),
    SecondaryPosition(en: 'Target Man', ro: 'Omul țintă', value: 'targetMan',),
    SecondaryPosition(en: 'Ball Winning Midfielder', ro: 'Mijlocaș câștigător de minge', value: 'ballWinningMidfielder',),
    SecondaryPosition(en: 'Shadow Striker', ro: 'Atacant din umbră', value: 'shadowStriker',),
  ];
  final RxList<SecondaryPosition> selectedSecondaryPositions = <SecondaryPosition>[].obs;
  final RxList<String> selectedSecondaryPositionValues = <String>[].obs;
  void updateSelectedSecondaryPositions(
      List<String> selectedLabels,
      bool isEnglish,
      ) {
    final selectedItems = secondaryPositions.where((p) {
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedSecondaryPositions.value = selectedItems;
    selectedSecondaryPositionValues.value =
        selectedItems.map((e) => e.value).toList();

    debugPrint("Selected Values (API): $selectedSecondaryPositionValues");
  }

  //Technical Attributes
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
  void updateSelectedTechnicalAttributes(
      List<String> selectedLabels,
      bool isEnglish,
      ) {
    final selectedItems = technicalAttributes.where((p) {
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedTechnicalAttributes.value = selectedItems;
    selectedTechnicalAttributesValues.value =
        selectedItems.map((e) => e.value).toList();

    debugPrint("Selected Values (API): $selectedTechnicalAttributesValues");
  }

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
  final RxList<SecondaryPosition> selectedPlayingStyle = <SecondaryPosition>[].obs;
  final RxList<String> selectedPlayingStyleValues = <String>[].obs;
  void updateSelectedPlayingStyle(
      List<String> selectedLabels,
      bool isEnglish,
      ) {
    final selectedItems = playingStyle.where((p) {
      return selectedLabels.contains(isEnglish ? p.en : p.ro);
    }).toList();

    selectedPlayingStyle.value = selectedItems;
    selectedPlayingStyleValues.value =
        selectedItems.map((e) => e.value).toList();

    debugPrint("Selected Values (API): $selectedPlayingStyleValues");
  }



  //Nationality
  final List<NationalityOption> nationalityOptions = [
    NationalityOption(value: "romanian", en: "Romanian", ro: "Român"),
    NationalityOption(value: "english", en: "English", ro: "Englez"),
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



  var playerIsMinor = false.obs;
  int? playerAge;

  RxList<CareerFields> fields = <CareerFields>[].obs;
  // List of trophy fields
  RxList<TrophyFields> trophies = <TrophyFields>[].obs;

  final GlobalKey firstNameKey = GlobalKey();
  final GlobalKey lastNameKey = GlobalKey();
  final GlobalKey emailKey = GlobalKey();
  final GlobalKey dobKey = GlobalKey();
  final GlobalKey careerKey = GlobalKey();
  final GlobalKey youtubeKey = GlobalKey();
  final GlobalKey trophiesKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController playerCategoryController = TextEditingController();
  TextEditingController countyNameController = TextEditingController();
  TextEditingController nationalityENController = TextEditingController();
  TextEditingController nationalityROController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController positionENController = TextEditingController();
  TextEditingController positionROController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController currentClubController = TextEditingController();
  TextEditingController squadNumController = TextEditingController();
  TextEditingController competitionLevelENController = TextEditingController();
  TextEditingController competitionLevelROController = TextEditingController();
  TextEditingController startContractDateController = TextEditingController();
  TextEditingController endContractDateController = TextEditingController();
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
  TextEditingController clubController = TextEditingController();
  TextEditingController seasonController = TextEditingController();
  TextEditingController matchesController = TextEditingController();

  //Career fields
  TextEditingController careerSeasonController = TextEditingController();
  TextEditingController careerClubController = TextEditingController();
  TextEditingController careerMatchesController = TextEditingController();
  TextEditingController careerGoalsController = TextEditingController();
  TextEditingController careerMinutesController = TextEditingController();
  TextEditingController careerAssistsController = TextEditingController();

 //Trophy fields
  TextEditingController trophyNameController = TextEditingController();
  TextEditingController trophyYearController = TextEditingController();
  File? trophyIcon;

  //youtube link
  RxBool showYoutubeField = false.obs;
  TextEditingController youtubeLinkController = TextEditingController();

  //Multiple youtube link
  RxList<TextEditingController> youtubeControllers = <TextEditingController>[].obs;

 //Document File
  File? selectedCVPdf;
  String? selectedCVFileName;
  String? apCVFileName;

  //Medical File
  File? selectedMedicalPdf;
  String? selectedMedicalFileName;
  String? apiMedicalFileName;

  //Arguments
  late String mode;
  String? playerId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    mode = args["mode"];
    playerId = args["id"];

    if (kDebugMode) {
      print("Mode: $mode");
    }
    if (kDebugMode) {
      print("Player ID: $playerId");
    }

    loadSavedCredentials();
    print("selectedLanguage: ${selectedLanguage.value}");
    if (mode == "edit") {
      Future.delayed(Duration.zero, () {
        getPlayerDetailApi(Get.context!, playerId: playerId);
      });
    }
  }


  Future<void> loadSavedCredentials() async {
    String? langCode = state.getLanguage();
    print("langCode====>$langCode");
    if (langCode != null && langCode.isNotEmpty) {
      selectedLanguage.value = langCode;
    } else {
      selectedLanguage.value = 'en';
    }
    update();
  }

  // Method to toggle selected preferred foot
  void updateSelectedPreferredFoot(String value) {
    selectedPreferredFoot = value;
    update();
  }

  // Method to toggle selected transfer status
  void updateSelectedTransferStatus(String value) {
    selectedTransferStatus = value;
    update();
  }

  // Method to toggle selected privacy
  void updateSelectedPrivacy(String value) {
    selectedPrivacy = value;
    update();
  }

  //Update selected position
  void updateSelectedPositionByEn(String en) {
    selectedPosition = positions.firstWhere((p) => p.en == en);
    update();
  }

  void updateSelectedPositionByRo(String ro) {
    selectedPosition = positions.firstWhere((p) => p.ro == ro);
    update();
  }

  //Update nationality
  void updateSelectedNationalityByEn(String en) {
    final option =
    nationalityOptions.firstWhere((p) => p.en == en);

    selectedNationalityOption = option;       // for UI
    selectedNationalityValue = option.value;  // for backend
    update();
  }

  void updateSelectedNationalityByRo(String ro) {
    final option =
    nationalityOptions.firstWhere((p) => p.ro == ro);

    selectedNationalityOption = option;       // for UI
    selectedNationalityValue = option.value;  // for backend
    update();
  }


  // Method to toggle selected preferred foot
  void updateSelectedPlayerCategory(String value) {
    selectedPlayerCategory = value;
    update();
  }

  // Method to toggle selected experience
  void updateSelectedExperienceLevel(String value) {
    selectedExperienceLevel = value;
    update();
  }

  // Method to toggle selected experience
  void updateSelectedConsistency(String value) {
    selectedConsistency = value;
    update();
  }


  //Add Remove career fields methods
  void removeCareerFieldSet(int index) {
    if (index >= 0 && index < fields.length) {
      final updatedList = List<CareerFields>.from(fields)..removeAt(index);
      fields.value = updatedList;
      update();
    }
  }

  //Duplicate career fielsd
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

  //Add remove you tube link
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


  void removeYoutubeField(int index) {
    // youtubeLinkController.clear();
    // showYoutubeField.value = false;
    youtubeControllers[index].dispose();
    youtubeControllers.removeAt(index);
  }


  Position? findPositionFromApi(String? en, String? ro) {
    if (en == null && ro == null) return null;

    return positions.firstWhereOrNull(
          (p) =>
      (en != null && p.en == en) ||
          (ro != null && p.ro == ro),
    );
  }

  NationalityOption? findNationalityFromApi(String? value) {
    if (value == null || value.isEmpty) return null;

    return nationalityOptions.firstWhereOrNull(
          (p) => p.value == value,
    );
  }

  //Add Player api
  Future<void> addPlayerApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);

      final addPlayerRequestBody = AddClubPlayerRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        dob: convertReadableDateToIso(dobController.text),
        nationality: selectedNationalityValue?? "",
        roNationality: selectedNationalityValue?? "",
        secondaryPosition: selectedSecondaryPositionValues,
        technicalAttributes: selectedTechnicalAttributesValues,
        playingStyle: selectedPlayingStyleValues,
        countryCode: countryCodeController.text,
        position: selectedPosition?.en,
        roPosition: selectedPosition?.ro,
        height: heightController.text,
        weight: weightController.text,
        currentClub: currentClubController.text,
        squadNumber: squadNumController.text,
        competitionLevel: competitionLevelENController.text,
        roCompetitionLevel: competitionLevelROController.text,
        contractStart: convertReadableDateToIso(startContractDateController.text),
        contractEnd: convertReadableDateToIso(endContractDateController.text),
        matchesPlayed: matchPlayedController.text,
        goals: goalsController.text,
        assists: assistsController.text,
        minutes: minutesController.text,
        callUps: callUpsController.text,
        caps: capsController.text,
        passCompletion: passCompletionController.text,
        duelsWon: duelsWonController.text,
        passAccuracy: passAccuracyController.text,
        shotsOnTarget: shotsOnTargetController.text,
        dribblesCompleted: dribblesCompletedController.text,
        club: clubController.text,
        season: seasonController.text,
        matches: matchesController.text,
        preferredFoot: selectedPreferredFoot,
        //roPreferredFoot:selectedPreferredFoot?.tr ,

        transferStatus: selectedTransferStatus,
        privacy: selectedPrivacy,
        //New fields
        country: lowerFirst(selectedPlayerCategory ?? ""),
        experienceLevel: lowerFirst(selectedExperienceLevel ?? ""),
        consistency: lowerFirst(selectedConsistency?? ""),
        county: countyNameController.text,
        //
        // youtubeLinks: youtubeLinkController.text.isNotEmpty
        //     ? [youtubeLinkController.text]
        //     : [],
        youtubeLinks: youtubeControllers
            .map((controller) => controller.text.trim())
            .where((link) => link.isNotEmpty)
            .toList(),
        career: fields.map((e) => Career(
          season: e.careerSeasonController.text,
          club: e.careerClubController.text,
          matches: e.careerMatchesController.text,
          goals: e.careerGoalsController.text,
          minutes: e.careerMinutesController.text,
          assists: e.careerAssistsController.text,
        )).toList(),
        trophies: trophies.map((e) => Trophies(
          name: e.trophyNameController.text,
          year: e.trophyYearController.text,
          icon: e.trophyImage?.path,
        )).toList(),
        files: Files(
          avatar: profileImageFile?.path,
          cv: selectedCVPdf?.path,
          medicalCertificate: selectedMedicalPdf?.path,
        ),
      );

      final Map<String, dynamic> fieldsMap = {};

      addPlayerRequestBody.toJson().forEach((key, value) {
        if (value == null) return;
        if (value is! List && value is! Map) {
          fieldsMap[key] = value.toString();
        }
      });

      // Youtube links
      for (int i = 0; i < (addPlayerRequestBody.youtubeLinks?.length ?? 0); i++) {
        fieldsMap['youtubeLinks[$i]'] =
        addPlayerRequestBody.youtubeLinks![i];
      }

      // Secondary position array
      for (int i = 0; i < (addPlayerRequestBody.secondaryPosition?.length ?? 0); i++) {
        fieldsMap['secondaryPosition[$i]'] =
        addPlayerRequestBody.secondaryPosition![i];
      }

      // technical attributes
      for (int i = 0; i < (addPlayerRequestBody.technicalAttributes?.length ?? 0); i++) {
        fieldsMap['technicalAttributes[$i]'] =
        addPlayerRequestBody.technicalAttributes![i];
      }

      // playing style
      for (int i = 0; i < (addPlayerRequestBody.playingStyle?.length ?? 0); i++) {
        fieldsMap['playingStyle[$i]'] =
        addPlayerRequestBody.playingStyle![i];
      }

      // Career array
      for (int i = 0; i < (addPlayerRequestBody.career?.length ?? 0); i++) {
        final c = addPlayerRequestBody.career![i];
        fieldsMap['career[$i][season]'] = c.season ?? '';
        fieldsMap['career[$i][club]'] = c.club ?? '';
        fieldsMap['career[$i][matches]'] = c.matches ?? '';
        fieldsMap['career[$i][goals]'] = c.goals ?? '';
        fieldsMap['career[$i][minutes]'] = c.minutes ?? '';
        fieldsMap['career[$i][assists]'] = c.assists ?? '';
      }

      // Trophies array
      for (int i = 0; i < (addPlayerRequestBody.trophies?.length ?? 0); i++) {
        final t = addPlayerRequestBody.trophies![i];
        fieldsMap['trophies[$i][name]'] = t.name ?? '';
        fieldsMap['trophies[$i][year]'] = t.year ?? '';
      }


      final Map<String, File> filesMap = {};

      if (addPlayerRequestBody.files?.avatar != null) {
        filesMap['avatar'] = File(addPlayerRequestBody.files!.avatar!);
      }

      if (addPlayerRequestBody.files?.cv != null) {
        filesMap['cv'] = File(addPlayerRequestBody.files!.cv!);
      }

      if (addPlayerRequestBody.files?.medicalCertificate != null) {
        filesMap['medicalCertificate'] =
            File(addPlayerRequestBody.files!.medicalCertificate!);
      }

      // Trophy icons
      for (int i = 0; i < (addPlayerRequestBody.trophies?.length ?? 0); i++) {
        final iconPath = addPlayerRequestBody.trophies![i].icon;
        if (iconPath != null && iconPath.isNotEmpty) {
          filesMap['trophies[$i][icon]'] = File(iconPath);
        }
      }

      // 🔍 DEBUG: Print all fields
      debugPrint("📦 FIELDS SENT TO API:");
      fieldsMap.forEach((key, value) {
        debugPrint("➡️ $key : $value");
      });

      // Print all files
      debugPrint("🖼 FILES SENT TO API:");
      filesMap.forEach((key, file) {
        debugPrint("➡️ $key : ${file.path}");
      });

      final response = await state.addPlayer(
        fields: fieldsMap,
        files: filesMap,
      );

      LoaderDialog.hide(context);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        //successToast(response.data['responseMessage'] ?? 'Player added');
        Future.delayed(Duration(milliseconds: 500),() {
          showCommonDialog(
            closeIconColor: ThemeProvider.blackColor,
            bgColor: ThemeProvider.whiteColor,
            titleColor: ThemeProvider.blackColor,
            messageColor: ThemeProvider.textColor,
            showCloseButton: true,
            circleSize: 80,
            context: Get.context!,
            title: "Success!",
            message: "Your Player has been successfully added in your  list.",
            svgAsset: AssetPath.successFilled,
          );
        },);
        Navigator.of(context).pop();
      } else {
        errorToast(response?.data['responseMessage'] ?? 'Something went wrong');
      }
    } catch (e) {
      LoaderDialog.hide(context);
      print("❌ Add player error: $e");
      errorToast("Failed to add player");
    }
  }

  //Checkmark
  ///Personal info check
  RxBool personalInfoCompleted = false.obs;
  void evaluatePersonalInfoFromApi() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      personalInfoCompleted.value = false;
      return;
    }
    personalInfoCompleted.value =
        (playerData.firstName?.trim().isNotEmpty ?? false) &&
            (playerData.lastName?.trim().isNotEmpty ?? false) &&
            (playerData.email?.trim().isNotEmpty ?? false) &&
            (playerData.dob != null) &&
            (playerData.country?.trim().isNotEmpty ?? false) &&
            (playerData.county?.trim().isNotEmpty ?? false) &&
            (playerData.nationality?.trim().isNotEmpty ?? false) &&
            (playerData.countryCode?.trim().isNotEmpty ?? false) &&
            (playerData.position?.trim().isNotEmpty ?? false) &&
            (playerData.secondaryPosition?.isNotEmpty ?? false) &&
            (playerData.technicalAttributes?.isNotEmpty ?? false) &&
            (playerData.playingStyle?.isNotEmpty ?? false) &&
            (playerData.height != null) &&
            (playerData.weight != null) &&
            (playerData.preferredFoot?.trim().isNotEmpty ?? false) &&
            (playerData.experienceLevel?.trim().isNotEmpty ?? false) &&
            (playerData.consistency?.trim().isNotEmpty ?? false) &&
            (playerData.currentTeam?.trim().isNotEmpty ?? false) &&
            (playerData.squadNumber != null) &&
            (playerData.competitionLevel?.trim().isNotEmpty ?? false) &&
            (playerData.roCompetitionLevel?.trim().isNotEmpty ?? false) &&
            (playerData.contractStart != null) &&
            (playerData.contractEnd != null) &&
            (playerData.transferStatus?.trim().isNotEmpty ?? false);
  }

  ///Career
  RxBool careerCompleted = false.obs;
  void evaluateCareerSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      careerCompleted.value = false;
      return;
    }

    careerCompleted.value = (playerData.career?.isNotEmpty?? false);
  }

  ///Stats
  RxBool statsCompleted = false.obs;
  void evaluateStatsSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      statsCompleted.value = false;
      return;
    }

    statsCompleted.value =
        (playerData.matchesPlayed != null && playerData.matchesPlayed != 0) &&
            (playerData.goals != null && playerData.goals != 0) &&
            (playerData.assists != null && playerData.assists != 0) &&
            (playerData.minutes != null && playerData.minutes != 0);
  }

  ///National team
  RxBool nationalTeamCompleted = false.obs;
  void evaluateNationalTeamSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      nationalTeamCompleted.value = false;
      return;
    }

    nationalTeamCompleted.value =
        (playerData.callUps != null && playerData.callUps != 0) &&
            (playerData.caps != null && playerData.caps != 0);
  }

  ///Performance Percentages
  RxBool performanceCompleted = false.obs;
  void evaluatePerformanceSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      performanceCompleted.value = false;
      return;
    }

    performanceCompleted.value =
        (playerData.passCompletion ?? 0) > 0 &&
            (playerData.duelsWon ?? 0) > 0 &&
            (playerData.passAccuracy ?? 0) > 0 &&
            (playerData.shotsOnTarget ?? 0) > 0 &&
            (playerData.dribblesCompleted ?? 0) > 0;
  }

  ///Youtube links
  RxBool youtubeCompleted = false.obs;
  void evaluateYoutubeSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      youtubeCompleted.value = false;
      return;
    }

    youtubeCompleted.value = (playerData.youtubeLinks?.isNotEmpty??false);
  }

  ///Achievements
  RxBool achievementsCompleted = false.obs;
  void evaluateAchievementsSection() {
    final playerData = getPlayerDetailModal.data;

    if (playerData == null) {
      achievementsCompleted.value = false;
      return;
    }

    final isClubFilled = (playerData.club?.trim().isNotEmpty ?? false);
    final isSeasonFilled = (playerData.season?.trim().isNotEmpty ?? false);
    final isMatchesFilled = (playerData.matches ?? 0) > 0;

    // At least ONE trophy must have valid data
    final hasAnyTrophy =
        playerData.trophies?.any((trophy) =>
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


  //Get Player Detail for edit
  player.GetPlayerDetailModal getPlayerDetailModal = player.GetPlayerDetailModal();
  Future<player.GetPlayerDetailModal?> getPlayerDetailApi(BuildContext context,{String? playerId}) async {
    try {
      LoaderDialog.show(context);
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getPlayerDetailById(playerId: playerId);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        getPlayerDetailModal = player.GetPlayerDetailModal.fromJson(data);

        if(getPlayerDetailModal.code == 200){
          final playerData = getPlayerDetailModal.data; // main player detail object


          if (playerData == null) return null;
          setSecondaryPositionsFromApi(playerData.secondaryPosition);
          setTechnicalAttributesFromApi(playerData.technicalAttributes);
          setPlayingStyleFromApi(playerData.playingStyle);
          firstNameController.text = (playerData.firstName ?? '').toString();
          lastNameController.text = (playerData.lastName ?? '').toString();
          emailController.text = (playerData.email ?? '').toString();
          dobController.text = formatDate((playerData.dob ?? '').toString());
          countryCodeController.text = (playerData.countryCode ?? '').toString();
          selectedNationalityOption = findNationalityFromApi(
              playerData.nationality,
          );
          selectedNationalityValue = selectedNationalityOption?.value;
          selectedPosition = findPositionFromApi(
            playerData.position,
            playerData.roPosition,
          );
          currentClubController.text = (playerData.currentTeam ?? '').toString();
          competitionLevelENController.text = (playerData.competitionLevel ?? '').toString();
          competitionLevelROController.text = (playerData.roCompetitionLevel ?? '').toString();

          // Numeric fields
          heightController.text = (playerData.height ?? '').toString();
          weightController.text = (playerData.weight ?? '').toString();
          squadNumController.text = (playerData.squadNumber ?? '').toString();
          matchPlayedController.text = (playerData.matchesPlayed ?? '').toString();
          goalsController.text = (playerData.goals ?? '').toString();
          assistsController.text = (playerData.assists ?? '').toString();
          minutesController.text = (playerData.minutes ?? '').toString();
          callUpsController.text = (playerData.callUps ?? '').toString();
          capsController.text = (playerData.caps ?? '').toString();
          passCompletionController.text = (playerData.passCompletion ?? '').toString();
          duelsWonController.text = (playerData.duelsWon ?? '').toString();
          passAccuracyController.text = (playerData.passAccuracy ?? '').toString();
          shotsOnTargetController.text = (playerData.shotsOnTarget ?? '').toString();
          dribblesCompletedController.text = (playerData.dribblesCompleted ?? '').toString();
          matchesController.text = (playerData.matches ?? '').toString();

          // Contract dates
          startContractDateController.text =formatDate((playerData.contractStart ?? '').toString());
          endContractDateController.text = formatDate((playerData.contractEnd ?? '').toString());

          // Dropdowns
          selectedPreferredFoot = (playerData.preferredFoot != null && playerData.preferredFoot!.isNotEmpty)
              ? playerData.preferredFoot
              : null;
          selectedTransferStatus = (playerData.transferStatus != null && playerData.transferStatus!.isNotEmpty)
              ? playerData.transferStatus
              : null;
          selectedPrivacy = (playerData.privacy != null && playerData.privacy!.isNotEmpty)
              ? playerData.privacy
              : null;

          //New DropDowns
          selectedPlayerCategory = (playerData.country != null && playerData.country!.isNotEmpty)
              ? capitalizeFirst(playerData.country.toString())
              : null;
          selectedExperienceLevel = (playerData.experienceLevel != null && playerData.experienceLevel!.isNotEmpty)
              ? capitalizeFirst(playerData.experienceLevel.toString())
              : null;
          selectedConsistency = (playerData.consistency != null && playerData.consistency!.isNotEmpty)
              ? capitalizeFirst(playerData.consistency.toString())
              : null;
          countyNameController.text = (playerData.county ?? '').toString();

          clubController.text = (playerData.club ?? '').toString();
          seasonController.text = (playerData.season ?? '').toString();
          // Youtube link
          // if (playerData.youtubeLinks != null &&
          //     playerData.youtubeLinks!.isNotEmpty &&
          //     playerData.youtubeLinks!.first.isNotEmpty) {
          //   youtubeLinkController.text = playerData.youtubeLinks!.first;
          //   showYoutubeField.value = true;      // <-- IMPORTANT
          // } else {
          //   youtubeLinkController.clear();
          //   showYoutubeField.value = false;
          // }
          // Youtube links (multiple)
          youtubeControllers.clear();

          if (playerData.youtubeLinks != null &&
              playerData.youtubeLinks!.isNotEmpty) {

            for (final link in playerData.youtubeLinks!) {
              if (link.trim().isNotEmpty) {
                youtubeControllers.add(
                  TextEditingController(text: link),
                );
              }
            }
          }

          // Files
          profileImageUrl = playerData.avatar != null && playerData.avatar!.isNotEmpty ? "${Utils.imageUrl}${playerData.avatar}" : null;
          // selectedCVPdf = playerData.cv != null && playerData.cv!.isNotEmpty ? File(playerData.cv!) : null;
          selectedCVFileName = playerData.cv != null && playerData.cv!.isNotEmpty ? playerData.cv! : null;
          apCVFileName = playerData.cv != null && playerData.cv!.isNotEmpty ? playerData.cv! : null;
          // selectedMedicalPdf =
          // playerData.medicalCertificate != null && playerData.medicalCertificate!.isNotEmpty
          //     ? File(playerData.medicalCertificate!)
          //     : null;
          selectedMedicalFileName = playerData.medicalCertificate != null && playerData.medicalCertificate!.isNotEmpty ? playerData.medicalCertificate! : null;
          apiMedicalFileName = playerData.medicalCertificate != null && playerData.medicalCertificate!.isNotEmpty ? playerData.medicalCertificate! : null;

          // Career List (Dynamic UI)
          fields.clear();
          if (playerData.career != null) {
            for (var c in playerData.career!) {
              final item = CareerFields(
                careerSeasonController: TextEditingController(text: c.season ?? ''),
                careerClubController: TextEditingController(text: c.club ?? ''),
                careerMatchesController: TextEditingController(text: c.matches ?? ''),
                careerGoalsController: TextEditingController(text: c.goals ?? ''),
                careerMinutesController: TextEditingController(text: c.minutes ?? ''),
                careerAssistsController: TextEditingController(text: c.assists ?? ''),
              );
              fields.add(item);
              update();
            }
          }


          // Trophies
          trophies.clear();
          if (playerData.trophies != null) {
            for (var t in playerData.trophies!) {
              final item = TrophyFields(
                trophyNameController: TextEditingController(text: t.name ?? ''),
                trophyYearController: TextEditingController(text: t.year?.toString() ?? ''),
                trophyImageFileName: t.icon
              );
              trophies.add(item);
              update();
            }
          }
          evaluatePersonalInfoFromApi();
          evaluateCareerSection();
          evaluateStatsSection();
          evaluateNationalTeamSection();
          evaluatePerformanceSection();
          evaluateYoutubeSection();
          evaluateAchievementsSection();

          update();
          LoaderDialog.hide(context);
        }
        return getPlayerDetailModal;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching plans: $e");
      return null;
    }
  }

  void setSecondaryPositionsFromApi(List<String>? values) {
    if (values == null) return;

    final items = secondaryPositions
        .where((p) => values.contains(p.value))
        .toList();

    selectedSecondaryPositions.value = items;
    selectedSecondaryPositionValues.value =
        items.map((e) => e.value).toList();
  }
  void setTechnicalAttributesFromApi(List<String>? values) {
    if (values == null) return;

    final items = technicalAttributes
        .where((p) => values.contains(p.value))
        .toList();

    selectedTechnicalAttributes.value = items;
    selectedTechnicalAttributesValues.value =
        items.map((e) => e.value).toList();
  }
  void setPlayingStyleFromApi(List<String>? values) {
    if (values == null) return;

    final items = playingStyle
        .where((p) => values.contains(p.value))
        .toList();

    selectedPlayingStyle.value = items;
    selectedPlayingStyleValues.value =
        items.map((e) => e.value).toList();
  }



  //Add Player api
  Future<void> editPlayerApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);

      final addPlayerRequestBody = AddClubPlayerRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        dob: convertReadableDateToIso(dobController.text),
        nationality: selectedNationalityValue ?? "",
        roNationality: selectedNationalityValue?? "",
        secondaryPosition: selectedSecondaryPositionValues,
        technicalAttributes: selectedTechnicalAttributesValues,
        playingStyle: selectedPlayingStyleValues,
        countryCode: countryCodeController.text,
        position: selectedPosition?.en,
        roPosition: selectedPosition?.ro,
        height: heightController.text,
        weight: weightController.text,
        currentClub: currentClubController.text,
        squadNumber: squadNumController.text,
        competitionLevel: competitionLevelENController.text,
        roCompetitionLevel: competitionLevelROController.text,
        contractStart: convertReadableDateToIso(startContractDateController.text),
        contractEnd: convertReadableDateToIso(endContractDateController.text),
        matchesPlayed: matchPlayedController.text,
        goals: goalsController.text,
        assists: assistsController.text,
        minutes: minutesController.text,
        callUps: callUpsController.text,
        caps: capsController.text,
        passCompletion: passCompletionController.text,
        duelsWon: duelsWonController.text,
        passAccuracy: passAccuracyController.text,
        shotsOnTarget: shotsOnTargetController.text,
        dribblesCompleted: dribblesCompletedController.text,
        club: clubController.text,
        season: seasonController.text,
        matches: matchesController.text,
        preferredFoot: selectedPreferredFoot,
        transferStatus: selectedTransferStatus,
        privacy: selectedPrivacy,
        //New fields
        country: lowerFirst(selectedPlayerCategory ?? ""),
        experienceLevel: lowerFirst(selectedExperienceLevel?? ""),
        consistency: lowerFirst(selectedConsistency?? ""),
        county: countyNameController.text,
        //

        // youtubeLinks: youtubeLinkController.text.isNotEmpty
        //     ? [youtubeLinkController.text]
        //     : [],
        youtubeLinks: youtubeControllers
            .map((controller) => controller.text.trim())
            .where((link) => link.isNotEmpty)
            .toList(),
        career: fields.map((e) => Career(
          season: e.careerSeasonController.text,
          club: e.careerClubController.text,
          matches: e.careerMatchesController.text,
          goals: e.careerGoalsController.text,
          minutes: e.careerMinutesController.text,
          assists: e.careerAssistsController.text,
        )).toList(),
        trophies: trophies.map((e) => Trophies(
          name: e.trophyNameController.text,
          year: e.trophyYearController.text,
          icon: e.trophyImage?.path,
        )).toList(),
        files: Files(
          avatar: profileImageFile?.path,
          cv: selectedCVPdf?.path,
          medicalCertificate: selectedMedicalPdf?.path,
        ),
      );

      final Map<String, dynamic> fieldsMap = {};

      // Simple fields
      addPlayerRequestBody.toJson().forEach((key, value) {
        if (value == null) return;
        if (value is! List && value is! Map) {
          fieldsMap[key] = value.toString();
        }
      });

      // Youtube links
      for (int i = 0; i < (addPlayerRequestBody.youtubeLinks?.length ?? 0); i++) {
        fieldsMap['youtubeLinks[$i]'] =
        addPlayerRequestBody.youtubeLinks![i];
      }

      // Secondary position array
      for (int i = 0; i < (addPlayerRequestBody.secondaryPosition?.length ?? 0); i++) {
        fieldsMap['secondaryPosition[$i]'] =
        addPlayerRequestBody.secondaryPosition![i];
      }

      // technical attributes
      for (int i = 0; i < (addPlayerRequestBody.technicalAttributes?.length ?? 0); i++) {
        fieldsMap['technicalAttributes[$i]'] =
        addPlayerRequestBody.technicalAttributes![i];
      }

      // playing style
      for (int i = 0; i < (addPlayerRequestBody.playingStyle?.length ?? 0); i++) {
        fieldsMap['playingStyle[$i]'] =
        addPlayerRequestBody.playingStyle![i];
      }

      // Career array
      for (int i = 0; i < (addPlayerRequestBody.career?.length ?? 0); i++) {
        final c = addPlayerRequestBody.career![i];
        fieldsMap['career[$i][season]'] = c.season ?? '';
        fieldsMap['career[$i][club]'] = c.club ?? '';
        fieldsMap['career[$i][matches]'] = c.matches ?? '';
        fieldsMap['career[$i][goals]'] = c.goals ?? '';
        fieldsMap['career[$i][minutes]'] = c.minutes ?? '';
        fieldsMap['career[$i][assists]'] = c.assists ?? '';
      }

      // Trophies array
      for (int i = 0; i < (addPlayerRequestBody.trophies?.length ?? 0); i++) {
        final t = addPlayerRequestBody.trophies![i];
        fieldsMap['trophies[$i][name]'] = t.name ?? '';
        fieldsMap['trophies[$i][year]'] = t.year ?? '';
      }


      final Map<String, File> filesMap = {};

      if (addPlayerRequestBody.files?.avatar != null) {
        filesMap['avatar'] = File(addPlayerRequestBody.files!.avatar!);
      }

      if (addPlayerRequestBody.files?.cv != null) {
        filesMap['cv'] = File(addPlayerRequestBody.files!.cv!);
      }

      if (addPlayerRequestBody.files?.medicalCertificate != null) {
        filesMap['medicalCertificate'] =
            File(addPlayerRequestBody.files!.medicalCertificate!);
      }

      // Trophy icons
      for (int i = 0; i < (addPlayerRequestBody.trophies?.length ?? 0); i++) {
        final iconPath = addPlayerRequestBody.trophies![i].icon;
        if (iconPath != null && iconPath.isNotEmpty) {
          filesMap['trophies[$i][icon]'] = File(iconPath);
        }
      }

      // Print all fields
      debugPrint("📦 FIELDS SENT TO API:");
      fieldsMap.forEach((key, value) {
        debugPrint("➡️ $key : $value");
      });

// 🔍 DEBUG: Print all files
      debugPrint("🖼 FILES SENT TO API:");
      filesMap.forEach((key, file) {
        debugPrint("➡️ $key : ${file.path}");
      });

      final response = await state.editPlayer(
        playerId: playerId,
        fields: fieldsMap,
        files: filesMap,
      );

      LoaderDialog.hide(context);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        successToast(response.data['responseMessage'] ?? 'Player updated successfully.'.tr);
        Navigator.of(context).pop();
      } else {
        errorToast(response?.data['responseMessage'] ?? 'Something went wrong'.tr);
      }
    } catch (e) {
      LoaderDialog.hide(context);
      if (kDebugMode) {
        print("❌ update player error: $e");
      }
      errorToast("Failed to update player".tr);
    }
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

  String lowerFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toLowerCase() + value.substring(1);
  }
  String capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  updateShowMoreFields(){
    showMoreFields.value =! showMoreFields.value;
    update();
    print("showMoreFields--->${showMoreFields.value}");
  }

}
class Position {
  final String en;
  final String ro;

  const Position({
    required this.en,
    required this.ro,
  });
}
class SecondaryPosition {
  final String en;
  final String ro;
  final String value;

  const SecondaryPosition({
    required this.en,
    required this.ro,
    required this.value,
  });
}

class NationalityOption {
  final String value;
  final String en;
  final String ro;

  const NationalityOption({
    required this.value,
    required this.en,
    required this.ro,
  });
}