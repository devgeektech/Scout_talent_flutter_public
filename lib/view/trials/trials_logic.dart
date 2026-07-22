import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouttalent2/backend/model/uploaded_trials_detail_model.dart';
import 'package:scouttalent2/view/trials/trials_state.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../backend/api/get_repo.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/CommonResponseCodeAndMessageModel.dart';
import '../../backend/model/add_club_player_video_model.dart';
import '../../backend/model/all_trials_model.dart';
import '../../backend/model/getClubPlayerList.dart';
import '../../backend/model/trial_detail_model.dart';
import '../../backend/model/uploadTrialModel.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import 'package:scouttalent2/backend/model/getClubPlayerList.dart' as player;

class TrialsLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final TrialsState state;

  TrialsLogic({required this.state});

  int selectedTab = 0; // 0 = Upcoming, 1 = Completed
  String searchQuery = "";
  final RxBool isTermsAccepted = false.obs;

  TabController? tabController;
  final ScrollController scrollController = ScrollController();

  // Image
  Rx<File?> profileImage = Rx<File?>(null);
  RxBool isMyTrialsLoading = false.obs;

  // Text Fields
  RxString trialName = "".obs;
  RxString description = "".obs;
  RxString videoPath = "".obs;
  RxString existingAvatar = "".obs; // <--- add this
  RxString selectedCategory = ''.obs;
  RxString selectedCategoryRo = ''.obs;

  final List<String> trialCategories = [
    'goalkeeper',
    'defender',
    'midfielder',
    // 'winger',
    // 'striker',
    'forward',
  ];

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxList<String> drillSkills = List<String>.filled(4, "").obs;

  // All trials model instance
  AllTrialsModel allTrialsModel = AllTrialsModel();
  AllTrialsModel myTrialModel = AllTrialsModel();
  int currentPage = 1;
  final int limit = 10;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  RxString existingVideo = "".obs; // for prefilled video in edit mode

  final ScrollController myScrollController = ScrollController();
  Timer? _searchDebounce;

  /// Selected player for dropdown
  var selectedPlayerId = ''.obs;
  var selectedPlayer = ''.obs;

  RxBool isSearching = false.obs;
  RxString searchText = ''.obs;
  RxString selectedLanguage = 'en'.obs;


  RxBool isExpanded = false.obs;

  void toggleReadMore() {
    isExpanded.toggle();
  }

  Future<void> smartRefresh(BuildContext context) async {
    currentPage = 1;
    hasMoreData = true;

    final response = await getAllTrialsApi(
      context,
      currentPage: 1,
      limit: limit,
    );

    final freshList = response?.data ?? [];

    if (freshList.isEmpty) return;

    final oldIds = trialsList.map((e) => e.id).toSet();
    final newItems = freshList.where((e) => !oldIds.contains(e.id)).toList();

    if (newItems.isNotEmpty) {
      trialsList.insertAll(0, newItems);
    }
  }

  void updateSelectedPlayer(ClubPlayers player) {
    selectedPlayerId.value = player.sId ?? '';

    if (kDebugMode) {
      print('PLAYER NAME: ${player.firstName} ${player.lastName}');
      print('PLAYER ID: ${player.sId}');
    }
  }

  void onSearchChanged(String value, BuildContext context) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = value.trim();

      searchText.value = query;
      isSearching.value = query.isNotEmpty;

      currentPage = 1;
      hasMoreData = true;
      // trialsList.clear();

      getAllTrialsApi(
        context,
        currentPage: currentPage,
        limit: limit,
        searchText: query,
      );
    });
  }

  void onSearchMyTrialsChanged(String value, BuildContext context) {
    // 🔁 Cancel previous timer
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      currentPage = 1;
      hasMoreData = true;
      myList.clear();

      getMyTrialsApi(
        context,
        currentPage: currentPage,
        limit: limit,
        searchText: value.trim(),
      );
    });
  }

  // Trials list
  RxList<AllTrialList> trialsList = <AllTrialList>[].obs;
  RxList<AllTrialList> myList = <AllTrialList>[].obs;
  final ImagePicker picker = ImagePicker();

  // Dummy trial list
  List<Map<String, dynamic>> allTrials = [
    {
      "title": "Football Trial - U18",
      "date": "25 Dec 2025",
      "status": "upcoming",
    },
    {
      "title": "Cricket Talent Hunt",
      "date": "20 Nov 2025",
      "status": "completed",
    },
    {
      "title": "Basketball Selection",
      "date": "10 Jan 2026",
      "status": "upcoming",
    },
  ];

  // Filter based on tab + search
  List<Map<String, dynamic>> get filteredTrials {
    return allTrials.where((trial) {
      bool byTab = selectedTab == 0
          ? trial["status"] == "upcoming"
          : trial["status"] == "completed";

      bool bySearch =
          searchQuery.isEmpty ||
          trial["title"].toLowerCase().contains(searchQuery.toLowerCase());

      return byTab && bySearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);

    // // 🔥 Delay API call until navigation is completed
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getAllTrialsApi(Get.context!, currentPage: currentPage, limit: limit);
    // });
    loadSavedCredentials();
    scrollController.addListener(scrollListener);
    myScrollController.addListener(myScrollListener);
  }

  @override
  void onClose() {
    // ✅ ALWAYS dispose
    scrollController.dispose();
    myScrollController.dispose();
    super.onClose();
  }


  Future<void> loadSavedCredentials() async {
    String? langCode = state.getLanguage();
    print("langCode====>$langCode");
    if (langCode.isNotEmpty) {
      selectedLanguage.value = langCode;
      Get.updateLocale(Locale(langCode));
    } else {
      selectedLanguage.value = 'en';
      Get.updateLocale(const Locale('en'));
    }
    update();
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore &&
        hasMoreData) {
      loadMore();
    }
  }

  void loadMore() async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    update();

    currentPage++;

    final response = await getAllTrialsApi(
      Get.context!,
      currentPage: currentPage,
      limit: limit,
    );

    if (response == null || response.data == null || response.data!.isEmpty) {
      hasMoreData = false; // no more pages
    }

    isLoadingMore = false;
    update();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 61)),
    );
    // ❌ Prevent start > end

    if (picked != null) {
      startDate.value = picked;
      if (endDate.value != null &&
          endDate.value!.isBefore(picked)) {
        endDate.value = null; // Clear invalid end date
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime(2000),
      // prevent picking before start date
      lastDate: DateTime.parse(startDate.value.toString()).add(const Duration(days: 90)),
    );

    if (picked != null) {
      endDate.value = picked;
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) profileImage.value = File(file.path);
  }


  //landscape check

  Future<void> pickVideo() async {
    Get.back();

    final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    final File videoFile = File(file.path);

    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();

    // ---------- LANDSCAPE CHECK ----------
    final Size size = controller.value.size;
    if (size.height > size.width) {
      await controller.dispose();
      errorToast("Only landscape videos are allowed");
      return;
    }

    // ---------- DURATION CHECK ----------
    final Duration duration = controller.value.duration;
    const Duration maxDuration = Duration(minutes: 10);

    if (duration > maxDuration) {
      await controller.dispose();
      errorToast("Video must be less than or equal to 10 minutes");
      return;
    }

    await controller.dispose();

    videoPath.value = file.path;
    existingVideo.value = '';
  }


