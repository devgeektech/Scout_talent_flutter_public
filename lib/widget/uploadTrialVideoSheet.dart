import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../utils/theme.dart';
import '../utils/toast.dart';
import '../utils/utils.dart';
import '../utils/webViewOpen.dart';
import 'commomLoader.dart';
import 'commontext.dart';
import '../../utils/app_assets.dart';

class UploadTrialVideoSheet extends StatefulWidget {
  final void Function(XFile? video) onSubmit; // Pass selected video on submit
  final VoidCallback onClose;
  String? title;
  String? submitButtonText;
  String? decriptionText;

  UploadTrialVideoSheet({
    super.key,
    this.title,
    this.submitButtonText,
    this.decriptionText,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<UploadTrialVideoSheet> createState() => _UploadTrialVideoSheetState();
}

class _UploadTrialVideoSheetState extends State<UploadTrialVideoSheet> {
  XFile? selectedVideo;

  /*  Future<void> _pickVideo(ImageSource source,) async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: source);

    if (video == null) return; // user cancelled
    // Force landscape
    final String landscapePath = await forceLandscape(video.path);
    setState(() {
      selectedVideo = XFile(landscapePath);
    });
    Navigator.pop(context);
  }*/

  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();

    if(source == ImageSource.camera){
      //Get.back();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    final XFile? video = await picker.pickVideo(source: source);
    if(source == ImageSource.camera){
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    if (video == null) return; // user cancelled

    LoaderDialog.show(context);

    final File videoFile = File(video.path);

    try {
      /*// ---------- FILE SIZE CHECK (ASYNC) ----------
      final int bytes = await videoFile.length();
      final double sizeInMB = bytes / (1024 * 1024);

      if (sizeInMB > 500) {
        errorToast("Video must be less than 500 MB");
        return;
      }*/

      // ---------- INIT CONTROLLER ----------
      final controller = VideoPlayerController.file(videoFile);

      try {
        await controller.initialize();

        // ---------- LANDSCAPE CHECK ----------
        final Size size = controller.value.size;
        if (size.height > size.width) {
          errorToast("Only landscape videos are allowed");
          return;
        }

        // ---------- DURATION CHECK ----------
        final int duration = controller.value.duration.inSeconds;

        if (duration > 600) {
          // 10 minutes = 600 seconds
          errorToast("Video must be less than or equal to 10 minutes");
          return;
        }
        // ---------- VALID VIDEO ----------
        setState(() {
          selectedVideo = video; // original video, no transform
        });

        Navigator.pop(context); // close bottom sheet
      } finally {
        await controller.dispose();
      }
    } finally {
      LoaderDialog.hide(context);
    }
  }

  void _showPickOptionsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "DISCLAIMER".tr,
              fontSize: Utils.responsiveFontSize(context, 15.sp),
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: "Montserrat",
            ),
            const SizedBox(height: 4),
            CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "Please ensure the video is in landscape mode and does not exceed 10 minutes in length.".tr,
              fontSize: Utils.responsiveFontSize(context, 15.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.blackColor,
              fontFamily: "Montserrat",
            ),

            const SizedBox(height: 6),

            // ───────── Gallery Option ─────────
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _pickVideo(ImageSource.gallery),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.video_library, color: Colors.orange),
                    const SizedBox(width: 12),
                    const CommonTextWidget(
                      heading: "Gallery",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ───────── Camera Option ─────────
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _pickVideo(ImageSource.camera),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.videocam, color: Colors.orange),
                    const SizedBox(width: 12),
                    const CommonTextWidget(
                      heading: "Upload New Video",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------- Header ----------
            // ---------- Header ----------
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: CommonTextWidget(
                    heading: widget.title ?? "Upload Trial Video",
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            // ---------- Upload Icon ----------
            GestureDetector(
              onTap: _showPickOptionsDialog,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,

                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    height: 100,
                    width: 100,
                    AssetPath.upload,
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            CommonTextWidget(
              heading: selectedVideo != null
                  ? "Video Selected: ${selectedVideo!.name}"
                  : "",
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            CommonTextWidget(
              heading:
                  widget.decriptionText ??
                  "Once you submit the video, it will be visible to the club/academy.",
              fontSize: 14,
              color: Colors.white70,
              lineHeight: 1.3,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: 1.h),

            UploadDisclaimer(),
            SizedBox(height: 2.h),

            // ---------- Submit Button ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSubmit(selectedVideo); // Pass video on submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: CommonTextWidget(
                  heading: widget.submitButtonText ?? "Submit",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class UploadDisclaimer extends StatelessWidget {
  const UploadDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12, // 🔥 SAME FONT SIZE EVERYWHERE
            height: 1.3,
          ),
          children: [
            TextSpan(text: 'By uploading, you agree to our'.tr),

            /// 🔸 Terms
            TextSpan(
              text: 'Terms & Conditions'.tr,
              style: const TextStyle(
                color: Colors.orange,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewOpen(webViewUrl: "https://scouttalentworld.com/terms-and-conditions")));
                },
            ),

            const TextSpan(text: ' and '),

            /// 🔸 Privacy
            TextSpan(
              text: 'Privacy Policy.'.tr,
              style: const TextStyle(
                color: Colors.orange,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewOpen(webViewUrl: "https://scouttalentworld.com/privacy-policy")));
                },
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
