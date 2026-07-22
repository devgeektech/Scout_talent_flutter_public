import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/view/player_trials/player_trial_detail.dart';
import 'package:scouttalent2/view/player_trials/player_trials_logic.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/trial_card.dart';

class PlayerTrialsPage extends StatefulWidget {
  const PlayerTrialsPage({super.key});

  @override
  State<PlayerTrialsPage> createState() => _PlayerTrialsPageState();
}

class _PlayerTrialsPageState extends State<PlayerTrialsPage> {
  final PlayerTrialsLogic logic = Get.find<PlayerTrialsLogic>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Call only ONCE
      if (logic.trialsList.isEmpty) {
        logic.currentPage = 1;
        logic.hasMoreData = true;

        logic.getAllTrialsApiPlayer(
          context,
          currentPage: logic.currentPage,
          limit: logic.limit,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: ThemeProvider.bgColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: ThemeProvider.whiteColor,
          ),
        ),
      ),
      backgroundColor: ThemeProvider.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CommonTextWidget(heading: "Trials", fontSize: 20,fontWeight: FontWeight.w500, color: Colors.white),
              ),
              SizedBox(height: 2.h,),
              /// 🔍 Search
              CustomTextField(
                onChanged: (value) {
                  logic.onSearchChanged(value, context);
                },
                textInputStyle: TextStyle(
                  color: ThemeProvider.hintText,
                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                  fontFamily: 'Montserrat',
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: ThemeProvider.textColor,
                  size: 23,
                ),
                // suffixIcon: InkWell(
                //     onTap: (){
                //       logic.searchText.value='';
                //     },
                //     child: Icon(Icons.clear)),
                hintText: "Search by  trail name or by club name".tr,
              ),

              SizedBox(height: 3.w),

              /// 📋 Trials List
              Expanded(
                child: Obx(() {
                  //
                  // if (logic.isLoading.value) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }

                  if (logic.trialsList.isEmpty) {
                    return const Center(
                      child: CommonTextWidget(
                        heading: 'No trials  found',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    );
                  }


                  return RefreshIndicator(
                    onRefresh: () => logic.smartRefresh(context),
                    child: ListView.builder(
                      controller: logic.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: logic.trialsList.length +
                          ((logic.trialsList.isNotEmpty && !logic.isSearching.value) ? 1 : 0),



                      itemBuilder: (context, index) {
                        // 🔄 Pagination Loader
                        if (logic.hasMoreData &&
                            !logic.isSearching.value &&
                            index == logic.trialsList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

// 🚫 No More Data Footer
                        // 🔄 Pagination Loader
                        if (logic.hasMoreData &&
                            !logic.isSearching.value &&
                            index == logic.trialsList.length &&
                            logic.trialsList.isNotEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

// 🚫 No More Data Footer
                        if (!logic.hasMoreData &&
                            !logic.isSearching.value &&
                            index == logic.trialsList.length &&
                            logic.trialsList.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(height: 1, width: 60, color: Colors.grey.withOpacity(0.3)),
                                const SizedBox(height: 16),
                                Icon(Icons.flag_circle_rounded,
                                    size: 42, color: Colors.grey.withOpacity(0.6)),
                                const SizedBox(height: 12),
                                const Text("You're all caught up!",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
                                const SizedBox(height: 4),
                                const Text("No more trials available",
                                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          );
                        }



                        final trial = logic.trialsList[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              final createdByUserid = trial.createdByUser?.id;
                              final userid = logic.state.getPlayerid();

                              Get.to(
                                    () => PlayerTrialDetailScreen(),
                                arguments: trial.id,
                              );

                            },
                            child: TrialCard(
                              logoUrl: trial.createdByUser?.avatar,
                              title: trial.name ?? "",
                              id: trial.id,
                              category: trial.category,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
