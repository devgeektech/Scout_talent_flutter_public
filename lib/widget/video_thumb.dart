import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import '../utils/app_assets.dart';
import '../utils/utils.dart';

class VideoThumb extends StatefulWidget {
  final String videoUrl;
  final String thumbnail;
  final bool showPlayButton;
  final VoidCallback? onPlayTap;

  const VideoThumb({super.key, required this.videoUrl, required this.thumbnail, this.showPlayButton = true, this.onPlayTap});

  @override
  State<VideoThumb> createState() => _VideoThumbState();
}

class _VideoThumbState extends State<VideoThumb> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() async {
    _initialized = false;

    await _controller?.dispose();

    _controller = VideoPlayerController.network(widget.videoUrl);

    try {
      await _controller!.initialize();
      _controller!.pause(); // show only thumbnail frame

      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  @override
  void didUpdateWidget(covariant VideoThumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// 🎥 Video or shimmer
            widget.thumbnail.isNotEmpty
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      child: Image.network(
                        Utils.imageUrl1 + widget.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(AssetPath.latestTransfer, fit: BoxFit.cover),
                      ),
                    ),
                  )
                : _initialized && _controller != null
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(width: _controller!.value.size.width, height: _controller!.value.size.height, child: VideoPlayer(_controller!)),
                  )
                : _buildLoadingPlaceholder(),

            /// 🌑 Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
              ),
            ),

            /// ▶️ Center Play Button
            if (widget.showPlayButton)
              Center(
                child: GestureDetector(
                  onTap: widget.onPlayTap,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
