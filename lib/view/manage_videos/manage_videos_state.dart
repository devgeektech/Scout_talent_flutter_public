import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class ManageVideosState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
ManageVideosState({required this.sharedPreferencesManager, required this.apiService});

}
