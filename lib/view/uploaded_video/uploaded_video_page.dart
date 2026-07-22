import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/backend/model/player_module_model.dart';
import 'package:scouttalent2/backend/model/uploaded_video_listing_model.dart';
import 'package:scouttalent2/utils/theme.dart';
import 'package:scouttalent2/utils/toast.dart';
import 'package:scouttalent2/view/uploaded_video/uploaded_video_logic.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../utils/app_assets.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commonDialog.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/editDetailsBottomSheet.dart';
import '../../widget/uploadTrialVideoSheet.dart';

class UploadedVideoPage extends StatefulWidget {
  const UploadedVideoPage({super.key});

  @override
  State<UploadedVideoPage> createState() => _UploadedVideoPageState();
}

class _UploadedVideoPageState extends State<UploadedVideoPage> {
  final UploadedVideoLogic uploadedVideoLogic = Get.put(UploadedVideoLogic(state: Get.find()));

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uploadedVideoLogic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer) {
        uploadedVideoLogic.getPlayerModuleList(context, currentPage: 1);
        // uploadedVideoLogic.getAllVideos();

      } else {
        uploadedVideoLogic.getClubPlayersApi(currentPage: 1, limit: 50);
        uploadedVideoLogic.getAllVideos();

      }

      // uploadedVideoLogic.getAllVideos();
      uploadedVideoLogic.scrollController.addListener(uploadedVideoLogic.onScroll);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadedVideoLogic>(
      init: uploadedVideoLogic,
      builder: (logic) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                ?SizedBox.shrink()
                :Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: uploadedVideoLogic.searchController,
                    textInputStyle: TextStyle(
                      color: ThemeProvider.hintText,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: Icon(Icons.search_outlined, color: ThemeProvider.textColor, size: 30),
                    maxLines: 1,
                    hintText: "Search by player name or position".tr,
                    onChanged: (value) {
                      uploadedVideoLogic.onSearchChanged(value);
                    },
                  ),
                ),

                logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                    ?SizedBox.shrink()
                    :SizedBox(height: 2.h),

                logic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                    ? Expanded(child: cardComponent())
                    : Expanded(
                        child: Obx(() {
                          final model = uploadedVideoLogic.videosListRes.value;

                          if (model == null) {
                            return Center(
                              child: CommonTextWidget(heading: 'No video available.', fontSize: 16, color: Colors.white),
                            );
                          }

                          // 🔹 Empty list
                          if (model.data == null || model.data!.isEmpty) {
                            return Center(
                              child: CommonTextWidget(heading: 'No video available.', fontSize: 16, color: Colors.white),
                            );
                          }

                          final list = model.data!;
                          return GridView.builder(
                            controller: uploadedVideoLogic.scrollController,
                            itemCount: list.length + (uploadedVideoLogic.isLoadingMore ? 1 : 0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              final video = list[index];

                              if (index == list.length) {
                                return const Center(
                                  child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
                                );
                              }

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRouter.playVideosScreen,
                                    arguments: {
                                      "videoId": video.id,
                                      "videoUrl": "${Utils.videoUrl}${video.video}",
                                    },
                                  );
                                  //Get.toNamed(AppRouter.playVideosScreen, arguments: "${Utils.videoUrl}${video.video}");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: _VideoThumbnailItem(
                                    key: ValueKey(video.id),
                                    videoData: video,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),

                SizedBox(height: 2.h),

                Button(
                  onPressed: () async {
                    if (uploadedVideoLogic.playersList.isEmpty &&
                        logic.state.sharedPreferencesManager.getString('selectedUserRole') != Constants.userRolePlayer) {
                      errorToast('You need to add a player before submitting a video.');
                      return;
                    }

                    final video = await showModalBottomSheet<XFile?>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => UploadTrialVideoSheet(
                        decriptionText: "Your Video will be private until you publish them.",
                        title: "Upload New Video",
                        submitButtonText: "Next",
                        onSubmit: (selectedVideo) {
                          if (selectedVideo != null) {
                            debugPrint("Video path: ${selectedVideo.path}");

                            openEditBottomSheet(
                              videoPath: selectedVideo.path,
                              context: context,
                              logic: uploadedVideoLogic,
                              sheetTitle: "Enter Details",
                              buttonText: "Submit",
                              showDescription: true,
                              dropdownItems: uploadedVideoLogic.playersList,
                              privacyOptions: ["Public", "Private"],
                              onSubmit: (result) async {
                                Navigator.of(context, rootNavigator: true).pop();
                                await Future.delayed(const Duration(milliseconds: 60));
                                LoaderDialog.show(context);
                                try {
                                  File file = File(selectedVideo.path);
                                  // File copiedFile = await VideoStreamCopy.copy(file);
                                  // debugPrint('Copied: ${copiedFile.path}');
                                  // debugPrint('Size: ${copiedFile.lengthSync()}');


                                  debugPrint('Original: ${file.path}');
                                  File? compressFile = await compressVideo(file);
                                  File fileToUpload = compressFile ?? file;

                                  final uploadResponse = await uploadedVideoLogic.uploadVideo(videoFilePath: fileToUpload.path);
                                  if (uploadResponse != null && uploadResponse.responseCode == 200) {
                                    uploadedVideoLogic.state.sharedPreferencesManager.getString('selectedUserRole') == Constants.userRolePlayer
                                        ? await uploadedVideoLogic.getPlayerModuleList(context, currentPage: 1)
                                        : await uploadedVideoLogic.getAllVideos();

                                    await showCommonDialog(
                                      showCloseButton: true,
                                      context: context,
                                      title: "Successfully Uploaded!",
                                      message: "Your video has been uploaded and is now available in your library.",
                                      svgAsset: AssetPath.successFilled,
                                    );
                                    LoaderDialog.hide(context);
                                  } else {
                                    LoaderDialog.hide(context);
                                  }

                                } catch (e) {
                                  LoaderDialog.hide(context);
                                  Get.snackbar("Error", e.toString());
                                }
                              },
                            );
                          } else {
                            errorToast("Please Select Video to Proceed");
                          }
                          // Navigator.pop(context, selectedVideo);
                        },
                        onClose: () => Navigator.pop(context),
                      ),
                    );

                    if (video != null) {
                      // Video returned from bottom sheet
                      debugPrint("Picked video: ${video.path}");
                    }
                  },

                  title: "Upload New Video".tr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  cardComponent() {
    return Obx(() {
      final model = uploadedVideoLogic.playerListModule;

      if (model.isEmpty) {
        return Center(
          child: CommonTextWidget(heading: 'No video available.', fontSize: 16, color: Colors.white),
        );
      }

      return GridView.builder(
        controller: uploadedVideoLogic.scrollController,
        itemCount: model.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRouter.playVideosScreen,
                arguments: {
                  "videoId": model[index].id,
                  "videoUrl": "${Utils.videoUrl}${model[index].video}",
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: VideoThumbnailItemModule(
                key: ValueKey(model[index].id),
                videoData: model[index],
                videoUrl: Utils.videoUrl + (model[index].video ?? ""),
              ),
            ),
          );
        },
      );
    });
  }
}






