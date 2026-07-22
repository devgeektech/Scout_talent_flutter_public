// import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class LandscapeCameraPage extends StatefulWidget {
//   const LandscapeCameraPage({super.key});
//
//   @override
//   State<LandscapeCameraPage> createState() => _LandscapeCameraPageState();
// }
//
// class _LandscapeCameraPageState extends State<LandscapeCameraPage> {
//   CameraController? _controller;
//   Timer? _timer;
//   int _seconds = 0;
//   bool _recording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _lockLandscape();
//     _initCamera();
//   }
//
//   Future<void> _lockLandscape() async {
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }
//
//   Future<void> _restoreOrientation() async {
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//   }
//
//   Future<void> _initCamera() async {
//     List<CameraDescription> cameras = [];
//     try {
//       cameras = await availableCameras();
//     } catch (e) {
//       debugPrint("Camera init failed: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera initialization failed")),
//         );
//         Navigator.pop(context);
//       }
//       return;
//     }
//     final backCamera = cameras.firstWhere(
//           (c) => c.lensDirection == CameraLensDirection.back,
//     );
//
//     final controller = CameraController(
//       backCamera,
//       ResolutionPreset.high,
//       enableAudio: true,
//     );
//
//     await controller.initialize();
//
//     if (!mounted) {
//       controller.dispose();
//       return;
//     }
//
//     setState(() {
//       _controller = controller;
//     });
//   }
//
//   Future<void> _startRecording() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;
//
//     _seconds = 0;
//     _recording = true;
//
//     await _controller!.startVideoRecording();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _seconds++;
//       if (_seconds >= 600) _stopRecording(); // 10 min hard stop
//       setState(() {});
//     });
//   }
//
//   Future<void> _stopRecording() async {
//     if (_controller == null || !_controller!.value.isRecordingVideo) return;
//
//     _timer?.cancel();
//     _recording = false;
//
//     final XFile file = await _controller!.stopVideoRecording();
//     await _restoreOrientation();
//
//     if (mounted) Navigator.pop(context, file);
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller?.dispose();
//     _restoreOrientation();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           _buildCameraPreview(),
//
//           Positioned(
//             top: 20,
//             right: 20,
//             child: Text(
//               "${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}",
//               style: const TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ),
//
//           Positioned(
//             bottom: 30,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 backgroundColor: Colors.red,
//                 onPressed: _recording ? _stopRecording : _startRecording,
//                 child: Icon(_recording ? Icons.stop : Icons.videocam),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildCameraPreview() {
//     final size = MediaQuery.of(context).size;
//     final deviceRatio = size.width / size.height;
//
//     return Transform.scale(
//       scale: 16/9,
//       child: Center(
//         child: AspectRatio(
//           aspectRatio: _controller!.value.aspectRatio,
//           child: CameraPreview(_controller!),
//         ),
//       ),
//     );
//   }
//
// }
