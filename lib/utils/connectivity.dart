import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../main.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  var connectivityResult = ConnectivityResult.none.obs;

  late StreamSubscription<ConnectivityResult> _subscription;

  bool get isConnected => connectivityResult.value != ConnectivityResult.none;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();

    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnection);
    ever(connectivityResult, (ConnectivityResult result) {
      debugPrint("👂 Connectivity observer fired: $result");
      if (result != ConnectivityResult.none) {
        debugPrint("📶 Internet available → triggering FCM retry");
        setupFCMToken();
      }
    });
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnection(result);
  }

  void _updateConnection(ConnectivityResult result) {
    debugPrint("🌐 Connectivity changed → $result");
    connectivityResult.value = result;
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
