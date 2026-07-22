import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class SubscriptionState {
SharedPreferencesManager sharedPreferencesManager;
ApiService apiService;

SubscriptionState({required this.apiService, required this.sharedPreferencesManager});
}
