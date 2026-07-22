import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class MyTrialsState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
MyTrialsState({required this.apiService, required this.sharedPreferencesManager});
}
