import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class ChangePasswordState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;
  ChangePasswordState({required this.apiService, required this.sharedPreferencesManager});
}
