import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';
import '../../utils/utils.dart';

class UploadedVideoState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  UploadedVideoState({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  String getLanguage() {
    return sharedPreferencesManager.getString(AppString.currentLang) ?? '';
  }

  String getRole() {
    return sharedPreferencesManager.getString('selectedUserRole') ?? '';
  }

  String getoken() {
    return sharedPreferencesManager.getString(AppString.authToken) ?? '';
  }

  String getPlayerid() {
    return sharedPreferencesManager.getString(AppString.uid) ?? '';
  }

  getClubPlayers({int? limit, int? page, String? search}) async {
    final endpoint = await getPlayerListEndpoint();
    final searchQuery = search != null && search.isNotEmpty ? "&search=$search" : "";
    return await apiService.getApiWithHeader("$endpoint?limit=$limit&page=$page$searchQuery");
  }

   playerModule({int? page}) async {
    return await apiService.getApiWithHeader("videos/player/list?page=$page&limit=10");
  }
}
