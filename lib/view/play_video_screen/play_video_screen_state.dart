import 'package:scouttalent2/backend/api/api.dart';
import 'package:scouttalent2/backend/helper/shared_pref.dart';

class PlayVideoScreenState {
  SharedPreferencesManager sharedPreferencesManager;
  ApiService apiService;

  PlayVideoScreenState({required this.sharedPreferencesManager, required this.apiService});

  postComment(Map<String, dynamic> body) async {
    return await apiService.postApiWithBody("videos/comment", body: body);
  }

  shareCount(String id) async{
    return await apiService.putApiWithoutBody("videos/share/$id");
  }
}
