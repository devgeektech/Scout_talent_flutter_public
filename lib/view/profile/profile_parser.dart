import 'package:shared_preferences/shared_preferences.dart';

import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class ProfileParser {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProfileParser({required this.sharedPreferencesManager, required this.apiService});



  String getUid() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }


  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? 'en';
  }

  getClubPlayers({int? limit, int? page, String? search}) async {
    final searchQuery = search != null && search.isNotEmpty
        ? "&search=$search"
        : "";
    return await apiService.getApiWithHeader(
      "$clubPlayers?limit=$limit&page=$page$searchQuery",
    );
  }


  // int limits = 10;

  Future<int> getCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("savedPlayerCount") ?? 0;
  }
  Future<dynamic> fetchingSavedPlayList(int page) async {
    final int savedCount = await getCount();
    final int limits = savedCount == 0 ? 10 : savedCount;



    return await apiService.getApiWithHeader(
      "scouting/savedPlayers?limit=$limits&page=$page",
    );
  }

  //Logout
  logoutApi() async {
    return await apiService.putApiWithoutBody(logout);
  }

  //Delete
  deleteAccount() async {
    return await apiService.deleteApiWithoutBody(delete);
  }
}
