import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../backend/model/play_video_detail.dart';
import '../../backend/model/video_comment_list_model.dart';
import 'play_video_screen_state.dart';

class PlayVideoScreenLogic extends GetxController {
  final PlayVideoScreenState state;
  PlayVideoScreenLogic({required this.state});

  late VideoPlayerController videoPlayerController;
  var showControls = true.obs;
  Timer? hideTimer;
  late String videoUrl;


  VideoCommentListModel videoCommentListModel = VideoCommentListModel();
  RxList<VideoCommentBody> commentList = <VideoCommentBody>[].obs;
  int commentLimit = 10;
  bool isLoadingMoreComments = false;
  bool hasMoreComments = true;


  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    videoUrl = args["videoUrl"] ?? "";
    currentVideoId = args["videoId"] ?? "";
    debugPrint("VIDEO USL>>${videoUrl}");
    videoPlayerController = VideoPlayerController.networkUrl(

        Uri.parse(videoUrl));

    videoPlayerController.initialize().then((_) {
      if (!isClosed) {
        videoPlayerController.play();   // autoplay
        update();
      }
    });
  }

  TextEditingController commentController = TextEditingController();
  bool sendingComment = false;
  String currentVideoId = "";
  String createdBy = "";

  // postCommentInVideo(BuildContext context,{required String message,required String videoId, required String createdById}) async{
  //   Map<String, dynamic> mapData = {
  //     "message": message,
  //     "video": videoId,
  //     "createdBy": createdById
  //   };
  //
  //   await state.postComment(mapData).then((value) {
  //     if (value != null && value.statusCode == 200) {
  //       Map<String, dynamic> myMap = Map<String, dynamic>.from(value.data);
  //       final addObject = VideoCommentBody.fromJson(myMap);
  //       commentList.insert(0, addObject);
  //       update();
  //     }
  //   });
  // }




  /// Toggle like/unlike for current video
  void toggleLike(String currentUserId) async {
    if (videoDetail.value?.data?.id == null) return;

    final videoId = videoDetail.value!.data!.id!;


    if (videoDetail.value!.data!.likes.contains(currentUserId)) {
      // Remove like locally
      videoDetail.value!.data!.likes.remove(currentUserId);
    } else {
      // Add like locally
      videoDetail.value!.data!.likes.add(currentUserId);
    }

    // Trigger UI update
    videoDetail.refresh();

    // Then call API in background
    final endpoint = '/videos/like/$videoId';
    try {
      final  result = await state.apiService.putApiWithoutBody(endpoint);
      final Map<String, dynamic> mapData = result?.data as Map<String, dynamic>? ?? {};

      if ((mapData['responseCode'] ?? 0) == 200) {
        final updatedData = mapData['data'] as Map<String, dynamic>?;
        if (updatedData != null) {
          final List<dynamic> updatedLikes = List<dynamic>.from(updatedData['likes'] ?? []);
          videoDetail.value!.data!.likes = updatedLikes;
          videoDetail.refresh();
        }
      }
    } catch (e) {
      print('Exception: $e');
    }
  }



  /// Check if current user liked the video
  bool isLiked(String currentUserId) {
    final likes = videoDetail.value?.data?.likes ?? [];
    return likes.contains(currentUserId);
  }

  /// Get like count
  int likeCount() {
    return videoDetail.value?.data?.likes.length ?? 0;
  }



  Future<void> postCommentInVideo({
    required String videoId,
    required String createdById,
  }) async {
    if (commentController.text.trim().isEmpty) return;

    sendingComment = true;
    update();

    final message = commentController.text.trim();

    Map<String, dynamic> mapData = {
      "message": message,
      "video": videoId,
      "createdBy": createdById,
    };
    try {
      final value = await state.postComment(mapData);
      if(kDebugMode){
        print("POST COMMENT>>${value}");
      }
      if (value != null && value.statusCode == 200) {
        final Map<String, dynamic> myMap =
        Map<String, dynamic>.from(value.data['data']); // 👈 correct level
        final addObject = VideoCommentBody.fromJson(myMap);
        print("ADD OBJECCT>>>${addObject}");
        commentList.add(addObject);  // ✅
        totalComments.value = commentList.length;
        update();
        commentController.clear();
      }
    } catch (e) {
      debugPrint("Post Comment Error: $e");
    }
    sendingComment = false;
    update();
  }







  void startHideTimer() {
    // Only hide controls if video is playing
    if (!videoPlayerController.value.isPlaying) return;

    hideTimer?.cancel();
    hideTimer = Timer(const Duration(seconds: 2), () {
      showControls.value = false;
      update();
    });
  }


  RxBool showTapIcon = false.obs;

  void togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }

    // Show overlay icon briefly
    showTapIcon.value = true;
    update();
    Future.delayed(const Duration(milliseconds: 500), () {
      showTapIcon.value = false;
      update();
    });
  }




  Rx<PlayVideoDetailModel?> videoDetail = Rx<PlayVideoDetailModel?>(null);

  int shareCount = 0;

  /// GET VIDEO DETAIL
  Future<void> getVideoDetail(String videoId) async {
    currentVideoId = videoId;
    update();
    try {
      final response = await state.apiService.getApiWithHeader(
        "videos/$videoId",
        showToast: true,
      );
      print("VID ID ${videoId}");

      if (response != null && response.statusCode == 200) {
        videoDetail.value = PlayVideoDetailModel.fromJson(response.data);

        shareCount = videoDetail.value?.data?.shares.length ?? 0;
        
        print("response.data--->${response.data}");
        print("videoDetail.data--->${videoDetail.value?.data}");

      }
    } catch (e) {
      print("Video Detail Error: $e");
    } finally {
    }
  }



  RxInt totalComments= 0.obs;
  // Get Comments
  Future<void> getVideoComments(String videoId) async {
    try {
      final response = await state.apiService.getApiWithHeader(
        "videos/$videoId/comments?limit=1000",
        showToast: true,
      );
      if (response != null && response.statusCode == 200) {
        final model = VideoCommentListModel.fromJson(response.data);
        totalComments.value= model.totalRecord??0;
        update();
        commentList.value = (model.data ?? []).reversed.toList();
      }
    } catch (e) {
      print("Video Detail Error: $e");
    } finally {
    }
  }



  void onUserInteraction() {
    showControls.value = true;
    update();
    startHideTimer();
  }

  @override
  void onClose() {
    hideTimer?.cancel();

    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    }
    videoPlayerController.dispose();
    super.onClose();
  }



  addShare(BuildContext context,String? id) async {
    await state.shareCount(id ?? "").then((value) {
      update();
      if (value != null && value.statusCode == 200) {
        shareCount++;
      }
      update();
    });
  }
}
