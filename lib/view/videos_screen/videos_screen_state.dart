import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class VideosScreenState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;

VideosScreenState({required this.sharedPreferencesManager, required this.apiService});
}
