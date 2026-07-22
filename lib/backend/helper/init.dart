import 'package:get/get.dart';
import 'package:scouttalent2/view/add_player_screen/add_player_screen_state.dart';
import 'package:scouttalent2/view/change_password/state.dart';
import 'package:scouttalent2/view/chat_screen/chat_screen_state.dart';
import 'package:scouttalent2/view/choose_your_account/choose_your_account_state.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_state.dart';
import 'package:scouttalent2/view/contact_us/contact_us_state.dart';
import 'package:scouttalent2/view/forgot_password/forgot_password_state.dart';
import 'package:scouttalent2/view/manage_videos/manage_videos_state.dart';
import 'package:scouttalent2/view/notifications/notifications_state.dart';
import 'package:scouttalent2/view/play_video_screen/play_video_screen_state.dart';
import 'package:scouttalent2/view/player_activity_page/player_activity_page_state.dart';
import 'package:scouttalent2/view/player_all_videos/player_all_videos_state.dart';
import 'package:scouttalent2/view/player_report/player_state.dart';
import 'package:scouttalent2/view/player_trials/player_trials_state.dart';
import 'package:scouttalent2/view/players_list/players_list_state.dart';
import 'package:scouttalent2/view/rate_player/rate_player_state.dart';
import 'package:scouttalent2/view/register/register_state.dart';
import 'package:scouttalent2/view/reset_password/reset_password_state.dart';
import 'package:scouttalent2/view/saved_players/saved_player_state.dart';
import 'package:scouttalent2/view/subscription/subscription_state.dart';
import 'package:scouttalent2/view/subscription_pricing/subscription_pricing_state.dart';
import 'package:scouttalent2/view/subscripton/subsciption_state.dart';
import 'package:scouttalent2/view/trial_player_detail/trial_player_detail_state.dart';
import 'package:scouttalent2/view/trials/all_trials/all_trials_state.dart';
import 'package:scouttalent2/view/trials/my_trials/my_trials_state.dart';
import 'package:scouttalent2/view/trials/trials_state.dart';
import 'package:scouttalent2/view/uploaded_trials/uploaded_trials_state.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_state.dart';
import 'package:scouttalent2/view/verification_screen/verification_screen_state.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utils.dart';
import '../../view/chat_inbox/chat_inbox_state.dart';
import '../../view/dashboard/dashboard_parser.dart';
import '../../view/home/home_parser.dart';
import '../../view/login/login_parser.dart';
import '../../view/profile/profile_parser.dart';
import '../../view/splash/splash_parser.dart';
import '../api/api.dart';
import 'shared_pref.dart';


class MainBinding extends Bindings {

  @override
  Future<void> dependencies() async {

    final sharedPref = await SharedPreferences.getInstance();
    Get.put(SharedPreferencesManager(sharedPreferences: sharedPref), permanent: true);

    Get.lazyPut(() => ApiService(appBaseUrl: Utils.baseUrl));

    Get.lazyPut(() => SplashParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LoginParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DashboardParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HomeScreenParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ProfileParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChooseYourAccountState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RegisterState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ForgotPasswordState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ResetPasswordState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SubscriptionState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SubscriptionPricingState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => VideosScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => UploadedVideoState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ManageVideosState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayVideoScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => TrialsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayersListState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => AddPlayerScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => VerificationScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChangePasswordState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SubscriptionSettingState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SavedPlayerState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => MyTrialsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => AllTrialsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ClubScoutSearchParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayerParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => UploadedTrialsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => TrialPlayerDetailState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RatePlayerState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayerTrialState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);


    Get.lazyPut(() => NotificationsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChatInboxState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ChatScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ContactUsState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayerActivityPageState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlayerAllVideosState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);

  }
}


