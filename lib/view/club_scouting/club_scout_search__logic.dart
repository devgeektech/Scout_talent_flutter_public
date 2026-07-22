import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scouttalent2/utils/utils.dart';
import 'package:scouttalent2/view/club_scouting/club_scout_state.dart';
import 'package:sizer/sizer.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/get_player_list_model.dart';
import '../../backend/model/recent_list_model.dart';
import '../../main.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../widget/button.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commontext.dart';
import '../../widget/custom_text_field.dart';

class ClubScoutSearchLogic extends GetxController {
  final ClubScoutSearchParser parser;

  ClubScoutSearchLogic({required this.parser});

  bool isSelected = false;

  GetAllPlayerListModel getAllPLayerListModel = GetAllPlayerListModel();
  List<PlayerListBody> playerListBody = [];

  RecentListModel compareBody = RecentListModel();
  List<RecentListBody> recentlyPlayerList = [];


  List<PlayerListBody> searchingList = [];

  bool isLoading = true;

  int currentPage = 1;
  Timer? _debounce;

  final searchController = TextEditingController();

  RxBool showMorePlayers = false.obs;
  RxString? selectedFilter = "Position".obs;
  final RxString selectedPosition = "".obs;
  RxBool isPlayersExpanded = false.obs;
  RxBool showStats = true.obs;

  RxString playerType = "".obs;
  RxString playerFoot = "".obs;
  RxString experienceParam = "".obs;
  RxString videoType = "".obs;
  RxString contractStatus = "".obs;
  RxString availableForLoan = "".obs;
  RxString verificationStatus = "".obs;
  RxString primaryPosition = "".obs;
  RxString experienceLevel = "".obs;
  RxString acceleration = "".obs;
  RxString speed = "".obs;
  RxString strength = "".obs;
  RxString leaugeLevelPlayed = "".obs;
  RxString age = "".obs;
  RxString county = "".obs;
  RxString consistencyText = "".obs;
  RxString nationalityParam = "".obs;
  String heightParam = '';
  String weightParam = '';
  String clubParam = "";
  String positionParam = "";


  RxList<String> playingStyle = <String>[].obs;
  RxList<String> technicalAttribute = <String>[].obs;
  RxList<String> secondaryRole = <String>[].obs;

  RxInt isCardCount = 0.obs;
  RxInt isSavedCount = 0.obs;

  RxMap<String, String> appliedFilters = <String, String>{}.obs;

