
// todo All Api's end points
const String login = "auth/login";
const String register = "auth/signup";
const String forgotPassword = "forget-password";
const String resetPassword = "reset-password";
const String changePassword = "user/profile/update";
const String groupList = "members/group-joined-lists";
const String updateProfile = "user/profile/update";
const String getProfile = "users/profile";
const String logout = "auth/logout";
const String delete = "auth/deleteAccount";
const String accountVerification = "auth/verifyAccountByOtp";
const String resendVerifyAccountOtp = "auth/resendVerifyAccountOtp";
const String changePass = "auth/changePassword";

//Subscriptions
const String getAllPlayerPlansUrl = "playerPlans/getAllPlayerPlans?page=1&limit=100";
const String getAllAgentPlansUrl = "agentPlans/getAllAgentPlans?page=1&limit=100";
const String getAllClubAcademyPlansUrl = "clubPlans/getAllClubPlans?page=1&limit=100";
const String getAllScoutPlansUrl = "scoutPlans/getAllScoutPlans?page=1&limit=100";
const String createPlayerSubscription = "player-payment/create-subscription";
const String createAgentSubscription = "agent-payment/create-subscription";
const String createClubAcademySubscription = "club-payment/create-subscription";
const String createScoutSubscription = "scout-payment/create-subscription";
const String playerSubscription = "player-subscriptions/user/";
const String agentSubscription = "agent-subscriptions/user/";
const String clubSubscription = "club-subscriptions/user/";
const String scoutSubscription = "scout-subscriptions/user/";


//Club Academy
const String addClubPlayer = "club-players";
const String clubPlayers = "club-players/list";
const String trialclubPlayerVideo = "trial/clubPlayerVideo";
const String PlayerDrillUploadVideo = "player-trial/uploadVideo";

//Trials
const String uploadedTrials = "trial/uploadedList";
const String playerTrialVideos = "trial/uploadedVideos";

//Rating
const String ratingPlayer = "scouting/playerRating";


//Agent APIs
const String addAgentPlayer = "agent-players";
const String agentPlayers = "agent-players/list";

//Notification
const String notifications = "notifications";

//Settings
const String contactUs = "contacts";
const String playerActivities = "settings/activities";

//Scout
const String scoutPlayer = "scout-players";

//player
const String playerProfile = "users/profile";
const String player = "player/";
