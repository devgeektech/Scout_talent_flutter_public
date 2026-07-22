import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/string.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/play_video_screen/play_video_screen_logic.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class PlayVideoScreenPage extends StatefulWidget {
  const PlayVideoScreenPage({super.key});

  @override
  State<PlayVideoScreenPage> createState() => _PlayVideoScreenPageState();
}

class _PlayVideoScreenPageState extends State<PlayVideoScreenPage> {
  final controller = Get.find<PlayVideoScreenLogic>();

  final ScrollController commentScroll = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final videoId = Get.arguments['videoId'] ?? "";
      debugPrint("ID>>>>>$videoId");
      controller.currentVideoId = videoId;
      controller.getVideoDetail(videoId);
      controller.getVideoComments(videoId); // first page (10)
    });

  }


  // ---------------- COMMENT POPUP ----------------
  void openCommentsPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GetBuilder<PlayVideoScreenLogic>(
          builder: (logic) {
            final currentUserId = logic.state.sharedPreferencesManager.getString(AppString.uid);
            final isOwnVideo = logic.videoDetail.value?.data?.createdBy == currentUserId;
            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Color(0xff1E1E1E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 12),

                    /// Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Comments",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Divider(
                      color: Colors.white.withOpacity(0.08),
                      thickness: 1,
                      height: 1,
                    ),

                    /// Comments list
                    Expanded(
                      child: ListView.builder(
                        controller: commentScroll,   // 👈 attach scroll listener
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: logic.commentList.length +
                            (logic.isLoadingMoreComments ? 1 : 0),
                        itemBuilder: (_, i) {

                          // Loader at bottom
                          if (i == logic.commentList.length) {
                            return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final c = logic.commentList[i];

                          return Column(
                            children: [
                              if (i != 0)
                                Divider(
                                  color: Colors.white.withOpacity(0.08),
                                  thickness: 1,
                                  height: 1,
                                ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey.shade800,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: Utils.imageUrl + (c.creator?.avatar ?? ''),
                                            memCacheHeight: 120,
                                            memCacheWidth: 120,
                                            maxHeightDiskCache: 200,
                                            maxWidthDiskCache: 200,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) =>
                                            const Image(image: AssetImage('assets/images/dummyPerson.png'), fit: BoxFit.cover),
                                            errorWidget: (_, __, ___) =>
                                            const Image(image: AssetImage('assets/images/dummyPerson.png'), fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                c.creator?.firstName ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                c.createdAt != null
                                                    ? formatTimeforComments(c.createdAt!)
                                                    : '',
                                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(c.message ?? '', style: const TextStyle(color: Colors.white70)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    /// Input Bar
                    Container(
                      padding: EdgeInsets.only(left: 12, right: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 10, top: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xff2A2A2A),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade800,
                            child: ClipOval(
                              child: (logic.state.sharedPreferencesManager.getString('avatar') ?? '').isNotEmpty
                                  ? CachedNetworkImage(
                                imageUrl: Utils.imageUrl +
                                    logic.state.sharedPreferencesManager.getString('avatar')!,
                                memCacheHeight: 120,
                                memCacheWidth: 120,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                const Image(image: AssetImage('assets/images/dummyPerson.png')),
                              )
                                  : const Image(image: AssetImage('assets/images/dummyPerson.png')),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              readOnly: isOwnVideo ? true : false,
                              onTap: () {
                                if (isOwnVideo) {
                                  errorToast("You can’t comment on your own uploaded video.");
                                }
                              },
                              controller: logic.commentController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Write a comment...",
                                hintStyle: const TextStyle(color: Colors.grey ),
                                filled: true,
                                fillColor:  Colors.white ,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: logic.sendingComment
                                ? null
                                : () => logic.postCommentInVideo(
                                    videoId: logic.currentVideoId,
                                    createdById: currentUserId??""
                                    // createdById: logic.videoDetail.value?.data?.createdBy ?? "",
                                  ),
                            child: Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: logic.sendingComment || isOwnVideo ? Colors.grey : const Color(0xffFF7A00),
                                shape: BoxShape.circle,
                              ),
                              child: logic.sendingComment
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(strokeWidth: 2, color: ThemeProvider.primary),
                                    )
                                  : const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          final uid = controller.state.sharedPreferencesManager
              .getString(AppString.uid)!;

          Get.back(
            result: {
              "like": controller.isLiked(uid),
              "likeCount": controller.videoDetail.value?.data?.likes.length ?? 0,
              "commentCount": controller.totalComments.value,
              "shareCount": controller.shareCount, // ✅ ADD THIS

            },
          );

          return Future.value(false);
        },

      child: GetBuilder<PlayVideoScreenLogic>(
        builder: (logic) {
          final vp = logic.videoPlayerController;
          final detail = logic.videoDetail.value;
          final currentUserId = logic.state.sharedPreferencesManager.getString(AppString.uid);

          return Scaffold(
            backgroundColor: Colors.black,
            body: vp.value.isInitialized
                ? SafeArea(
                    child: Stack(
                      children: [
                        Center(
                          child: GestureDetector(
                              onTap: (){
                                controller.togglePlayPause();
                              },
                              child: AspectRatio(aspectRatio: vp.value.aspectRatio, child: VideoPlayer(vp))),
                        ),
                        Obx(() {
                          if (!controller.showTapIcon.value) return const SizedBox();
                          return Center(
                            child: Icon(
                              controller.videoPlayerController.value.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 80,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          );
                        }),
                        Positioned(
                          right: 16,
                          bottom: 20,
                          child: Column(
                            children: [
                              // Like button
                              Obx(() {
                                final isOwnVideo = logic.videoDetail.value?.data?.creator?.id == currentUserId;
                                return _action(
                                  logic.isLiked(currentUserId!) ? AssetPath.like : AssetPath.unLike,
                                  detail?.data?.likes.length ?? 0,
                                  () {
                                    if (isOwnVideo) {
                                      errorToast("You can’t like your own uploaded video.");
                                      return;
                                    }
                                    logic.toggleLike(currentUserId);
                                  },
                                );
                              }),
                              const SizedBox(height: 5),

                              // Comment button
                              _action(
                                AssetPath.comment,
                                logic.totalComments.value,
                                openCommentsPopup, // onTap for comments
                              ),
                              const SizedBox(height: 5),

                              // Share button
                              _action(AssetPath.share, logic.shareCount, () async {
                                final String? videoPath = detail?.data?.video;
                                if (videoPath == null || videoPath.isEmpty) {
                                  errorToast("Video link not available");
                                  return;
                                }
                                final String fullVideoUrl = Utils.videoUrl + videoPath;
                                final params = ShareParams(text: fullVideoUrl, subject: detail?.data?.description);

                                // bool resultIs = await shareToWhatsApp(fullVideoUrl);
                                final ShareResult result = await SharePlus.instance.share(params);
                                if (result.status == ShareResultStatus.success) {
                                  logic.addShare(context, detail!.data!.id);
                                }
                              }),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 40,
                          child: Row(
                            children: [
                              logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                                  ? CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: (detail?.data?.creator?.avatar ?? '').isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: Utils.imageUrl + detail!.data!.creator!.avatar!,
                                                memCacheHeight: 120,
                                                memCacheWidth: 120,
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) => Icon(Icons.person),
                                              )
                                            : CircleAvatar(backgroundImage: AssetImage('assets/images/dummyPerson.png')),
                                      ),
                                    )
                                  : CircleAvatar(
                                radius: 20,
                                child: ClipOval(
                                  child: (() {
                                    final studentAvatar = detail?.data?.student?.avatar;
                                    final creatorAvatar = detail?.data?.creator?.avatar;

                                    // 1️⃣ Show student avatar if exists
                                    if (studentAvatar != null && studentAvatar.isNotEmpty) {
                                      return CachedNetworkImage(
                                        imageUrl: Utils.imageUrl + studentAvatar,
                                        memCacheHeight: 120,
                                        memCacheWidth: 120,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.person),
                                      );
                                    }

                                    // 2️⃣ Show creator avatar if student avatar missing
                                    // if (creatorAvatar != null && creatorAvatar.isNotEmpty) {
                                    //   return CachedNetworkImage(
                                    //     imageUrl: Utils.imageUrl + creatorAvatar,
                                    //     memCacheHeight: 120,
                                    //     memCacheWidth: 120,
                                    //     fit: BoxFit.cover,
                                    //     errorWidget: (context, url, error) => const Icon(Icons.person),
                                    //   );
                                    // }

                                    // 3️⃣ Default asset image
                                    return const Image(
                                      image: AssetImage('assets/images/dummyPerson.png'),
                                      fit: BoxFit.cover,
                                    );
                                  })(), // immediately invoked function
                                ),
                              )
                              ,
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                                      ? Text(
                                          "${detail?.data?.creator?.firstName ?? ''} ${detail?.data?.creator?.lastName ?? ''} ",
                                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          "${detail?.data?.student?.firstName ?? detail?.data?.creator?.firstName } ${detail?.data?.student?.lastName ?? detail?.data?.creator?.lastName } "?? "",
                                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                        ),
                                   SizedBox(height: 2.h),
                                  logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.primary,
                                            // light background
                                            borderRadius: BorderRadius.circular(20),
                                            // fully rounded
                                            border: Border.all(color: Colors.orange, width: 1), // optional outline
                                          ),
                                          child: Text(
                                            detail?.data?.creator?.role?.capitalizeFirst ?? '',
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.primary,
                                            // light background
                                            borderRadius: BorderRadius.circular(20),
                                            // fully rounded
                                            border: Border.all(color: Colors.orange, width: 1), // optional outline
                                          ),
                                          child: Text(
                                            detail?.data?.student?.role?.capitalizeFirst ?? detail?.data?.creator?.role?.capitalizeFirst??"",
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator(color: ThemeProvider.primary)),
          );
        },
      ),
    );
  }

  Widget _action(String svgPath, int count, [VoidCallback? onTap]) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(
            svgPath,
            height: 28,
            width: 28,
            colorFilter: ColorFilter.mode(svgPath == AssetPath.like ? Colors.red : Colors.white, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 4),
        Text(count.toString(), style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}