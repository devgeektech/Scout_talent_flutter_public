import 'package:get/get.dart';
import 'package:scouttalent2/view/add_player_screen/add_player_screen_binding.dart';
import 'package:scouttalent2/view/add_player_screen/add_player_screen_view.dart';
import 'package:scouttalent2/view/change_password/binding.dart';
import 'package:scouttalent2/view/change_password/view.dart';
import 'package:scouttalent2/view/chat_inbox/chat_inbox_view.dart';
import 'package:scouttalent2/view/chat_screen/chat_screen_view.dart';
import 'package:scouttalent2/view/choose_your_account/choose_your_account_binding.dart';
import 'package:scouttalent2/view/choose_your_account/choose_your_account_view.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_seach_page.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_search_binding.dart';
import 'package:scouttalent2/view/contact_us/contact_us_binding.dart';
import 'package:scouttalent2/view/contact_us/contact_us_view.dart';
import 'package:scouttalent2/view/forgot_password/forgot_password_binding.dart';
import 'package:scouttalent2/view/forgot_password/forgot_password_view.dart';
import 'package:scouttalent2/view/login/login_binding.dart';
import 'package:scouttalent2/view/manage_videos/manage_videos_binding.dart';
import 'package:scouttalent2/view/manage_videos/manage_videos_view.dart';
import 'package:scouttalent2/view/notifications/notifications_binding.dart';
import 'package:scouttalent2/view/play_video_screen/play_video_screen_binding.dart';
import 'package:scouttalent2/view/play_video_screen/play_video_screen_view.dart';
import 'package:scouttalent2/view/player_activity_page/player_activity_page_binding.dart';
import 'package:scouttalent2/view/player_activity_page/player_activity_page_view.dart';
import 'package:scouttalent2/view/player_all_videos/player_all_videos_binding.dart';
import 'package:scouttalent2/view/player_all_videos/player_all_videos_view.dart';
import 'package:scouttalent2/view/player_report/player_binding.dart';
import 'package:scouttalent2/view/player_report/player_report_page.dart';
import 'package:scouttalent2/view/player_trials/player_trials_binding.dart';
import 'package:scouttalent2/view/player_trials/player_trials_view.dart';
import 'package:scouttalent2/view/players_list/players_list_binding.dart';
import 'package:scouttalent2/view/players_list/players_list_view.dart';
import 'package:scouttalent2/view/rate_player/rate_player_binding.dart';
import 'package:scouttalent2/view/rate_player/rate_player_view.dart';
import 'package:scouttalent2/view/register/register_binding.dart';
import 'package:scouttalent2/view/register/register_view.dart';
import 'package:scouttalent2/view/reset_password/reset_password_binding.dart';
import 'package:scouttalent2/view/reset_password/reset_password_view.dart';
import 'package:scouttalent2/view/saved_players/saved_player_binding.dart';
import 'package:scouttalent2/view/saved_players/saved_player_page.dart';
import 'package:scouttalent2/view/splash/splash_binding.dart';
import 'package:scouttalent2/view/splash/splash_screen.dart';
import 'package:scouttalent2/view/subscription/subscription_binding.dart';
import 'package:scouttalent2/view/subscription/subscription_view.dart';
import 'package:scouttalent2/view/subscription_pricing/subscription_pricing_view.dart';
import 'package:scouttalent2/view/subscripton/subscription_setting_binding.dart';
import 'package:scouttalent2/view/subscripton/subscription_view.dart';
import 'package:scouttalent2/view/trial_player_detail/trial_player_detail_view.dart';
import 'package:scouttalent2/view/trials/all_trials/all_trials_binding.dart';
import 'package:scouttalent2/view/trials/all_trials/all_trials_view.dart';
import 'package:scouttalent2/view/trials/create_trials.dart';
import 'package:scouttalent2/view/trials/my_trials/my_trials_binding.dart';
import 'package:scouttalent2/view/trials/my_trials/my_trials_view.dart';
import 'package:scouttalent2/view/trials/trials_binding.dart';
import 'package:scouttalent2/view/trials/trials_view.dart';
import 'package:scouttalent2/view/uploaded_trials/uploaded_trials_binding.dart';
import 'package:scouttalent2/view/uploaded_trials/uploaded_trials_view.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_binding.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_page.dart';
import 'package:scouttalent2/view/verification_screen/verification_screen_binding.dart';
import 'package:scouttalent2/view/verification_screen/verification_screen_view.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_binding.dart';
import 'package:scouttalent2/view/videos_screen/videos_screen_view.dart';
import '../../view/chat_inbox/chat_inbox_binding.dart';
import '../../view/chat_screen/chat_screen_binding.dart';
import '../../view/dashboard/dashboard_binding.dart';
import '../../view/dashboard/dashboard_screen.dart';
import '../../view/login/login_screen.dart';
import '../../view/notifications/notifications_view.dart';
import '../../view/subscription_pricing/subscription_pricing_binding.dart';
import '../../view/trial_player_detail/trial_player_detail_binding.dart';


