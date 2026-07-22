import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/widget/common_back_button.dart';
import 'package:sizer/sizer.dart';
import '../../backend/helper/app_router.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import 'home_controller.dart';

class TrendingAllVideos extends StatefulWidget {
  const TrendingAllVideos({super.key});

  @override
  State<TrendingAllVideos> createState() => _TrendingAllVideosState();
}

class _TrendingAllVideosState extends State<TrendingAllVideos> {
  final logic = Get.put(HomeScreenController(parser: Get.find()));

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        logic.getTrendingVideos(context, loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ThemeProvider.bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: CommonBackButton(onTap: () => Navigator.pop(context)),
            title: CommonTextWidget(
              textAlign: TextAlign.center,
              heading: "Trending Videos".tr,
              fontSize: Utils.responsiveFontSize(context, 20.sp),
              fontWeight: FontWeight.w500,
              color: ThemeProvider.whiteColor,
              fontFamily: "Montserrat",
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.trendingList.isNotEmpty)
                Expanded(
                  child: RefreshIndicator(
                    color: ThemeProvider.primary,
                    onRefresh: () async {
                      await controller.getTrendingVideos(
                        context,
                      );
                    },

                    child: ListView.builder(
                      controller: _scrollController,

                      // ✅ IMPORTANT — add +1 when loading more
                      itemCount:
                          controller.trendingList.length +
                          (controller.loadingMore ? 1 : 0),

                      itemBuilder: (context, index) {


                        print("======${controller.trendingList.length}");
                        // ⭐ Bottom Loader / End Indicator
                        if (index == controller.trendingList.length) {

                          // No more data → show nothing
                          if (!controller.hasMore) {
                            return const SizedBox();
                          }

                          // Still loading more → show loader
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ThemeProvider.primary,
                              ),
                            ),
                          );
                        }

                        // ⭐ Normal List Item
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRouter.playVideosScreen,
                              arguments: {
                                "videoId": controller.trendingList[index].id,
                                "videoUrl":
                                "${Utils.videoUrl}${controller.trendingList[index].video}",
                              },
                            )?.then((value) async {
                             /* if (value == null) return;

                              final item = controller.trendingList[index];
                              item.isLikeBtn = value['like'];
                              controller.update();

                              final bool likeMismatch =
                                  item.isLikeBtn != value['like'] ||
                                      item.likeTotalCount != value['likeCount'];

                              final bool commentMismatch =
                                  item.comments != value['commentCount'];

                              final bool shareMismatch =
                                  item.shares != value['shareCount'];

                              if (likeMismatch ||
                                  commentMismatch ||
                                  shareMismatch) {
                                await controller.getTrendingVideos(
                                  context,
                                );
                              }

                              controller.update();*/
                              await logic.getTrendingVideos(context);
                              logic.update();
                            });
                          },
                          child: _trendingCard(index),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _trendingCard(int index) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.h, vertical: 3.w),
      child: Stack(
        children: [
          // Video frame
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: logic.trendingList[index].thumbnail != null
                ? SizedBox(
                    height: Get.size.height * 0.3,
                    child: CachedNetworkImage(
                      imageUrl:
                          Utils.imageUrl1 +
                          logic.trendingList[index].thumbnail!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Image.asset(
                        AssetPath.latestTransfer,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AssetPath.latestTransfer,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(
                    child: Image.asset(
                      AssetPath.latestTransfer,
                      height: Get.size.height * 0.2,
                    ),
                  ),
          ),

          // Bottom gradient -- design
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 45,
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Row(
                spacing: 8.w,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetPath.unLike,
                        height: 20,
                        color: logic.trendingList[index].isLikeBtn
                            ? ThemeProvider.redColor
                            : ThemeProvider.whiteColor,
                      ),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].likes.isNotEmpty)
                        CommonTextWidget(
                          heading: logic.trendingList[index].likes.length
                              .toString(),
                          fontSize: 16,
                          color: ThemeProvider.whiteColor,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetPath.commentIcon, height: 20),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].comments.isNotEmpty)
                        CommonTextWidget(
                          heading: logic.trendingList[index].comments.length
                              .toString(),
                          fontSize: 16,
                          color: Colors.white,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetPath.sharePost, height: 20),
                      SizedBox(height: 4),
                      if (logic.trendingList[index].likeTotalCount != 0)
                        CommonTextWidget(
                          heading: logic.trendingList[index].likeTotalCount
                              .toString(),
                          fontSize: 16,
                          color: Colors.white,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }
}
