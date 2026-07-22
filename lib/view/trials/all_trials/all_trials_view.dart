import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../../widget/commontext.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/trial_card.dart';
import '../trials_detail.dart';
import '../trials_logic.dart';

class AllTrialsPage extends StatefulWidget {
  const AllTrialsPage({super.key});

  @override
  State<AllTrialsPage> createState() => _AllTrialsPageState();
}

class _AllTrialsPageState extends State<AllTrialsPage> {
  final TrialsLogic logic = Get.find<TrialsLogic>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Call only ONCE
      if (logic.trialsList.isEmpty) {
        logic.currentPage = 1;
        logic.hasMoreData = true;

        logic.getAllTrialsApi(
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
      backgroundColor: ThemeProvider.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

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
              hintText: "Search by  trail name or by club name".tr,
            ),

            SizedBox(height: 3.w),

            /// 📋 Trials List
            Expanded(
              child: Obx(() {
                if (logic.trialsList.isEmpty) {
                  return const Center(
                    child: CommonTextWidget(
                      heading: 'No trials found',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => logic.smartRefresh(context),
                  color: ThemeProvider.primary,
                  child: ListView.builder(
                    controller: logic.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: logic.trialsList.length +
                        ((logic.hasMoreData && !logic.isSearching.value)
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (!logic.isSearching.value &&
                          index == logic.trialsList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
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
                                  () => TrialTalentScreen(),
                              arguments: {
                                'id': trial.id,
                                'image': trial.createdByUser?.avatar,
                                'isMyTrial': createdByUserid == userid
                                    ? true
                                    : false
                              },
                            );
                          },
                          child: TrialCard(
                            createdByUser: '${trial.createdByUser!.club}',
                            logoUrl: trial.createdByUser?.avatar,
                            title: trial.name ?? "",
                            id: trial.id,
                            category: logic.selectedLanguage.value == 'en'
                                ? (trial.category ?? '')
                                : (trial.roCategory ?? '')
                            ,
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
    );
  }
}