class AppRouter {

  static const String splash = '/splash_screen';
  static const String login = '/login_screen';
  static const String register = '/register';
  static const String forgot = '/forgot_password';
  static const String dashboard = '/dashboard_screen';
  static const String profile = '/profile_screen';
  static const String home = '/home_screen';
  static const String profileDetail = '/profile_detail_screen';
  static const String resetPassword = '/reset_password';
  static const String chooseYourAccount = '/choose_your_account_view';
  static const String subscriptionView = '/subscription_view';
  static const String subscriptionPricing = '/subscription_pricing';
  static const String videosScreen = '/videos_screen';
  static const String uploadedVideos = '/uploaded_video';
  static const String manageVideosView = '/manage_videos_view';
  static const String playVideosScreen = '/play_video_screen';
  static const String trials = '/trials';
  static const String playerSearchPage = '/player_search';
  static const String addPlayerScreen = '/add_player_screen';
  static const String verificationScreen = '/verification_screen';
  static const String changePassword = '/changePassword';
  static const String subScriptionSetting = '/subScriptionSetting';
  static const String comparePlayers = '/comparePlayers';
  static const String savedPlayer = '/savedPlayer';
  static const String allTrials = '/all_trials';
  static const String myTrials = '/my_trials';
  static const String createTrials = '/createTrials';
  static const String clubScoutSearch = '/clubScoutSearch';
  static const String playerReport = '/playerReport';
  static const String uploadedTrials = '/uploadedTrials';
  static const String trialPlayerDetail = '/trialPlayerDetail';
  static const String ratePlayer = '/ratePlayer';
  static const String playerTrial = '/playerTrial';

  static const String clubScoutPlayer = '/clubScoutPlayer';
  static const String notificationsPage = '/notificationsPage';
  static const String chatInboxPage = '/chatInboxPage';
  static const String chatScreenPage = '/chatScreenPage';
  static const String contactUs = '/contactUs';
  static const String playerActivityPage = '/playerActivityPage';
  static const String playerAllVideosPage = '/playerAllVideosPage';



  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getRegisterRoute() => register;
  static String getForgotPasswordRoute() => forgot;
  static String getDashboardRoute() => dashboard;
  static String getHomeRoute() => home;
  static String getProfileRoute() => profile;
  static String getProfileDetailRoute() => profileDetail;
  static String getResetPasswordRoute() => resetPassword;
  static String getChooseYourAccount() => chooseYourAccount;
  static String getSubscriptionViewRoute() => subscriptionView;
  static String getSubscriptionPricingRoute() => subscriptionPricing;
  static String getTrialsRoute() => trials;
  static String getVideosScreenRoute() => videosScreen;
  static String getUploadedVideosRoute() => uploadedVideos;
  static String getManageVideosViewRoute() => manageVideosView;
  static String getPlayVideosScreenRoute() => playVideosScreen;
  static String getPlayerSearchPageRoute() => playerSearchPage;
  static String getAddPlayerScreenRoute() => addPlayerScreen;
  static String getVerificationScreenRoute() => verificationScreen;
  static String getChangePassRoute() => changePassword;
  static String getSubScriptionSettingRoute() => subScriptionSetting;
  static String getSavedPlayer() => savedPlayer;
  static String getPlayerReport() => playerReport;
  static String getAllPlayer() => allTrials;
  static String getMyPlayer() => myTrials;
  static String getUploadedTrials() => uploadedTrials;
  static String getTrialPLayerDetailTrials() => trialPlayerDetail;
  static String getRatingPlayerPage() => ratePlayer;
  static String getPlayersTrial() => playerTrial;