  savePlayerItem(BuildContext context, String id) async {
    final response = await parser.putSaveItem(id);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE SUCCESS : $myMap');
    }
  }

  bool onScrollingPage(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${getAllPLayerListModel.totalRecord.toString()}");

      int listItems = getAllPLayerListModel.totalRecord ?? -playerListBody.length;

      if (listItems > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          getPlayerList(getContext, page: currentPage);
        });
      } else {}
    }
    return false;
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      (searchController.text);
      currentPage = 1;
      getPlayerList(getContext, page: currentPage);
    });
  }

  void addToCompare(BuildContext context, String id, bool isAddToCard) async {
    await parser.addToCard(id).then((value) {
      if (value != null && value.statusCode == 200) {
        if (isAddToCard) {
          isCardCount.value += 1;
        } else {
          isCardCount.value -= 1;
        }
        update();
      }
    });
  }

  addToSaved(BuildContext context, String id, bool isAddToCard) async {
    await parser.putSaveItem(id).then((value) async {
      if (value != null && value.statusCode == 200) {
        if (isAddToCard) {
          isSavedCount.value += 1;
        } else {
          isSavedCount.value -= 1;
        }
        await parser.saveCount(isSavedCount.value);
        final count = await parser.getSavedCount();
        if (kDebugMode) {
          print("Saved Player Count: $count");
        }
        update();
      }
    });
  }

  final positions = [
    'Goalkeeper',
    'Right Back',
    'Left Back',
    'Center Back',
    'Defensive Midfield',
    'Right Wing/Forward',
    'Central Midfield',
    'Striker',
    'Attacking Midfield',
    'Left Wing/Forward',
    'Right Midfielder',
    'Left Midfielder',
  ];

  void togglePlayerList() {
    showMorePlayers.value = !showMorePlayers.value;
  }

  chooseFilter(String filter) {
    selectedFilter?.value = filter;
  }

  final List<Map<String, dynamic>> filter = [
    // {"title": "Position", "icon": AssetPath.player,},
    // {"title": "Primary Position", "icon": AssetPath.primaryPositionIcon},
    // {"title": "Verified", "icon": AssetPath.verifiedIcon},
    // {"title": "Video Type", "icon": AssetPath.videos},
    {"title": "Foot", "icon": AssetPath.foot, "isSelected": false},
    {"title": "Height", "icon": AssetPath.height, "isSelected": false},
    {"title": "Weight", "icon": AssetPath.height, "isSelected": false},
    {"title": "Age", "icon": AssetPath.ageIcon, "isSelected": false},
    {"title": "Player type", "icon": AssetPath.countryIcon, "isSelected": false},
    {"title": "County (Romania)", "icon": AssetPath.countryRomaniaIcon, "isSelected": false},
    {"title": "Under Contract", "icon": AssetPath.underContractIcon, "isSelected": false},
    {"title": "Available for Loan", "icon": AssetPath.loanIcon, "isSelected": false},
    {"title": "Nationality", "icon": AssetPath.nationalityIcons, "isSelected": false},
    {"title": "Experience Level", "icon": AssetPath.expLevelIcon, "isSelected": false},
    //{"title": "League Level Played", "icon": AssetPath.leaugeLevelPlayedIcon, "isSelected": false},
    {"title": "Consistency", "icon": AssetPath.consistencyIcon, "isSelected": false},
    //{"title": "Acceleration", "icon": AssetPath.accelerationIcon, "isSelected": false},
    //{"title": "Speed", "icon": AssetPath.speedIcon, "isSelected": false},
    {"title": "Secondary Role", "icon": AssetPath.secondaryRoleIcon, "isSelected": false},
    {"title": "Playing Style", "icon": AssetPath.playingStyleIcon, "isSelected": false},
    {"title": "Technical Attributes", "icon": AssetPath.playingStyleIcon, "isSelected": false},
    //{"title": "Strength", "icon": AssetPath.strengthIcon, "isSelected": false},
  ];

  RxList<Map<String, String>> filterOptions = <Map<String, String>>[
    {
      "label": "Position",
      "icon": AssetPath.player, // ADD your SVG here
    },
    {
      "label": "Foot",
      "icon": AssetPath.foot, // ADD your SVG here
    },
    {
      "label": "Height",
      "icon": AssetPath.height, // ADD your SVG here
    },
    {
      "label": "Club",
      "icon": AssetPath.club, // ADD your SVG here
    },
  ].obs;

  void selectFilter(String filter) {
    selectedFilter?.value = filter;
    update();
  }

  /*LISTS FOR POPUPS */
  List<String> ageOptions = ["U-8 (Under 8)", "U-10 (Under 10)", "U-16 (Under 16)", "U-18 (Under 18)", "Senior (18+)"];

  List<String> leagueLevelPlayedOptions = [
    "Romania Liga- 1",
    "Romania Liga- 2",
    "Romania Liga- 3",
    "Romania Liga- 4",
    "Academy Level",
    "International - Division 1",
    "International - Division 2",
    "International - Division 3",
  ];

  List<String> accelerateOptions = ["Low", "Medium", "High"];

  List<String> speedOptions = ["Low", "Medium", "High"];

  List<String> strengthOptions = ["Low", "Medium", "High"];

  List<String> experience = ["Professional", "Semi-professional", "Amateur"];

  List<String> playerTypeList = ["Romanian", "International", "Self Promoted"];

  List<String> consistencyList = ["Low", "Medium", "High"];

  List<String> countryList = [
    "Alba",
    "Arad",
    "Arges",
    "Bacau",
    "Bihor",
    "Bistrita-Nasaud",
    "Botosani",
    "Brasov",
    "Braila",
    "Bucharest",
    "Bucuresti",
    "Buzau",
    "Caras-Severin",
    "Calarasi",
    "Cluj",
    "Constanta",
    "Covasna",
    "Dambovita",
    "Dolj",
    "Galati",
    "Giurgiu",
    "Gorj",
    "Harghita",
    "Hunedoara",
    "Ialomita",
    "Iasi",
    "Ilfov",
    "Maramures",
    "Mehedinti",
    "Mures",
    "Neamt",
    "Olt",
    "Prahova",
    "Satu Mare",
    "Salaj",
    "Sibiu",
    "Suceava",
    "Teleorman",
    "Timis",
    "Tulcea",
    "Vaslui",
    "Valcea",
    "Vrancea",
  ];

  List<String> footList = ["Left", "Right", "Both"];

  List<String> videoTypeList = ["Skills", "Goals", "Defensive Actions", "Full Match", "Training Sessions", "Highlight Mix"];

  List<String> contractStatusList = ["Yes", "No"];

  List<String> availableLoanList = ["Yes", "No"];

  List<String> verificationList = ["Verified", "Not Verified"];

  List<String> primaryPositionList = [
    "Goalkeeper",
    "Right Back",
    "Left Back",
    "Right Wing Back",
    "Left Wing Back",
    "Center back",
    "Right Center Back",
    "Left Center Back",
    "Defensive Midfielder",
    "Attacking Midfielder",
    "Right Midfielder",
    "Left Midfielder",
    "Right Winger",
    "Left Winger",
    "Center Forward",
    "Striker",
    "Second Striker",
  ];

  void showSelectBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required RxString selectedValue,
    required String name,
    bool buttonEnable = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) =>
                Container(
                  constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
          
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget(heading: title.tr, fontSize: 18.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                          InkWell(
                            onTap: () => Get.back(),
                            child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                          ),
                        ],
                      ),
          
                      SizedBox(height: 2.h),
          
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            String item = options[index];
          
                            return Obx(() {
                              final isSelected = selectedValue.value == item;
          
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedValue.value = item;
          
                                    for (final item in filter) {
                                      if (item['title'] == name) {
                                        item['isSelected'] = true;
                                      }
                                    }
                                  });
          
                                  if (!buttonEnable) {
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonTextWidget(
                                        heading: item.tr,
                                        fontSize: 16.sp,
                                        color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                      ),
                                      Icon(
                                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                        color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
          
                      if (buttonEnable)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeProvider.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
                          ),
                          onPressed: () {
                            applyFilters();
                            Get.back();
                          },
                          child: CommonTextWidget(
                            heading: "Apply Filters".tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.whiteColor,
                          ),
                        ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }

  showSelectBottomSheetCheckBox({
    required BuildContext context,
    required String title,
    required List<DemoModelCheckBox> options,
    required String name,
    bool buttonEnable = false,
    required RxList<String> selectedValue,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) =>
              Container(
                constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextWidget(heading: title.tr, fontSize: 18.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          var item = options[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                item.isSelect = !item.isSelect;

                                final value = toCamelCase(item.title);

                                if (item.isSelect) {
                                  if (!selectedValue.contains(value)) {
                                    selectedValue.add(value);
                                  }
                                } else {
                                  selectedValue.remove(value);
                                }

                                for (final f in filter) {
                                  if (f['title'] == name) {
                                    f['isSelected'] = selectedValue.isNotEmpty;
                                  }
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget(
                                    heading: item.title.tr,
                                    fontSize: 16.sp,
                                    color: item.isSelect ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                  ),
                                  Icon(
                                    item.isSelect ? Icons.check_box : Icons.check_box_outline_blank,
                                    color: item.isSelect ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
        );
      },
    );
  }

  void showSelectBottomSheetTextField({
    required BuildContext context,
    required String title,
    required String textValue,
    bool keyboardInNumber = false,
    required Function(String) callBack,
    bool suffixIcon = false,
    required String name,
  }) {
    TextEditingController textController = TextEditingController();
    textController.text = textValue;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom, // moves up
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
          
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget(heading: title.tr, fontSize: 18.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                      ),
                    ],
                  ),
          
                  SizedBox(height: 2.h),
          
                  CustomTextField(
                    controller: textController,
                    suffixIcon: suffixIcon
                        ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CommonTextWidget(heading: "In cm's".tr, fontSize: 14, color: Colors.grey),
                    )
                        : SizedBox(),
                    textInputStyle: TextStyle(
                      color: ThemeProvider.hintText,
                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                      fontFamily: 'Montserrat',
                    ),
          
                    keyboardType: keyboardInNumber ? TextInputType.number : TextInputType.emailAddress,
                    hintText: "Write here".tr,
                    validator: (value) {
                      if (textController.text
                          .trim()
                          .isEmpty) {
                        return 'required value'.tr;
                      }
                      return null;
                    },
                  ),
          
                  SizedBox(height: 2.h),
          
                  Button(
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      callBack(textController.text);
                      for (final item in filter) {
                        if (item['title'] == name) {
                          item['isSelected'] = true;
                        }
                      }
                      Get.back();
                    },
                    title: "Apply".tr,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showSelectBottomSheetTextFieldHeight({
    required BuildContext context,
    required double min,
    required double max,
    required String title,
    required Function(String value) onDone,
    required String name,
    bool buttonEnable = false,
  }) {
    RangeValues currentRangeValues = RangeValues(min, max);
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) =>
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: const Color(0xFF1E1E1E),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Header with Done
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: CupertinoColors.separator)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: CommonTextWidget(heading: "Cancel".tr, fontSize: 16.sp, color: ThemeProvider.redColor),
                                    onPressed: () => Get.back(),
                                  ),
                                  CommonTextWidget(heading: title.tr, fontSize: 18.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
          
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: CommonTextWidget(heading: "Done".tr, fontSize: 16.sp, color: ThemeProvider.primary),
                                    onPressed: () {
                                      onDone("${currentRangeValues.start.round().toString()}-${currentRangeValues.end.round().toString()}");
                                      for (final item in filter) {
                                        if (item['title'] == name) {
                                          item['isSelected'] = true;
                                        }
                                      }

                                      if (buttonEnable) {
                                        applyFilters();
                                      }
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
          
                            const SizedBox(height: 20),
                            RangeSlider(
                              values: currentRangeValues,
                              max: 200,
                              min: name == "Weight"
                                  ?10
                              :100,
                              activeColor: ThemeProvider.primary,
                              divisions: (200 - (name == "Weight" ? 10 : 100)),
                              labels: RangeLabels(currentRangeValues.start.round().toString(), currentRangeValues.end.round().toString()),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  currentRangeValues = values;
                                  debugPrint("afash ashk  ${values.start.round().toString()}");
                                  debugPrint("afash ashk  ${values.end.round().toString()}");
                                });
                              },
                            ),
          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget(heading: currentRangeValues.start.round().toString(),
                                    fontSize: 14.sp,
                                    color: ThemeProvider.whiteColor),
                                CommonTextWidget(heading: currentRangeValues.end.round().toString(), fontSize: 14.sp, color: ThemeProvider.whiteColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        );
      },
    );
  }

  showSelectBottomSheetCountryCode({
    required BuildContext context,
    required String title,
    required String name,
    required Function(String) onDone,
    required RxString selectedValue,
    required List<NationalityOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) =>
              Container(
                constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextWidget(heading: title.tr, fontSize: 18.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Icon(Icons.close, color: ThemeProvider.closeIcon),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          var item = options[index];

                          return Obx(() {
                            final isSelected = selectedValue.value == item.en;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  onDone(item.en);

                                  for (final item in filter) {
                                    if (item['title'] == name) {
                                      item['isSelected'] = true;
                                    }
                                  }
                                });

                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonTextWidget(
                                      heading: item.en.tr,
                                      fontSize: 16.sp,
                                      color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                    ),
                                    Icon(
                                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: isSelected ? ThemeProvider.primary : ThemeProvider.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  getPlayerList(BuildContext context, {required int page}) async {
    isLoading = true;
    if (context.mounted && page == 1) LoaderDialog.show(context);
    final response = await parser.fetchingPlayList(
      page,
      search: searchController.text.trim(),
      foot: playerFoot.value,
      age: Utils.convert(age.value),
      country: toCamelCase(playerType.value),
      county: county.value,
      underContract: contractStatus.value == "Yes"
            ? "true"
            : contractStatus.value == "No"
            ? "false"
            : "",
      availableForLoan: availableForLoan.value=='Yes'?"true":availableForLoan.value=='No'?"false":"",
      club: clubParam,
      experienceLevel: toCamelCase(experienceParam.value),
      nationality: toCamelCase(nationalityParam.value),
      position: primaryPosition.value,
      consistency: consistencyText.value,
      height: heightParam.toString(),
      weight: weightParam.toString(),
      playingStyle : playingStyle,
        technicalAttributes : technicalAttribute,
        secondaryPosition : secondaryRole,
    );

    if (context.mounted && page == 1) LoaderDialog.hide(context);

    isLoading = false;
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      getAllPLayerListModel = GetAllPlayerListModel.fromJson(myMap);

      isCardCount.value = getAllPLayerListModel.data!.totalComparePLayers ?? 0;
      isSavedCount.value = getAllPLayerListModel.data!.totalSavedPlayers ?? 0;

      if (page == 1) {
        playerListBody.clear();
        searchingList.clear();
      }
      if (getAllPLayerListModel.data != null) {
        for (int i = 0; i < getAllPLayerListModel.data!.data.length; i++) {
          getAllPLayerListModel.data!.data[i].isSelectSave = getAllPLayerListModel.data!.data[i].isSaved!;
          getAllPLayerListModel.data!.data[i].isAddToCard = getAllPLayerListModel.data!.data[i].isCompared!;
          getAllPLayerListModel.data!.data[i].isSelectRate = getAllPLayerListModel.data!.data[i].isRated!;
        }
      }

      playerListBody.addAll(getAllPLayerListModel.data!.data);

      searchingList.addAll(getAllPLayerListModel.data!.data);

      update();
    } else {
      debugPrint('RESPONSE ERROR : $response');
    }
  }

  getRecentList(BuildContext context) async{
    await parser.fetchingRecentList().then((value) {
      if (value != null && value.statusCode == 200){
        Map<String, dynamic> myMap = Map<String, dynamic>.from(value.data);
        compareBody = RecentListModel.fromJson(myMap);
        recentlyPlayerList.clear();

        if(compareBody.data != null){
          for (int j = 0; j < compareBody.data!.length; j++) {
            compareBody.data![j].isSelectSave = compareBody.data![j].isSaved!;
            compareBody.data![j].isAddToCard = compareBody.data![j].isCompared!;
            compareBody.data![j].isSelectRate = compareBody.data![j].isRated!;
          }
        }
        recentlyPlayerList.addAll(compareBody.data ?? []);
        update();
      }
    });
  }

  addRecentList(BuildContext context,String id) async{
    Map<String , String> mapData = { "playerId": id };
    await parser.pushRecentList(mapData).then((value) {
      if (value != null && value.statusCode == 200){
        Get.toNamed(AppRouter.playerReport, arguments: [id,"scouting"])?.then((_) {
          getRecentList(context);
        });
      }
    });
    return false;
  }

  // Call this when Apply Filters is tapped
  applyFilters() {
    appliedFilters.clear();
    if (playerType.value.isNotEmpty) appliedFilters["Player type"] = playerType.value;
    if (playerFoot.value.isNotEmpty) appliedFilters["Foot"] = playerFoot.value;
    if (videoType.value.isNotEmpty) appliedFilters["Video Type"] = videoType.value;
    if (contractStatus.value.isNotEmpty) appliedFilters["Under Contract"] = contractStatus.value;
    if (availableForLoan.value.isNotEmpty) appliedFilters["Available for Loan"] = availableForLoan.value;
    if (playingStyle.isNotEmpty) appliedFilters["Playing Style"] = playingStyle.join(",");
    if (technicalAttribute.isNotEmpty) appliedFilters["Technical Attributes"] = technicalAttribute.join(", ");
    if (secondaryRole.isNotEmpty) appliedFilters["Secondary Role"] = secondaryRole.join(",");
    if (verificationStatus.value.isNotEmpty) appliedFilters["Verified"] = verificationStatus.value;
    if (primaryPosition.value.isNotEmpty) appliedFilters["Primary Position"] = primaryPosition.value;
    if (experienceLevel.value.isNotEmpty) appliedFilters["Experience Level"] = experienceLevel.value;
    if (speed.value.isNotEmpty) appliedFilters["Speed"] = speed.value;
    if (strength.value.isNotEmpty) appliedFilters["Strength"] = strength.value;
    if (leaugeLevelPlayed.value.isNotEmpty) appliedFilters["League Level Played"] = leaugeLevelPlayed.value;
    if (age.value.isNotEmpty) appliedFilters["Age"] = age.value;
    if (acceleration.value.isNotEmpty) appliedFilters["Acceleration"] = acceleration.value;
    if (county.value.isNotEmpty) appliedFilters["County"] = county.value;
    if (heightParam.isNotEmpty) appliedFilters["Height"] = heightParam.toString();
    if (weightParam.isNotEmpty) appliedFilters["Weight"] = weightParam.toString();
    if (experienceParam.value.isNotEmpty) appliedFilters["Experience Level"] = experienceParam.value;
    if (nationalityParam.isNotEmpty) appliedFilters["Nationality"] = nationalityParam.value;
    if (consistencyText.value.isNotEmpty) appliedFilters["Consistency"] = consistencyText.value;
    if (clubParam.isNotEmpty) appliedFilters["Club"] = clubParam;

    currentPage = 1;
    getPlayerList(getContext, page: currentPage);
  }
  clearAllFilters() {
    selectedFilter?.value = '';
    primaryPosition.value = '';
    playerFoot.value = '';
    videoType.value = '';
    contractStatus.value = '';
    availableForLoan.value = '';
    verificationStatus.value = '';
    experienceLevel.value = '';
    consistencyText.value = '';
    speed.value = '';
    strength.value = '';
    leaugeLevelPlayed.value = '';
    age.value = '';
    acceleration.value = '';
    heightParam = '';
    weightParam = '';
    clubParam = "";
    experienceParam.value = "";
    nationalityParam.value = "";
    positionParam = "";
    county.value = "";
    playerType.value = "";

    playingStyle.clear();
    technicalAttribute.clear();
    secondaryRole.clear();

    for (final item in filter) {
      item['isSelected'] = false;
    } for (final item in parser.playingStyleList) {
      item.isSelect = false;
    } for (final item in parser.secondaryRoleList) {
      item.isSelect = false;
    }for (final item in parser.technicalAttributesList) {
      item.isSelect = false;
    }

    appliedFilters.clear();
    currentPage = 1;
    getPlayerList(getContext, page: currentPage);
    update();
  }
}