import 'dart:convert';

import 'package:get/get.dart';
import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../backend/model/player_model.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/app_assets.dart';
import '../../utils/utils.dart';
import '../add_player_screen/add_player_screen_logic.dart';
import '../club_scouting/club_scout_state.dart' hide NationalityOption;

class PlayersListState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  PlayersListState({required this.apiService, required this.sharedPreferencesManager});

  PlayerModel? leftPlayer;
  PlayerModel? rightPlayer;
  int limit = 10;
  RxMap<String, String> appliedFilters = <String, String>{}.obs;
  List<PlayerModel> allPlayers = [];

  // Filter list data variables ..
  RxString primaryPosition = "".obs;
  RxString playerFoot = "".obs;
  RxString playerHeight = "".obs;
  RxString playerWeight = "".obs;
  RxString playerAge = "".obs;
  RxString playerCountry = "".obs;
  RxString playerCounty = "".obs;
  RxString playerUnderContract = "".obs;
  RxString playerAvailableForLoan = "".obs;
  RxString playerNationality = "".obs;
  RxString playerExperienceLevel = "".obs;
  RxString playerConsistency = "".obs;
  RxList<String> playingStyle = <String>[].obs;
  RxList<String> technicalAttribute = <String>[].obs;
  RxList<String> secondaryRole = <String>[].obs;

  // Filter list data..
  final List<Map<String, dynamic>> filterList = [
    {"title": "Position", "icon": AssetPath.player, "isSelected": false},
    {"title": "Foot", "icon": AssetPath.foot, "isSelected": false},
    {"title": "Height", "icon": AssetPath.height, "isSelected": false},
    {"title": "Weight", "icon": AssetPath.height, "isSelected": false},
    {"title": "Age", "icon": AssetPath.ageIcon, "isSelected": false},
    {"title": "Player type", "icon": AssetPath.countryIcon, "isSelected": false},
    {"title": "County (Romania)", "icon": AssetPath.countryRomaniaIcon, "isSelected": false},
    {"title": "Under Contract", "icon": AssetPath.underContractIcon, "isSelected": false},
    {"title": "Available for Loan", "icon": AssetPath.loanIcon, "isSelected": false},
    {"title": "Nationality", "icon": AssetPath.nationalityIcons, "isSelected": false},
    {"title": "Experience Level", "icon": AssetPath.expLevelIcon, "isSelected": false},
    {"title": "Consistency", "icon": AssetPath.consistencyIcon, "isSelected": false},
    {"title": "Playing Style", "icon": AssetPath.playingStyleIcon, "isSelected": false},
    {"title": "Technical Attributes", "icon": AssetPath.playingStyleIcon, "isSelected": false},
    //{"title": "Strength", "icon": AssetPath.strengthIcon, "isSelected": false},
  ];

  List<String> ageOptions = ["U-8 (Under 8)", "U-10 (Under 10)", "U-16 (Under 16)", "U-18 (Under 18)", "Senior (18+)"];

  List<String> positions = [
    'Goalkeeper',
    'Right Back',
    'Left Back',
    'Center Back',
    'Defensive Midfield',
    'Right Wing/Forward',
    'Central Midfield',
    'Striker',
    'Attacking Midfield',
    'Left Wing/Forward',
    'Right Midfielder',
    'Left Midfielder',
  ];

  List<String> leagueLevelPlayedOptions = [
    "Romania Liga- 1",
    "Romania Liga- 2",
    "Romania Liga- 3",
    "Romania Liga- 4",
    "Academy Level",
    "International - Division 1",
    "International - Division 2",
    "International - Division 3",
  ];

  List<String> accelerateOptions = ["Low", "Medium", "High"];
  List<String> speedOptions = ["Low", "Medium", "High"];
  List<String> strengthOptions = ["Low", "Medium", "High"];

  List<String> experience = ["Professional", "Semi-professional", "Amateur"];

  List<String> playerTypeList = ["Romanian", "International", "Self Promoted"];
  List<String> consistencyList = ["Low", "Medium", "High"];

  List<String> countryList = [
    "Alba",
    "Arad",
    "Arges",
    "Bacau",
    "Bihor",
    "Bistrita-Nasaud",
    "Botosani",
    "Brasov",
    "Braila",
    "Bucuresti",
    "Buzau",
    "Caras-Severin",
    "Calarasi",
    "Cluj",
    "Constanta",
    "Covasna",
    "Dambovita",
    "Dolj",
    "Galati",
    "Giurgiu",
    "Gorj",
    "Harghita",
    "Hunedoara",
    "Ialomita",
    "Iasi",
    "Ilfov",
    "Maramures",
    "Mehedinti",
    "Mures",
    "Neamt",
    "Olt",
    "Prahova",
    "Satu Mare",
    "Salaj",
    "Sibiu",
    "Suceava",
    "Teleorman",
    "Timis",
    "Tulcea",
    "Vaslui",
    "Valcea",
    "Vrancea",
    "Bucharest",
  ];

  List<String> footList = ["Left", "Right", "Both"];

  List<String> videoTypeList = ["Skills", "Goals", "Defensive Actions", "Full Match", "Training Sessions", "Highlight Mix"];

  List<String> contractStatusList = ["Yes", "No"];

  List<String> availableLoanList = ["Yes", "No"];

  List<String> verificationList = ["Verified", "Not Verified"];

  List<String> primaryPositionList = [
    "Goalkeeper",
    "Right Back",
    "Left Back",
    "Right Wing Back",
    "Left Wing Back",
    "Center Back",
    "Right Center Back",
    "Left Center Back",
    "Defensive Midfielder",
    "Attacking Midfielder",
    "Right Midfielder",
    "Left Midfielder",
    "Right Winger",
    "Left Winger",
    "Center Forward",
    "Striker",
    "Second Striker",
  ];

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

  List<DemoModelCheckBox> playingStyleList = [
    DemoModelCheckBox(title: "Ball Winner", isSelect: false),
    DemoModelCheckBox(title: "Box-to-Box Midfielder", isSelect: false),
    DemoModelCheckBox(title: "Target Man", isSelect: false),
    DemoModelCheckBox(title: "Playmaker", isSelect: false),
    DemoModelCheckBox(title: "Pace Winger", isSelect: false),
    DemoModelCheckBox(title: "Inverted Winger", isSelect: false),
    DemoModelCheckBox(title: "Poacher", isSelect: false),
    DemoModelCheckBox(title: "Pressing-forward", isSelect: false),
    DemoModelCheckBox(title: "Sweeper Keeper", isSelect: false),
  ];

  List<DemoModelCheckBox> technicalAttributesList = [
    DemoModelCheckBox(title: "Passing", isSelect: false),
    DemoModelCheckBox(title: "Dribbling", isSelect: false),
    DemoModelCheckBox(title: "Shooting", isSelect: false),
    DemoModelCheckBox(title: "Ball Control", isSelect: false),
    DemoModelCheckBox(title: "First Touch", isSelect: false),
    DemoModelCheckBox(title: "Vision", isSelect: false),
    DemoModelCheckBox(title: "Technique", isSelect: false),
    DemoModelCheckBox(title: "Crossing", isSelect: false),
    DemoModelCheckBox(title: "Finishing", isSelect: false),
    DemoModelCheckBox(title: "Long Shots", isSelect: false),
    DemoModelCheckBox(title: "Tackling", isSelect: false),
    DemoModelCheckBox(title: "Heading", isSelect: false),
    DemoModelCheckBox(title: "Marking", isSelect: false),
  ];

  List<DemoModelCheckBox> secondaryRoleList = [
    DemoModelCheckBox(title: "Box-to-Box Midfielder", isSelect: false),
    DemoModelCheckBox(title: "Deep-Lying Playmaker", isSelect: false),
    DemoModelCheckBox(title: "Inverted Winger", isSelect: false),
    DemoModelCheckBox(title: "Target Man", isSelect: false),
    DemoModelCheckBox(title: "Ball Winning Midfielder", isSelect: false),
    DemoModelCheckBox(title: "Shadow Striker", isSelect: false),
  ];



  applyFilters() {
    appliedFilters.clear();
    if (primaryPosition.value.isNotEmpty) appliedFilters["Position"] = primaryPosition.value;
    if (playerFoot.value.isNotEmpty) appliedFilters["Foot"] = playerFoot.value;
    if (playerCountry.value.isNotEmpty) appliedFilters["Player type"] = playerCountry.value;
    if (playerHeight.isNotEmpty) appliedFilters["Height"] = playerHeight.value;
    if (playerWeight.isNotEmpty) appliedFilters["Weight"] = playerWeight.value;
    if (playerAge.value.isNotEmpty) appliedFilters["Age"] = playerAge.value;
    if (playerCountry.value.isNotEmpty) appliedFilters["Country"] = playerCountry.value;
    if (playerCounty.value.isNotEmpty) appliedFilters["County"] = playerCounty.value;
    if (playerUnderContract.value.isNotEmpty) appliedFilters["Under Contract"] = playerUnderContract.value;
    if (playerAvailableForLoan.value.isNotEmpty) appliedFilters["Available for Loan"] = playerAvailableForLoan.value;
    if (playerNationality.isNotEmpty) appliedFilters["Nationality"] = playerNationality.value;
    if (playerExperienceLevel.value.isNotEmpty) appliedFilters["Experience Level"] = playerExperienceLevel.value;
    if (playerConsistency.value.isNotEmpty) appliedFilters["Consistency"] = playerConsistency.value;

    if (playingStyle.isNotEmpty) appliedFilters["Playing Style"] = jsonEncode(playingStyle);
    if (technicalAttribute.isNotEmpty) appliedFilters["Technical Attributes"] = jsonEncode(technicalAttribute);
    if (secondaryRole.isNotEmpty) appliedFilters["Secondary Role"] = jsonEncode(secondaryRole);

  }

  clearAllFilters() async {
    primaryPosition.value = '';
    playerFoot.value = '';
    playerHeight.value = '';
    playerWeight.value = '';
    playerAge.value = '';
    playerCountry.value = '';
    playerCounty.value = '';
    playerUnderContract.value = '';
    playerAvailableForLoan.value = '';
    playerNationality.value = '';
    playerExperienceLevel.value = '';
    playerConsistency.value = '';

    playingStyle.clear();
    technicalAttribute.clear();
    secondaryRole.clear();

    for (final item in filterList) {
      item['isSelected'] = false;
    }

    for (final item in playingStyleList) {
      item.isSelect = false;
    } for (final item in secondaryRoleList) {
      item.isSelect = false;
    }for (final item in technicalAttributesList) {
      item.isSelect = false;
    }

    appliedFilters.clear();
  }

  getClubPlayers({
    int? page,
    String? search,
    String position = "",
    String foot = "",
    String height = "",
    String weight = "",
    String age = "",
    String country = "",
    String county = "",
    String underContract = "",
    String availableForLoan = "",
    String nationality = "",
    String experience = "",
    String consistency = "",
    List<String> playingStyle = const [],
    List<String> technicalAttributes = const [],
    List<String> secondaryPosition = const [],
  }) async {
    final endpoint = await getPlayerListEndpoint();

    String minHeight = height.isNotEmpty ? separateValue(value: height, key: 0).toString() : "";
    String maxHeight = height.isNotEmpty ? separateValue(value: height, key: 1).toString() : "";
    String minWeight = weight.isNotEmpty ? separateValue(value: weight, key: 0).toString() : "";
    String maxWeight = weight.isNotEmpty ? separateValue(value: weight, key: 1).toString() : "";

    // Only include true/false if user selected Yes/No
    final underContractParam = (playerUnderContract.value.isNotEmpty)
        ? (playerUnderContract.value.toLowerCase() == "yes" ? "true" : "false")
        : null;

    final availableForLoanParam = (playerAvailableForLoan.value.isNotEmpty)
        ? (playerAvailableForLoan.value.toLowerCase() == "yes" ? "true" : "false")
        : null;

    // Build query string
    final searchQuery =
        "&search=$search"
        "&position=$position"
        "&foot=$foot"
        "&minHeight=$minHeight"
        "&maxHeight=$maxHeight"
        "&minWeight=$minWeight"
        "&maxWeight=$maxWeight"
        "&age=$age"
        "&country=$country"
        "&county=$county"
        "${underContractParam != null ? "&underContract=$underContractParam" : ""}"
        "${availableForLoanParam != null ? "&availableForLoan=$availableForLoanParam" : ""}"
        "&nationality=$nationality"
        "&experienceLevel=$experience"
        "&consistency=$consistency"
        "&playingStyle=${jsonEncode(playingStyle) ?? ""}"
        "&technicalAttributes=${jsonEncode(technicalAttributes) ?? ""}"
        "&secondaryPosition=${jsonEncode(secondaryPosition) ?? ""}";

    return await apiService.getApiWithHeader("$endpoint?limit=$limit&page=$page$searchQuery");
  }



  deleteClubPlayers({String? playerId}) async {
    final endpoint = await getAddPlayerEndpoint();
    return await apiService.deleteApiWithoutBody("$endpoint/$playerId");
  }

  fetchingPlayList(String page) async {
    return await apiService.getApiWithHeader("scouting/comparePlayersList?page=$page&limit=10");
  }

  fetchingPlayerDetail(String id) async {
    return await apiService.getApiWithHeader("scouting/comparePlayer/$id");
  }

  clearFilter() async {
    return await apiService.patchApiWithoutBody("scouting/comparePlayersList/clear");
  }
}
