
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/theme.dart';
import '../widget/commontext.dart';

class WebViewOpen extends StatefulWidget {
  final String? titleName;
  final String webViewUrl;
  final bool appendLang; // 👈 optional bool

  const WebViewOpen({super.key,required this.webViewUrl,this.titleName,this.appendLang = true,});

  @override
  State<WebViewOpen> createState() => _WebViewOpenState();
}

class _WebViewOpenState extends State<WebViewOpen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    final String currentLang = Get.locale?.languageCode ?? 'en';
    final uri = widget.appendLang
        ? Uri.parse("${widget.webViewUrl}?lang=$currentLang")
        : Uri.parse(widget.webViewUrl);

    print("uri---->$uri");
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        leadingWidth: 10.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Back button action
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 2.h,
                  color: ThemeProvider.blackColor,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: CommonTextWidget(
          heading: widget.titleName ?? '',
          fontSize: 14.sp,
          color: ThemeProvider.whiteColor,
          fontFamily: "PassionOneBold",
          fontWeight: FontWeight.w400,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}