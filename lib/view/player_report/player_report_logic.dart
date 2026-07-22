import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scouttalent2/view/player_report/player_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/model/ProfileResponseModel.dart' hide Data;
import '../../backend/model/playerDetailResponse.dart';
import '../../utils/api_exception.dart';
import '../../utils/constants.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import 'package:http/http.dart' as http;

class PlayerReportController extends GetxController {
  final PlayerParser parser;
  PlayerReportController({required this.parser});

  RxList<Points> points = <Points>[].obs;
  RxString selectedLanguage = 'en'.obs;
  final features = [
    "Pass Accu".tr,
    "Duels Won".tr,
    "Pass Comp.".tr,
    "Shots On Target".tr,
    "Dribbles Comp.".tr
  ];
  final pentagonData = <List<int>>[];

  //Arguments
  String? playerId;
  String? type;
  TextEditingController emailController = TextEditingController();

  //Video player
  YoutubePlayerController? youtubePlayerController;

  //heatMap
  RxBool isEditingEnabled = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      playerId = args[0];
      type = args.length > 1 ? args[1] : false;
    } else {
      playerId = args;
      type = null;
    }

    print("playerId-->$playerId");
    print("type-->$type");

    Future.delayed(Duration.zero, () {
      loadSavedCredentials();
      getPlayerDetailApi(Get.context!,playerId: playerId);
    });
  }

  @override
  void dispose() {
    youtubePlayerController?.dispose();
    super.dispose();
  }

  // Method to mark check box
  void isEditingEnabledChecked(bool value) {
    isEditingEnabled.value = !isEditingEnabled.value;
  }

   double Wm = 105;
   double Hm = 68;

  void addPoint(Offset localPos, double width, double height) {
    // final xPercent = (localPos.dx / width) * 100;
    // final yPercent = (localPos.dy / height) * 100;
    final xPercent = (localPos.dx / width) * Wm;
    final yPercent = (localPos.dy / height) * Hm;
    final newPoint = Points(x: xPercent, y: yPercent , matchId: "last5");
    debugPrint("Point Added:");
    debugPrint("x: ${newPoint.x?.toStringAsFixed(2)}, y: ${newPoint.y?.toStringAsFixed(2)}");
    points.add(newPoint);

    // PRINT full list
    debugPrint("POINT LIST: $points");
  }

  void undoPoint() {
    if (points.isNotEmpty) {
        points.removeLast();
    }
  }

  Future<void> loadSavedCredentials() async {
    String? langCode = parser.getLanguage();
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

  void updateLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));
    await parser.saveLanguage(langCode);
    await parser.updateLang();
  }


  //Get Player Detail for edit
  GetPlayerDetailModal getPlayerDetailModal = GetPlayerDetailModal();
  Future<GetPlayerDetailModal?> getPlayerDetailApi(BuildContext context,{String? playerId}) async {
    try {
      LoaderDialog.show(context);
      await Future.delayed(Duration(milliseconds: 50));
      final role = await Utils().getUserType();

      final response = await parser.getPlayerDetailById(playerId: playerId);
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        //getPlayerDetailModal = GetPlayerDetailModal.fromJson(data);
        if (role == Constants.userRolePlayer) {
          final profileRes = ProfileResModel.fromJson(data);

          if (profileRes.responseCode == 200 && profileRes.data != null) {
            /// Convert ProfileData → Data (ONLY required fields)
            getPlayerDetailModal = GetPlayerDetailModal(
              code: profileRes.responseCode?.toInt(),
              message: profileRes.responseMessage,
              data: Data(
                sId: profileRes.data!.id,
                firstName: profileRes.data!.firstName,
                lastName: profileRes.data!.lastName,
                role: profileRes.data!.role,
                email: profileRes.data!.email,
                avatar: profileRes.data!.avatar,
                dob: profileRes.data!.dob?.toIso8601String(),
                playerAge: profileRes.data!.playerAge,
                nationality: profileRes.data!.nationality,
                roNationality: profileRes.data!.roNationality,
                weight: profileRes.data!.weight?.toInt(),
                height: profileRes.data?.playerHeight,
                playerLeg: profileRes.data!.playerLeg,
                playerPosition: profileRes.data!.playerPosition,
                roPlayerPosition: profileRes.data!.roPlayerPosition,
                youtubeLinks: List<String>.from(profileRes.data!.youtubeLinks),
                matchesPlayed: profileRes.data!.matchesPlayed?.toInt(),
                goals: profileRes.data!.goals?.toInt(),
                assists: profileRes.data!.assists?.toInt(),
                minutes: profileRes.data!.minutes?.toInt(),
                playingStyle: profileRes.data!.playingStyle,
                technicalAttributes: profileRes.data!.technicalAttributes,
                secondaryPosition: profileRes.data!.secondaryPosition,
                isBlocked: profileRes.data!.isBlocked,
                isVerified: profileRes.data!.isVerified,
                isFree: profileRes.data!.isFree,
                isDeleted: profileRes.data!.isDeleted,
                joinedAt: profileRes.data!.joinedAt?.toIso8601String(),
                createdAt: profileRes.data!.createdAt?.toIso8601String(),
                updatedAt: profileRes.data!.updatedAt?.toIso8601String(),
                heatmap: profileRes.data!.heatmap,
                playerVideos: profileRes.data!.playerVideos,
                career: profileRes.data!.career,
                trophies: profileRes.data!.trophies,
                caps: profileRes.data!.caps,
                callUps: profileRes.data!.callUps,
                transferStatus: profileRes.data!.transferStatus,
                club: profileRes.data!.currentClub,
                season: profileRes.data!.season,
                competitionLevel: profileRes.data!.competitionLevel,
                passAccuracy: profileRes.data!.passAccuracy,
                passCompletion: profileRes.data!.passCompletion,
                shotsOnTarget: profileRes.data!.shotsOnTarget,
                dribblesCompleted: profileRes.data!.dribblesCompleted,
                duelsWon: profileRes.data!.duelsWon,
                squadNumber: profileRes.data!.squadNumber,
                note: profileRes.data!.note,
                cv: profileRes.data!.cv,
                medicalCertificate: profileRes.data!.medicalCertificate,
                contractStart: profileRes.data!.contractStart.toString(),
                contractEnd: profileRes.data!.contractEnd.toString(),
                position: profileRes.data!.position,
                roPosition: profileRes.data!.roPosition,
                currentTeam: profileRes.data!.currentTeam,
                countryCode: profileRes.data!.countryCode,

              ),
            );
          }
        }

        /// 🔵 OTHER ROLES → Player Detail API
        else {
          getPlayerDetailModal = GetPlayerDetailModal.fromJson(data);
        }

        if(getPlayerDetailModal.code == 200){
          final playerData = getPlayerDetailModal.data; // main player detail object


          if (playerData == null) return null;

          int safeStat(dynamic value) {
            int parsedValue = 0;

            if (value == null) {
              parsedValue = 0;
            } else if (value is int) {
              parsedValue = value;
            } else if (value is String) {
              final trimmed = value.trim().toLowerCase();
              if (trimmed.isEmpty || trimmed == "null") {
                parsedValue = 0;
              } else {
                parsedValue = int.tryParse(trimmed) ?? 0;
              }
            }

            // ✅ Clamp between 0 and 100
            return parsedValue.clamp(0, 100);
          }

            // data in specific order for pentagon
          pentagonData.add([
            safeStat(playerData.passAccuracy),       // passAccuracy
            safeStat(playerData.duelsWon),           // duelsWon
            safeStat(playerData.passCompletion),     // passCompletion
            safeStat(playerData.shotsOnTarget),      // shotsOnTarget
            safeStat(playerData.dribblesCompleted),  // dribblesCompleted
          ]);


          final youtubeUrl = playerData.youtubeLinks?.isNotEmpty == true
              ? playerData.youtubeLinks!.first
              : null;

          if (youtubeUrl != null && youtubeUrl.isNotEmpty) {
            final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);

            if (videoId != null) {
              youtubePlayerController?.dispose(); // safety

              youtubePlayerController = YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                  enableCaption: false,
                ),
              );
            }
          }


          final heatmaps = playerData.heatmap;

          if (heatmaps != null && heatmaps.isNotEmpty) {
            points.value = List<Points>.from(heatmaps.first.points ?? []);
          }
          update();
          LoaderDialog.hide(context);
        }
        return getPlayerDetailModal;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching player details: $e");
      return null;
    }
  }

  Future<void> saveHeatmapApi() async {
    try {
      LoaderDialog.show(Get.context!);
      Map<String, Object> body = {
        "player_id": playerId??"",
        "scope": "last5",
        "points": points
      };

      if (kDebugMode) {
        print("body---->$body");
      }
      var response = await parser.saveHeatmap(body);
      print("response-->${response.statusCode}");
      if (response.statusCode == 200) {
        LoaderDialog.hide(Get.context!);
        Future.delayed(const Duration(milliseconds: 500), () {
          successToast(response.data["responseMessage"]);
        });
      } else {
        LoaderDialog.hide(Get.context!);
        errorToast(
          "Something went wrong",
        );
      }
    } catch (error) {
      LoaderDialog.hide(Get.context!);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }

  Future<void> sendProfileLinkApi() async {
    try {
      LoaderDialog.show(Get.context!);
      Map<String, Object> body = {
        "email": emailController.text,
        "playerId": playerId??"",
      };

      var response = await parser.sendProfileLink(body);
      if (response.statusCode == 200) {
        final message = response.data?['responseMessage'] ?? "Success";
        LoaderDialog.hide(Get.context!);
        Get.back();
        Future.delayed(Duration(seconds: 1),() {
          successToast(message ?? "Success");
        });
      } else {
        LoaderDialog.hide(Get.context!);
        errorToast(
          "Something went wrong",
        );
      }
    } catch (error) {
      LoaderDialog.hide(Get.context!);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }

  String valueOrNA(dynamic value) {
    if (value == null) return "N/A";
    if (value is String && value.trim().isEmpty) return "N/A";
    return value.toString();
  }

  //Download pdf from Url

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS
  }
  Future<File?> downloadPdf({
    required String url,
    required String fileName,
  }) async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) return null;

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final dio = Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint(
            'Download progress: ${(received / total * 100).toStringAsFixed(0)}%',
          );
        }
      },
    );

    return File(filePath);
  }


  Future<String> downloadPdff(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }


}
class TapPoint {
  final double x; // percentage (0–100)
  final double y; // percentage (0–100)

  TapPoint({required this.x, required this.y});

  @override
  String toString() {
    return "{ x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)} }";
  }
}