/*  Future<void> pickVideo() async {
    Get.back(); // close dialog

    final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    // ---------- FILE SIZE CHECK ----------
    final File videoFile = File(file.path);
    final double sizeInMB = videoFile.lengthSync() / (1024 * 1024);

    if (sizeInMB > 500) {
      errorToast( "Video must be less than 500 MB");
      return;
    }

    // ---------- DURATION CHECK ----------
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    final int durationInSeconds = controller.value.duration.inSeconds;
    print("VIDEO DURATION ${durationInSeconds}");
    await controller.dispose();

    if (durationInSeconds < 58 || durationInSeconds > 300) {
      errorToast("Video must be between 3 to 5 minutes");
      return;
    }

    // ---------- LANDSCAPE CHECK ----------
    // final String landscapePath = await forceLandscape(file.path);
    //
    // videoPath.value = landscapePath;
    // existingVideo.value = '';
  }*/

  // Future<void> pickVideo() async {
  //   Get.back();
  //
  //   final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
  //   if (file == null) return;
  //
  //   // Reject portrait videos
  //   final bool isLandscape = await isLandscapeVideo(file.path);
  //
  //   print('isLandScape>>>${isLandscape}');
  //
  //   if (!isLandscape) {
  //     Get.snackbar("Invalid Video", "Please select only LANDSCAPE videos");
  //     return;
  //   }
  //
  //   // Continue upload...
  //   videoPath.value = file.path;
  //   existingVideo.value = '';
  // }

  // Future<void> pickVideo() async {
  //   Get.back(); // close dialog
  //
  //   final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
  //   if (file == null) return;
  //
  //   final File videoFile = File(file.path);
  //
  //   // 1️⃣ Check FILE SIZE (500 MB max)
  //   final int bytes = await videoFile.length();
  //   final double sizeInMB = bytes / (1024 * 1024);
  //
  //   if (sizeInMB > 500) {
  //     errorToast( "Video must be under 500 MB");
  //     return;
  //   }
  //
  //   // 2️⃣ Get VIDEO METADATA (duration + orientation)
  //   final controller = VideoPlayerController.file(videoFile);
  //   await controller.initialize();
  //
  //   final Duration duration = controller.value.duration;
  //   final int seconds = duration.inSeconds;
  //
  //   // 3️⃣ Check DURATION (3–5 min)
  //   if (seconds < 180 || seconds > 300) {
  //     errorToast("Video must be between 3 and 5 minutes");
  //     controller.dispose();
  //     return;
  //   }
  //
  //   final int width = controller.value.size.width.toInt();
  //   final int height = controller.value.size.height.toInt();
  //
  //   controller.dispose();
  //
  //   // 4️⃣ Check ORIENTATION
  //   if (height >= width) {
  //     errorToast( "Only landscape videos are allowed");
  //     return;
  //   }
  //
  //   // 5️⃣ Force Landscape (rotate if metadata is wrong)
  //   final String finalPath = await forceLandscape(file.path);
  //
  //   videoPath.value = finalPath;
  //   existingVideo.value = '';
  // }
  Future<void> captureVideo() async {
    Get.back();

    // 1️⃣ LOCK ORIENTATION TO LANDSCAPE
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);


    final XFile? file = await picker.pickVideo(source: ImageSource.camera);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (file == null) return;

    final File videoFile = File(file.path);

    // ---------- SIZE CHECK ----------
    // final double sizeInMB = videoFile.lengthSync() / (1024 * 1 024);
    // if (sizeInMB > 500) {
    //   errorToast("Video must be less than 500 MB");
    //   return;
    // }

    // ---------- DURATION CHECK ----------
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    final int duration = controller.value.duration.inSeconds;

    if (duration > 600) {
      // 10 minutes = 600 seconds
      errorToast("Video must be less than or equal to 10 minutes");
      return;
    }
    //

    // ---------- LANDSCAPE ENFORCEMENT ----------
    final Size size = controller.value.size;
    final bool isPortrait = size.height > size.width;

    if (isPortrait) {
      await controller.dispose();
      errorToast("Only landscape videos are allowed");
      return;
    }

    // ---------- CLEANUP ----------
    await controller.dispose();

    videoPath.value = file.path;
    existingVideo.value = '';
  }
  void updateTab(int index) {
    selectedTab = index;
    update();
  }

  void updateSearch(String value) {
    searchQuery = value;
    update();
  }

  Future<UploadTrialModel?> uploadTrial({
    required String videoFilePath,
    required String name,
    required String description,
    required String category,
    required String roCategory,
    required String startDate,
    required String endDate,
    required String drillOne,
    required String drillTwo,
    required String drillThree,
    required String drillFour,
  }) async {
    try {
      LoaderDialog.show(Get.context!);

      final token = state.getoken();
      final lang = state.getLanguage();

      final uri = Uri.parse('${Utils.baseUrl}trial');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({'Authorization': token, 'lang': lang});

      // 🔹 Form fields
      request.fields.addAll({
        'name': name,
        'description': description,
        'category': category,
        'roCategory': roCategory,
        'startDate': startDate,
        'endDate': endDate,
        'drillOne': drillOne,
        'drillTwo': drillTwo,
        'drillThree': drillThree,
        'drillFour': drillFour,
      });

      if (kDebugMode) {
        print("Request fields ${request.fields}");
      }

      // 🔹 File handling
      final file = File(videoFilePath);
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      /// 🔹 Correct MIME type for VIDEO
      final mimeType = _getVideoMimeType(extension);

      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          file.path,
          filename: fileName,
          contentType: mimeType,
        ),
      );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);
      myList.clear();
      trialsList.clear();
      final uploadModel = UploadTrialModel.fromJson(jsonResponse);

      LoaderDialog.hide(Get.context!);

      if (response.statusCode == 200) {
        successToast(uploadModel.responseMessage ?? '');


        Get.offNamed(AppRouter.trials);
        videoPath.value = '';
        isTermsAccepted.value = false;
        return uploadModel;
      } else {
        errorToast(uploadModel.responseMessage ?? 'Upload failed');
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(Get.context!);
      errorToast("Upload failed: $e");
      return null;
    }
  }

  http.MediaType _getVideoMimeType(String extension) {
    switch (extension) {
      case 'mp4':
        return http.MediaType('video', 'mp4');
      case 'mov':
        return http.MediaType('video', 'quicktime');
      case 'mkv':
        return http.MediaType('video', 'x-matroska');
      case 'webm':
        return http.MediaType('video', 'webm');
      default:
        return http.MediaType('video', 'mp4');
    }
  }

  Future<UploadTrialModel?> editTrial({
    required String trialId,
    String? videoFilePath, // 👈 optional
    required String name,
    required String category,
    required String roCategory,
    required String description,
    required String startDate,
    required String endDate,
    required String drillOne,
    required String drillTwo,
    required String drillThree,
    required String drillFour,
  }) async {
    try {
      /// 🔹 Show loader
      LoaderDialog.show(Get.context!);

      final token = state.getoken();
      final lang = state.getLanguage();

      var headers = {'lang': lang, 'Authorization': token};

      final uri = Uri.parse('${Utils.baseUrl}trial/$trialId');
      final request = http.MultipartRequest('PUT', uri);

      /// 🔹 Add headers
      request.headers.addAll(headers);

      /// 🔹 Add fields
      request.fields.addAll({
        'name': name,
        'description': description,
        'category': category,
        'roCategory': roCategory,
        'startDate': startDate,
        'endDate': endDate,
        'drillOne': drillOne,
        'drillTwo': drillTwo,
        'drillThree': drillThree,
        'drillFour': drillFour,
      });

      /// 🔹 Add video only if user selected new one
      if (videoFilePath != null && videoFilePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('video', videoFilePath),
        );
      }

      /// 🔹 Send request
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(respStr);

      final uploadModel = UploadTrialModel.fromJson(jsonResponse);

      /// 🔹 Hide loader
      LoaderDialog.hide(Get.context!);

      if (response.statusCode == 200) {
        successToast(uploadModel.responseMessage ?? "Trial updated");
        Get.offNamed(AppRouter.trials); // or Get.back()
        videoPath.value = '';
        myList.clear();
        trialsList.clear();
        return uploadModel;
      } else {
        errorToast(uploadModel.responseMessage ?? "Update failed");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(Get.context!);
      errorToast("Update failed: $e");
      return null;
    }
  }

  Future<AllTrialsModel?> getAllTrialsApi(
    BuildContext context, {
    int? currentPage,
    int? limit,
    String? searchText,
  }) async {
    try {
      // 🔹 Show loader only on first page
      if (currentPage == 1) {
        LoaderDialog.show(context);
      }

      await Future.delayed(const Duration(milliseconds: 50));

      final token = state.getoken();
      final lang = state.getLanguage();

      final endpoint =
          '${Utils.baseUrl}trial/list?limit=$limit&page=$currentPage&search=${searchText ?? ""}';

      final response = await getDataWithHeader(endpoint);

      print("ALl data with>>>$response");

      if (response != null) {
        dynamic data = response.data;

        // 🔹 Handle string JSON safely
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        allTrialsModel = AllTrialsModel.fromJson(data);

        if (allTrialsModel.responseCode == 200) {
          if (currentPage == 1) {
            trialsList.value = allTrialsModel.data ?? [];
          } else {
            trialsList.addAll(allTrialsModel.data ?? []);
          }

          update();

          if (currentPage == 1) {
            LoaderDialog.hide(context);
          }
        }

        return allTrialsModel;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching trials: $e");
      return null;
    }
  }

  // ---------------- MY TRIALS PAGINATION ----------------
  int myCurrentPage = 1;
  bool isMyLoadingMore = false;
  bool hasMyMoreData = true;

  void myScrollListener() {
    if (myScrollController.position.pixels >=
            myScrollController.position.maxScrollExtent - 100 &&
        !isMyLoadingMore &&
        hasMyMoreData) {
      loadMoreMyTrials();
    }
  }

  void loadMoreMyTrials() async {
    if (isMyLoadingMore || !hasMyMoreData) return;

    isMyLoadingMore = true;
    update();

    myCurrentPage++;

    final response = await getMyTrialsApi(
      Get.context!,
      currentPage: myCurrentPage,
      limit: limit,
    );

    if (response == null || response.data == null || response.data!.isEmpty) {
      hasMyMoreData = false;
    }

    isMyLoadingMore = false;
    update();
  }

  Future<AllTrialsModel?> getMyTrialsApi(
    BuildContext context, {
    required int currentPage,
    required int limit,
    String? searchText,
  }) async {
    try {
      // 🔥 Show loader ONLY on first page AND when list is empty
      if (currentPage == 1 && myList.isEmpty) {
        isMyTrialsLoading.value = true;
      }

      final id = state.getPlayerid();
      final endpoint =
          'trial/club/$id?limit=$limit&page=$currentPage&search=${searchText ?? ""}';

      final response = await getDataWithHeader(endpoint);

      if (response == null) {
        isMyTrialsLoading.value = false;
        return null;
      }

      myTrialModel = AllTrialsModel.fromJson(response.data);
      final newData = myTrialModel.data ?? [];

      if (currentPage == 1) {
        myList.assignAll(newData); // ✅ no flicker
      } else {
        myList.addAll(newData);
      }

      hasMyMoreData = newData.length == limit;

      isMyTrialsLoading.value = false;
      update();

      return myTrialModel;
    } catch (e) {
      isMyTrialsLoading.value = false;
      return null;
    }
  }

  Future<ResponseCodeAndMessageModel?> deleteTrial(String trialId) async {
    try {
      final endpoint = '${Utils.baseUrl}trial/$trialId';

      final response = await state.apiService.deleteApiWithoutBody(endpoint);

      if (response == null) {
        return null;
      }

      // If response.data is String, decode safely
      dynamic data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      final model = ResponseCodeAndMessageModel.fromJson(data);

      if (model.responseCode == 200) {
        getMyTrialsApi(Get.context!, currentPage: currentPage, limit: limit);
        successToast(model.responseMessage ?? "Trial deleted");
      } else {
        errorToast(model.responseMessage ?? "Delete failed");
      }

      return model;
    } catch (e) {
      debugPrint("Delete trial error: $e");
      errorToast("Something went wrong");
      return null;
    }
  }

  final Rx<TrialsDetailModel?> trailDetail = Rx<TrialsDetailModel?>(null);

  Future<TrialsDetailModel?> getTrialDetail(String id) async {
    BuildContext? context = Get.context; // 🔹 Safe context from GetX

    try {
      if (context != null) LoaderDialog.show(context);

      final playerId = state.getPlayerid();

      final url = "trial/byId/$id";

      final response = await state.apiService.getApiWithHeader(
        url,
        showToast: true,
      );

      if (context != null) LoaderDialog.hide(context);

      if (response == null) {
        debugPrint("No response received");
        return null;
      }

      int statusCode = response.statusCode ?? 0;
      dynamic data = response.data;

      // 🔹 SUCCESS (200–299)
      if (statusCode >= 200 && statusCode < 300) {
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (e) {
            debugPrint("JSON decode failed");
          }
        }

        final model = TrialsDetailModel.fromJson(data);
        // debugPrint("Trial by detail response>> ${model.data}");

        trailDetail.value = model;

        return model;
      }

      // 🔹 ERROR HANDLING
      if (statusCode == 400) debugPrint("400 Bad Request");
      if (statusCode == 401) debugPrint("401 Unauthorized");
      if (statusCode == 403) debugPrint("403 Forbidden");
      if (statusCode == 404) debugPrint("404 Not Found");
      if (statusCode >= 500) debugPrint("Server Error $statusCode");

      return null;
    } catch (e) {
      debugPrint("Error: $e");

      // 🔹 Always hide loader even if exception occurs
      if (context != null) LoaderDialog.hide(context);

      return null;
    }
  }

  /////   get academy players

  //Get players list api
  GetClubPlayersList getClubPlayersList = GetClubPlayersList();
  var playersList = <player.ClubPlayers>[].obs;

  Future<GetClubPlayersList?> getClubPlayersApi(
    BuildContext context, {
    int? currentPage,
    int? limit,
    String? searchText,
  }) async {
    try {
      if (currentPage == 1) {
        LoaderDialog.show(context);
      }
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getClubPlayers(
        page: currentPage,
        limit: limit,
        search: searchText,
      );
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        getClubPlayersList = GetClubPlayersList.fromJson(data);

        if (getClubPlayersList.responseCode == 200) {
          playersList.value = getClubPlayersList.data!;
          // if (currentPage == 1) {
          //   playersList.value = getClubPlayersList.data!;
          // } else {
          //   playersList.addAll(getClubPlayersList.data!);
          // }
          // totalCount = getClubPlayersList.totalRecord!;
          update();
          if (currentPage == 1) {
            LoaderDialog.hide(context);
          }
        }
        return getClubPlayersList;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching plans: $e");
      return null;
    }
  }

  Rxn<UploadedTrialDetailsModel> uploadedTrialDetailsModel =
      Rxn<UploadedTrialDetailsModel>();

  Future<UploadedTrialDetailsModel?> getUploadedTrialRes(
    String? trialId,
    String playerid,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final response = await state.getClubPlayersUploaded(
        playerId: playerid,
        trialId: trialId,
      );

      if (response != null) {
        dynamic data = response.data;

        // Decode JSON if needed
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        // Update the reactive variable correctly
        uploadedTrialDetailsModel.value = UploadedTrialDetailsModel.fromJson(
          data,
        );

        if (uploadedTrialDetailsModel.value?.responseCode == 200) {
          // successToast(uploadedTrialDetailsModel.value?.responseMessage ?? "");
        }

        return uploadedTrialDetailsModel.value;
      } else {
        errorToast(uploadedTrialDetailsModel.value?.responseMessage ?? "");
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching uploaded trial details: $e");
      return null;
    }
  }

  /// index → selected video
  /// 0 = drill one, 1 = drill two, etc.
  final RxMap<int, File> selectedDrillVideos = <int, File>{}.obs;

  /// upload API
  Future<void> uploadSelectedDrill({
    required String trialId,
    required String playerId,
    required BuildContext context,
    required int drillIndex,// pass context here
  }) async {
    if (selectedDrillVideos.isEmpty) {
      debugPrint("No videos selected");
      return;
    }

    try {
      // ✅ Show loader
      LoaderDialog.show(context);

      final response = await state.addClubPlayerDrillVideo(
        fields: {"trialId": trialId, "playerId": playerId},
        files: _buildMultipartFiles(),
      );

      if (response == null) {
        debugPrint("Upload failed: no response");
        errorToast("Upload failed. Please try again.");

        selectedDrillVideos.remove(drillIndex);

        return ;
      }


      /// Parse response safely
      final model = AddClubPlayerVideoModel.fromJson(response.data);
      print("The add club player videos model: $model");

      if (model.responseCode == 200) {
        successToast(model.responseMessage ?? "Video uploaded successfully");
        LoaderDialog.hide(context);

        // ✅ Clear local selection
        selectedDrillVideos.clear();

        // ✅ Refresh uploaded drills
        await getUploadedTrialRes(trialId, playerId);
      } else {
        LoaderDialog.hide(context);

        errorToast(model.responseMessage ?? "Upload failed");
        debugPrint("Upload failed: ${model.responseCode}");
      }
    } catch (e, st) {
      debugPrint("Upload error: $e");
      debugPrint(st.toString());
      errorToast("Something went wrong while uploading");
    } finally {
      // ✅ Hide loader
      LoaderDialog.hide(context);
    }
  }

  /// convert index → multipart format
  Map<String, File> _buildMultipartFiles() {
    final Map<String, File> files = {};

    selectedDrillVideos.forEach((index, file) {
      final key = _drillKeyFromIndex(index);
      files[key] = file; // ✅ correct backend key
    });

    return files;
  }

  String _drillKeyFromIndex(int index) {
    switch (index) {
      case 0:
        return "drillOneVideo";
      case 1:
        return "drillTwoVideo";
      case 2:
        return "drillThreeVideo";
      case 3:
        return "drillFourVideo";
      default:
        throw Exception("Invalid drill index: $index");
    }
  }
  String getRoTranslation(String key) {
    return Get.translations['ro_RO']?[key] ??
        Get.translations['ro']?[key] ??
        key;
  }
}
