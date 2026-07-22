import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';

class ChatInboxState {

  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  ChatInboxState({required this.sharedPreferencesManager, required this.apiService});



}
