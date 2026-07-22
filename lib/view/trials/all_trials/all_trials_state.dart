import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class AllTrialsState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;
AllTrialsState({required this.sharedPreferencesManager, required this.apiService});
}