  static String getClubScoutPlayer() => clubScoutPlayer;
  static String getNotificationsPage() => notificationsPage;
  static String getChatInboxPage() => chatInboxPage;
  static String getChatScreenPage() => chatScreenPage;
  static String getContactUs() => contactUs;
  static String getPlayerActivityPage() => playerActivityPage;
  static String getPlayerAllVideosPage() => playerAllVideosPage;



  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen(), binding: SplashBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: login, page: () => const LoginScreen(), binding: LoginBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: dashboard, page: () => const DashboardScreen(), binding: DashboardBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: chooseYourAccount, page: () => const ChooseYourAccountPage(), binding: ChooseYourAccountBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: register, page: () => const RegisterPage(), binding: RegisterBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: forgot, page: () => const ForgotPasswordPage(), binding: ForgotPasswordBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: resetPassword, page: () => const ResetPasswordPage(), binding: ResetPasswordBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: subscriptionView, page: () => const SubscriptionPage(), binding: SubscriptionBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: subscriptionPricing, page: () => const SubscriptionPricingPage(), binding: SubscriptionPricingBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: trials, page: () => const TrialsScreen(), binding: TrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: createTrials, page: () =>  CreateTrialScreen(), binding: TrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: uploadedVideos, page: () => const UploadedVideoPage(), binding: UploadedVideoBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: videosScreen, page: () => const VideosScreenPage(), binding: VideosScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: manageVideosView, page: () => const ManageVideosPage(), binding: ManageVideosBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playVideosScreen, page: () => const PlayVideoScreenPage(), binding: PlayVideoScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playerSearchPage, page: () => const PlayersListPage(), binding: PlayersListBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: addPlayerScreen, page: () => const AddPlayerScreenPage(), binding: AddPlayerScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: verificationScreen, page: () => const VerificationScreenPage(), binding: VerificationScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: changePassword, page: () => const ChangePasswordPage(), binding: ChangePasswordBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: subScriptionSetting, page: () => const SubscriptionSettingPage(), binding: SubscriptionSettingBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: savedPlayer, page: () =>  SavedPlayersPage(), binding: SavedPlayersBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: clubScoutSearch, page: () =>  ClubScoutSearchPage(), binding: ClubScoutSearchBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playerReport, page: () =>  PlayerReportPage(), binding: PlayerReportBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: allTrials, page: () =>  AllTrialsPage(), binding: AllTrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: myTrials, page: () =>  MyTrialsPage(), binding: MyTrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: uploadedTrials, page: () =>  UploadedTrialsPage(), binding: UploadedTrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: trialPlayerDetail, page: () =>  TrialPlayerDetailPage(), binding: TrialPlayerDetailBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: ratePlayer, page: () =>  RatePlayerPage(), binding: RatePlayerBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playerTrial, page: () =>  PlayerTrialsPage(), binding: PlayerTrialsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playerAllVideosPage, page: () =>  PlayerAllVideosPage(), binding: PlayerAllVideosBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),


    GetPage(name: notificationsPage, page: () =>  NotificationsPage(), binding: NotificationsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: chatInboxPage, page: () =>  ChatInboxPage(), binding: ChatInboxBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: chatScreenPage, page: () =>  ChatScreenPage(), binding: ChatScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: contactUs, page: () =>  ContactUsView(), binding: ContactUsBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: playerActivityPage, page: () =>  PlayerActivityPage(), binding: PlayerActivityPageBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
  ];
}
