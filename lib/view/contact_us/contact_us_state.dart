import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';
import 'package:scouttalent2/utils/api_endpoint.dart';

class ContactUsState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;
  ContactUsState({required this.apiService, required this.sharedPreferencesManager});

  contactApi(dynamic body) async {
    return await apiService.postApiWithBody(contactUs,body: body);
  }

}