class _VideoThumbnailItem extends StatefulWidget {
  final Datum? videoData;

  const _VideoThumbnailItem({Key? key, this.videoData});

  @override
  State<_VideoThumbnailItem> createState() => _VideoThumbnailItemState();
}
class _VideoThumbnailItemState extends State<_VideoThumbnailItem> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video frame
           FittedBox(
                  fit: BoxFit.cover,
                  child: widget.videoData?.thumbnail != null
                      ? SizedBox(
                      child: Image.network(
                        Utils.imageUrl1 + widget.videoData!.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AssetPath.latestTransfer,
                          fit: BoxFit.cover,
                        ),
                      ))
                      : SizedBox(child: Image.asset(AssetPath.latestTransfer)),
                ),


          // Bottom gradient -- design
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
          ),

          // Player info pill with profile image
          if (widget.videoData != null)
    Positioned(
      left: 8,
      right: 8, // 🔥 THIS IS REQUIRED
      bottom: 8,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: widget.videoData!.avatar != null
                ? NetworkImage(Utils.imageUrl + widget.videoData!.avatar!)
                :  AssetImage(AssetPath.startScout),
          ),
          const SizedBox(width: 6),

          // 🔥 FORCE WIDTH
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  heading: widget.videoData!.playerName ?? "Unknown",
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  color: Colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.videoData!.role?.capitalizeFirst ?? "Player",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )

        ],
      ),
    );
  }
}





class VideoThumbnailItemModule extends StatefulWidget {
  final String videoUrl;
  final PlayerListModuleBody videoData;

  const VideoThumbnailItemModule({super.key, required this.videoUrl, required this.videoData});

  @override
  State<VideoThumbnailItemModule> createState() => _VideoThumbnailItemModuleState();
}
class _VideoThumbnailItemModuleState extends State<VideoThumbnailItemModule> {
  late VideoPlayerController _controller;

  @override
  void didUpdateWidget(covariant VideoThumbnailItemModule oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          _controller.pause();
          setState(() {});
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.pause(); // show first frame only
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video frame
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(width: _controller.value.size.width, height: _controller.value.size.height, child: VideoPlayer(_controller)),
                )
              : Container(color: Colors.black26),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
          ),

          // Player info pill with profile image
          Positioned(
            left: 50,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Likes
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetPath.unLike),
                    SizedBox(height: 4),
                    CommonTextWidget(
                      heading: widget.videoData.likes.length.toString(),
                      fontSize: 16,
                      color: Colors.white,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                SizedBox(width: 16), // horizontal spacing between items
                // Comments
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetPath.commentIcon),
                    SizedBox(height: 4),
                    CommonTextWidget(
                      heading: widget.videoData.comments.length.toString(),
                      fontSize: 16,
                      color: Colors.white,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                SizedBox(width: 16), // horizontal spacing between items
                // Shares
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetPath.sharePost),
                    SizedBox(height: 4),
                    CommonTextWidget(
                      heading: widget.videoData.shares.length.toString(),
                      fontSize: 16,
                      color: Colors.white,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
