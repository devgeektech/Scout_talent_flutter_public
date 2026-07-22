import 'package:flutter/material.dart';

class PaginationHelper {
  static void handleScroll({
    required ScrollController controller,
    required int currentPage,
    required int limit,
    required int totalCount,
    required bool isLoading,
    required Future<void> Function(int page) fetchData,
    required Function(int page, bool loading) onUpdateState,
  }) {
    const double threshold = 100.0;

    //debugPrint("📜 Scroll: ${controller.position.pixels} / ${controller.position.maxScrollExtent}");

    if (controller.position.pixels >= controller.position.maxScrollExtent - threshold) {
      //debugPrint("⬇️ Reached bottom threshold ($threshold px before end)");
      final bool hasMore = (currentPage * limit) < totalCount;
      debugPrint("🔍 Has more data? $hasMore ""(current: ${currentPage * limit}, total: $totalCount)");

      if (!isLoading && hasMore) {
        final nextPage = currentPage + 1;
        //debugPrint("📥 Loading Next Page: $nextPage");
        onUpdateState(nextPage, true);

        fetchData(nextPage).whenComplete(() {
          //debugPrint("✅ Completed loading page: $nextPage");
          onUpdateState(nextPage, false);
        });
      }
    }else{
      if (isLoading) {
        //debugPrint("⏳ Already loading... skipping request");
      } else {
        //debugPrint("🚫 No more data to load");
      }
    }
  }
}
