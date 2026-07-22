import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend/model/ProfileResponseModel.dart';
import '../../backend/model/notification_model.dart';
import '../../backend/model/logo_model.dart';
import '../../backend/model/trending_videos_model.dart';
import '../../widget/commomLoader.dart';
import '../profile/update_profile.dart';
import 'home_parser.dart';


class HomeScreenController extends GetxController {
  final HomeScreenParser parser;

  HomeScreenController({required this.parser});

  bool trendingLoader = true;
  bool logosLoader = true;
  TrendingVideosModel tVideosModel = TrendingVideosModel();
  LogosModel logosModel = LogosModel();

  List<TrendingVideosBody> trendingList = [];
  List<String> logosList = [];
// Pagination state
  int currentPage = 1;
  final int pageLimit = 10;

  bool hasMore = true;
  bool loadingMore = false;
  bool _requestRunning = false;

  Future<void> getTrendingVideos(
      BuildContext context, {
        bool loadMore = false,
      }) async {

    print("\n========== getTrendingVideos START ==========");
    print("loadMore: $loadMore");
    print("_requestRunning: $_requestRunning");
    print("loadingMore: $loadingMore");
    print("hasMore: $hasMore");
    print("currentPage BEFORE: $currentPage");
    print("listSize BEFORE: ${trendingList.length}");

    // Prevent duplicate calls
    if (_requestRunning || loadingMore || (!hasMore && loadMore)) {
      print("🚫 BLOCKED — duplicate or no more pages");
      return;
    }

    _requestRunning = true;

    try {

      if (loadMore) {
        loadingMore = true;
        currentPage++;
        print("➡️ PAGINATION TRIGGERED");
      } else {
        trendingLoader = true;
        currentPage = 1;
        hasMore = true;
        trendingList.clear();
        print("🔄 FRESH LOAD — list cleared");
      }

      print("API CALL -> page=$currentPage limit=$pageLimit");

      update();

      final value =
      await parser.fetchingTrendingVideos(currentPage, pageLimit);

      trendingLoader = false;
      loadingMore = false;

      print("API STATUS: ${value?.statusCode}");

      if (value != null && value.statusCode == 200) {

        tVideosModel = TrendingVideosModel.fromJson(value.data);

        List<TrendingVideosBody> fetched =
            tVideosModel.data ?? [];

        print("API RETURNED COUNT: ${fetched.length}");

        // Detect last page
        if (fetched.length < pageLimit) {
          hasMore = false;
          print("🛑 LAST PAGE DETECTED");
        }

        trendingList.addAll(
          fetched.map((e) {
            e.likeTotalCount = e.shares.length;
            return e;
          }),
        );

        print("LIST SIZE AFTER ADD: ${trendingList.length}");
      }
      else {
        print("❌ API returned null or non-200");
      }

      update();

    } catch (e) {
      print("🔥 EXCEPTION: $e");
    } finally {
      _requestRunning = false;

      print("currentPage AFTER: $currentPage");
      print("hasMore AFTER: $hasMore");
      print("========== getTrendingVideos END ==========\n");
    }
  }



  getLogos(BuildContext context) async {
    await parser.fetchingLogos().then((value) {
      logosLoader = false;
      update();
      if (value != null && value.statusCode == 200) {
        logosList.clear();
        logosModel = LogosModel.fromJson(value.data);

        if (logosModel.data != null) {
          for (int i = 0; i < logosModel.data!.length; i++) {
            logosList.add(logosModel.data![i]);
          }
        }
      }
      update();
    });
  }
  RxInt unreadCount = 0.obs;
  NotificationResModel notificationResModel = NotificationResModel();
  Future<void> getNotificationList(BuildContext context) async {
    if (context.mounted) {
      LoaderDialog.show(context);
    }

    try {
      final response = await parser.fetchNotificationList(1, "all");

      if (response != null && response.statusCode == 200) {
        final myMap = Map<String, dynamic>.from(response.data);
        notificationResModel = NotificationResModel.fromJson(myMap);

        unreadCount.value = notificationResModel.data?.unreadCount ?? 0;
        update();

        if (kDebugMode) {
          print("unreadCount ----> ${unreadCount.value}");
        }
      } else {
        debugPrint('RESPONSE ERROR : $response');
      }
    } catch (e) {
      debugPrint('Notification API error: $e');
    } finally {
      if (context.mounted) {
        LoaderDialog.hide(context);
      }
    }
  }



  Future<ProfileResModel?> getUserProfile({required String userId}) async {
    String? currentLang = parser.getLanguage();

    // final String endpoint = "http://192.168.1.36:9000/api/v1/users/profile/${userId}";
    try {
      final response = await parser.apiService.getApiWithHeader(userId);

      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        // Parse into ProfileResModel
        final profile = ProfileResModel.fromJson(data);
        debugPrint("profile response>>${profile.data}");
        return profile;
      } else {
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }

  Future<void> loadProfileAndShowCompletion(BuildContext context) async {
    final profile = await getUserProfile(userId: "users/profile/${parser.getUid()}");

    if (profile == null || profile.data == null) return;

    final completion = profile.data!.profileCompletion ?? 0;

    if (completion < 70) {
      showProfileCompletionOnce(
        context: context,
        completion: completion.toInt(),
      );
    }
  }



  Future<void> showProfileCompletionOnce({
    required BuildContext context,
    required int completion,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // final alreadyShown =
    //     prefs.getBool('profile_completion_shown') ?? false;
    //
    // if (alreadyShown || completion >= 100) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          content: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enter all details to complete your profile.',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$completion% complete',
                              style: const TextStyle(
                                color: Color(0xFFFF6A00),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => UpdateProfile());
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Proceed',
                              style: TextStyle(
                                color: Color(0xFFFF6A00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_outward,
                              size: 16,
                              color: Color(0xFFFF6A00),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress bar
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  child: LinearProgressIndicator(
                    value: completion / 100,
                    minHeight: 4,
                    backgroundColor: ThemeProvider.primary,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6A00),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    await prefs.setBool('profile_completion_shown', true);
  }







}




