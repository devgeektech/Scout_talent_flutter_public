import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';
import '../../utils/constants.dart';

class ClubScoutSearchParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ClubScoutSearchParser({required this.sharedPreferencesManager, required this.apiService});

  int limits = 10;
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

  bool haveLoggedIn() {
    final token = sharedPreferencesManager.getString('token') ?? "";
    debugPrint("Saved Token in haveLoggedIn(): $token");
    return token.isNotEmpty;
  }

  void savePhoneLange(String lang) {
    sharedPreferencesManager.putString('lang', lang);
  }

  Future<void> saveCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("savedPlayerCount", count);
  }

  Future<int> getSavedCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("savedPlayerCount") ?? 0;
  }

  Future<bool> isFreeAccount(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFreeAccount", value);
    debugPrint("Saved isFreeAccount: $value");
    return value;
  }

  fetchingPlayList(
    int page, {
    String search = "",
    String position = "",
    String foot = "",
    String height = "",
    String weight = "",
    String club = "",
    String age = "",
    String country = "",
    String county = "",
    String? underContract ,
    String experienceLevel = "",
    String nationality = "",
    String availableForLoan = "",
    String consistency = "",
    List<String> playingStyle = const [],
    List<String> technicalAttributes = const [],
    List<String> secondaryPosition = const [],
  }) async {
    String minHeight = height.isNotEmpty ? separateValue(value: height, key: 0).toString() : "";
    String maxHeight = height.isNotEmpty ? separateValue(value: height, key: 1).toString() : "";
    String minWeight = weight.isNotEmpty ? separateValue(value: weight, key: 0).toString() : "";
    String maxWeight = weight.isNotEmpty ? separateValue(value: weight, key: 1).toString() : "";

    if (sharedPreferencesManager.getString('selectedUserRole') == Constants.userRoleClubScout) {
      return await apiService.getApiWithHeader(
       // "scout-players/list?limit=$limits&page=$page&search=$search&county=$county&position=$position&foot=$foot&minHeight=$minHeight&maxHeight=$maxHeight&club=$club&age=$age&country=$country&underContract=$underContract&availableForLoan=$availableForLoan&experienceLevel=$experienceLevel&club=$club&nationality=$nationality&consistency=$consistency&playingStyle=${jsonEncode(playingStyle)}&technicalAttributes=${jsonEncode(technicalAttributes)}&secondaryPosition=${jsonEncode(secondaryPosition)}",
        "scouting/playerlist?limit=$limits&page=$page&search=$search&county=$county&position=$position&foot=$foot&minHeight=$minHeight&maxHeight=$maxHeight&minWeight=$minWeight&maxWeight=$maxWeight&club=$club&age=$age&country=$country&underContract=$underContract&availableForLoan=$availableForLoan&experienceLevel=$experienceLevel&nationality=$nationality&consistency=$consistency&playingStyle=${jsonEncode(playingStyle)}&technicalAttributes=${jsonEncode(technicalAttributes)}&secondaryPosition=${jsonEncode(secondaryPosition)}",

      );
    } else {
      return await apiService.getApiWithHeader(
       // "scouting/playerlist?limit=$limits&page=$page&search=$search&county=$county&position=$position&foot=$foot&minHeight=$minHeight&maxHeight=$maxHeight&club=$club&age=$age&country=$country&underContract=$underContract&availableForLoan=$availableForLoan&experienceLevel=$experienceLevel&nationality=$nationality&consistency=$consistency&club=$club",
        "scouting/playerlist?limit=$limits&page=$page&search=$search&county=$county&position=$position&foot=$foot&minHeight=$minHeight&maxHeight=$maxHeight&minWeight=$minWeight&maxWeight=$maxWeight&club=$club&age=$age&country=$country&underContract=$underContract&availableForLoan=$availableForLoan&experienceLevel=$experienceLevel&nationality=$nationality&consistency=$consistency&playingStyle=${jsonEncode(playingStyle)}&technicalAttributes=${jsonEncode(technicalAttributes)}&secondaryPosition=${jsonEncode(secondaryPosition)}",

      );
    }
  }


  fetchingRecentList() async{
    return await apiService.getApiWithHeader("scouting/recentPlayer");
  }

  pushRecentList(Map<String, String> mapData) async{
    return await apiService.postApiWithBody("scouting/recentPlayer",body: mapData);
  }


  Future<dynamic> putSaveItem(String id) async {
    return await apiService.putDataHeaders("scouting/savePlayer/$id", data: {});
  }

  addToCard(String id) async {
    return await apiService.putDataHeaders("scouting/addToCompare/$id", data: {});
  }

  double separateValue({required String value, int key = 0}) {
    final parts = value.split('-');
    return double.parse(parts[key].trim());
  }
}

class NationalityOption {
  final String value;
  final String en;
  final String ro;

  const NationalityOption({required this.value, required this.en, required this.ro});
}

class DemoModelCheckBox {
  String title;
  bool isSelect;

  DemoModelCheckBox({required this.title, required this.isSelect});
}
