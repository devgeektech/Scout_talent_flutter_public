import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:scouttalent2/backend/helper/app_router.dart';
import 'package:scouttalent2/backend/model/GetAllPlayerPlansModel.dart';
import 'package:scouttalent2/main.dart';
import 'package:scouttalent2/view/splash/splash_controller.dart';
import 'package:scouttalent2/widget/button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/model/ProfileResponseModel.dart';
import '../../backend/model/player_subs_model.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/api_exception.dart';
import '../../utils/string.dart';
import '../../utils/theme.dart';
import '../../utils/toast.dart';
import '../../utils/utils.dart';
import '../../widget/commomLoader.dart';
import '../../widget/commontext.dart';
import 'subscription_pricing_state.dart';

class SubscriptionPricingLogic extends GetxController {
  final SubscriptionPricingState state;
  SubscriptionPricingLogic({required this.state});

  final PageController pageController = PageController(viewportFraction: 0.85);
  List<PlayerPlanData> playerSubscriptionList = [];
  List<PlayerPlanData> monthlyPlans = [];
  List<PlayerPlanData> annualPlans = [];
  String? currentLang ;

  ///IOS Subscription
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSub;
  RxList<ProductDetails> iosProducts = <ProductDetails>[].obs;
  String? deviceId;
  RxBool isRestoredSubscription = false.obs;

  @override
  void onInit() {
    super.onInit();
    if(Platform.isIOS){
      if (Get.arguments != null && Get.arguments is bool) {
        isRestoredSubscription.value = Get.arguments as bool;
        print("Restore from arguments ---> ${isRestoredSubscription.value}");
      } else {
        isRestoredSubscription.value = false;
        print("No restore argument found");
      }
    }
   _init();
  }


  Future<void> handleUserFlow() async {
    try {
      final profile = await getUserProfile(); // API call

      bool isFree = profile?.data?.isFree ?? false;
      bool hasSubscription = profile?.data?.hasSubscription ?? false;
      num playerLimit = profile?.data?.playerLimit ?? 0;
      bool isUnlimited = profile?.data?.isUnlimited ?? false;
      String subscriptionStatus = profile?.data?.subscriptionStatus ?? "";


      if (kDebugMode) {
        print("isFree: $isFree | hasSubscription: $hasSubscription");
        print("Player limit is >>${playerLimit}");
      }

      await state.sharedPreferencesManager
          .putInt(AppString.playerLimit, playerLimit.toInt());
      await state.sharedPreferencesManager
          .putBool("isUnlimited", isUnlimited);
      await state.sharedPreferencesManager.putString("subscriptionStatus", subscriptionStatus);

    } catch (error) {
      print("❌ Error in profile API: $error");
      Get.offAllNamed(AppRouter.getSubscriptionViewRoute());
    }
  }


  Future<void> _init() async {
    userType();
    currentLang = await getLanguage();
    getPlayerPlansApi(Get.context!);

    if (Platform.isIOS) {
      _initAppleIAP();
      getDeviceId();
    }
  }

  void _initAppleIAP() {
    _purchaseSub = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (e) => debugPrint("IAP error: $e"),
    );
  }


  @override
  void onClose() {
    if (Platform.isIOS) {
      _purchaseSub.cancel();
    }
    super.onClose();
  }

  GetAllPlayerPlans getAllPlayerPlans = GetAllPlayerPlans();
  Future<GetAllPlayerPlans?> getPlayerPlansApi(BuildContext context) async {
    try {
      LoaderDialog.show(context);
      await Future.delayed(Duration(milliseconds: 50));
      final response = await state.getAllPlayerPlansApi();
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }

        getAllPlayerPlans = GetAllPlayerPlans.fromJson(data);

        if(getAllPlayerPlans.responseCode == 200){

          playerSubscriptionList = getAllPlayerPlans.data ?? [];
          monthlyPlans = playerSubscriptionList.where((plan) => plan.type == "monthly" && (plan.price ?? 0) > 0).toList();
          annualPlans  = playerSubscriptionList.where((plan) => plan.type == "annually" && (plan.price ?? 0) > 0).toList();

          // --- Move free monthly plan to index 0 ---
          // if(Utils.userRole == "player"){
          //   final freePlan = monthlyPlans.firstWhere(
          //         (plan) => plan.price == 0,
          //     orElse: () => PlayerPlanData(),
          //   );
          //
          //   if (freePlan != null) {
          //     monthlyPlans.remove(freePlan);
          //     monthlyPlans.insert(0, freePlan);
          //   }
          // }

          if (Platform.isIOS) {
            await loadIosProducts();
          }
          update();
          LoaderDialog.hide(context);
        }
        return getAllPlayerPlans;
      } else {
        LoaderDialog.hide(context);
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      LoaderDialog.hide(context);
      debugPrint("Error fetching plans: $e");
      return null;
    }
  }


  Future<void> makePayment(BuildContext context,{String? plan, String? planId,String? email}) async {
    try {
      CardFieldInputDetails? cardDetails;
      bool saveCard = false; // <-- Added checkbox state

      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: ThemeProvider.alertColor,
              title: CommonTextWidget(
                textAlign: TextAlign.center,
                heading:"Enter Card Details".tr,
                fontSize: Utils.responsiveFontSize(context, 20.sp),
                fontWeight: FontWeight.w600,
                color: ThemeProvider.primary,
                fontFamily: "Montserrat",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      iconTheme: IconThemeData(
                        color: Colors.red, // your desired icon color
                      ),
                    ),
                    child: CardField(
                      style:TextStyle(
                          fontFamily: 'Montserrat',
                          color: ThemeProvider.whiteColor,
                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                          fontWeight: FontWeight.w500
                      ) ,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: ThemeProvider.whiteColor.withAlpha(90),
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontWeight: FontWeight.w500
                        )
                      ),
                      onCardChanged: (card) {
                        print("CARD DATA: $card");
                        setState(() => cardDetails = card);
                      },
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     CheckboxTheme(
                  //       data: CheckboxThemeData(
                  //         visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(
                  //             4,
                  //           ), // ← round inner square
                  //         )
                  //       ),
                  //       child: Checkbox(
                  //         activeColor: ThemeProvider.primary,
                  //         // orange fill when checked
                  //         checkColor: Colors.white,
                  //         side: const BorderSide(
                  //           color: Colors.white,
                  //           // border color when unchecked
                  //           width: 2,
                  //         ),
                  //         value: saveCard,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             saveCard = value!;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(child:
                  //     CommonTextWidget(
                  //       textAlign: TextAlign.start,
                  //       heading:"Save this card for future payments".tr,
                  //       fontSize: Utils.responsiveFontSize(context, 16.sp),
                  //       fontWeight: FontWeight.w600,
                  //       color: ThemeProvider.whiteColor,
                  //       fontFamily: "Montserrat",
                  //     ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              actions: [
                Button(
                    onPressed: () async {
                      if (cardDetails == null || !cardDetails!.complete) {
                        Get.snackbar(
                          "Error".tr,
                          "Enter complete card details".tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      // ✅ Custom validation: max 5 years from current year
                      final maxAllowedYear = (DateTime.now().year + 5) % 100;

                      final enteredYear = cardDetails!.expiryYear;
                      final enteredMonth = cardDetails!.expiryMonth;

                      if (enteredYear == null || enteredMonth == null) {
                        Get.snackbar(
                          "Error".tr,
                          "Invalid expiry date".tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // 🚫 Reject if year is more than 5 years in future
                      if (enteredYear > maxAllowedYear) {
                        Get.snackbar(
                          "Error".tr,
                          "Card expiry year must be within 5 years".tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }


                      try {
                        // Create PaymentMethod
                        final pm = await Stripe.instance.createPaymentMethod(
                          params: PaymentMethodParams.card(
                            paymentMethodData: PaymentMethodData(),
                          ),
                        );

                        print("PaymentMethod: ${pm.id}");

                        // Create Token
                        final token = await Stripe.instance.createToken(
                          const CreateTokenParams.card(params: CardTokenParams()),
                        );

                        if (kDebugMode) {
                          print("Card Token: ${token.id}");
                        }

                        Navigator.pop(context, {
                          "pm": pm.id,
                          "token": token.id,
                        });
                      } catch (e) {
                        if (kDebugMode) {
                          print("Stripe error: $e");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$e")),
                        );
                      }
                    },
                    title: "Continue"),
                // TextButton(
                //   onPressed: () async {
                //     if (cardDetails == null || !cardDetails!.complete) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text("Enter complete card details")),
                //       );
                //       return;
                //     }
                //
                //     try {
                //       // Create PaymentMethod
                //       final pm = await Stripe.instance.createPaymentMethod(
                //         params: PaymentMethodParams.card(
                //           paymentMethodData: PaymentMethodData(),
                //         ),
                //       );
                //
                //       print("PaymentMethod: ${pm.id}");
                //
                //       // Create Token
                //       final token = await Stripe.instance.createToken(
                //         const CreateTokenParams.card(params: CardTokenParams()),
                //       );
                //
                //       print("Card Token: ${token.id}");
                //
                //       Navigator.pop(context, {
                //         "pm": pm.id,
                //         "token": token.id,
                //       });
                //     } catch (e) {
                //       print("Stripe error: $e");
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("$e")),
                //       );
                //     }
                //   },
                //   child: const Text("Continue"),
                // )
              ],
            );
          });
        },
      ).then((result) async {
        if (result != null) {
          if (kDebugMode) {
            print("SEND TO BACKEND: $result");
          }
          await createSubscriptionApi(
          context,
          plan: plan!,
          planId: planId!,
          email: email!,
          paymentMethodId: result['pm'],
          cardToken: result['token'],
          savePaymentMethod: true,
          );
          // print("Yoooo>>>>>>");
        }
      });

    } catch (e) {
      print("Payment Error: $e");
    }
  }

  Future<void> createSubscriptionApi(BuildContext context,{
    required String plan,
    required String planId,
    required String paymentMethodId,
    required String cardToken,
    required String email,
    bool savePaymentMethod = false,
  }) async {
    String endPoint = state.getSubscriptionUrl();
    if (kDebugMode) {
      print("endPoint=========================$endPoint");
    }
    try {
      LoaderDialog.show(context);
      Map<String, Object> body = {
        "plan": plan,
        "planId": planId,
        "paymentMethod": paymentMethodId,
        "cardToken": cardToken,
        "savePaymentMethod": savePaymentMethod,
        "email": email
      };
      var response = await state.createSubscription(body,endPoint);

      if (response.statusCode == 200) {
        await handleUserFlow();
        // getUserProfile();
        LoaderDialog.hide(context);
        successToast("Your subscription has been activated!".tr);
        Get.offAllNamed(AppRouter.getDashboardRoute());
        //handleUserFlow();

      } else {
        LoaderDialog.hide(context);
        String message = "Something went wrong";
        try {
          if (response.data is String) {
            final dataMap = jsonDecode(response.data);
            message = dataMap["responseMessage"]?.toString() ?? message;
          } else if (response.data is Map<String, dynamic>) {
            message = response.data["responseMessage"]?.toString() ?? message;
          }
        } catch (_) {}

        errorToast(message);
      }
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }


  Future<ProfileResModel?> getUserProfile() async {
    try {
      final response = await state.apiService.getApiWithHeader(
          showToast: false,
          "$getProfile/${Utils.userUid}");
      if (response != null) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            debugPrint("JSON decode failed");
          }
        }
        // Parse into ProfileResModel
        final profile = ProfileResModel.fromJson(data);
        await state.isFreeAccount(profile.data?.isFree??false);
        await state.hasSubscription(profile.data?.hasSubscription??false);
        await state.sharedPreferencesManager.putString("subscriptionStatus", profile.data?.subscriptionStatus ?? "");
        if (kDebugMode) {
          print("isFree---->${profile.data?.isFree}");
          print("hasSubscription---->${profile.data?.hasSubscription}");

        }
        return profile;
      } else {
        debugPrint("No response received from server");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }



  ///IOS Methods
  PlayerPlanData? selectedApplePlan;
  SubscriptionPlan? selectedRestorePlan;
  bool _isUserInitiatedPurchase = false;
  bool _isProcessingPurchase = false;


  Future<void> loadIosProducts() async {
    final ids = playerSubscriptionList
        .map((e) => e.iosProductId)
        .whereType<String>()
        .toSet();

    final response = await _iap.queryProductDetails(ids);

    if (response.error != null) {
      debugPrint(response.error!.message);
      return;
    }

    iosProducts.assignAll(response.productDetails);
  }
  Future<void> createIosSubscriptionApi(BuildContext context,{
    required String iosProductId,
    required String planId,
    required String paymentMethodId,
    required String receipt,
  }) async {
    try {
      //LoaderDialog.show(context);
      Map<String, Object> body = {
        "iosProductId": iosProductId,
        "planId": planId,
        "paymentMethod": paymentMethodId,
        "deviceId":deviceId ?? "",
        "receipt":receipt
      };

      print("body---->\n${jsonEncode(body)}");
      var response = await state.createIosSubscription(body);

      if (response.statusCode == 200) {
        // getUserProfile();
        await handleUserFlow();
        LoaderDialog.hide(context);
        successToast("Your subscription has been activated!".tr);
        Get.offAllNamed(AppRouter.getDashboardRoute());
      } else {
        LoaderDialog.hide(context);
        String message = "Something went wrong";
        try {
          if (response.data is String) {
            final dataMap = jsonDecode(response.data);
            message = dataMap["responseMessage"]?.toString() ?? message;
          } else if (response.data is Map<String, dynamic>) {
            message = response.data["responseMessage"]?.toString() ?? message;
          }
        } catch (_) {}

        errorToast(message);
      }
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }
  void buyApplePlan(PlayerPlanData plan) {
    selectedApplePlan = plan;
    _isUserInitiatedPurchase = true;
    _isProcessingPurchase = false;

    LoaderDialog.show(getContext);

    final product = iosProducts.firstWhere(
          (p) => p.id == plan.iosProductId,
    );

    final param = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: param);
  }
  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (!_isUserInitiatedPurchase) {
        debugPrint("Ignoring purchase stream event");
        continue;
      }

      if (_isProcessingPurchase) return;
      debugPrint("purchase.status====>${purchase.status}");
      debugPrint("receipt====>${purchase.verificationData.serverVerificationData}");


      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        _isProcessingPurchase = true;


        String planId = "";
        String productId = "";

        // Normal Buy Flow (unchanged)
        if (selectedApplePlan != null) {
          planId = selectedApplePlan!.sId ?? "";
          productId = selectedApplePlan!.iosProductId ?? "";
        }
      // Restore Flow
        else if (selectedRestorePlan != null) {
          planId = selectedRestorePlan!.id ?? "";
          productId = selectedRestorePlan!.iosProductId ?? "";
        } else {
          _clearPurchaseFlow();
          return;
        };

        createIosSubscriptionApi(getContext,
            planId: planId??"",
            iosProductId: productId ??"" ,
            paymentMethodId: purchase.purchaseID ?? "",
            receipt: purchase.verificationData.serverVerificationData
        ).whenComplete(() {
          _clearPurchaseFlow();
        });
        //_sendReceiptToBackend(purchase);
      }


      if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        _clearPurchaseFlow();
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void _clearPurchaseFlow() {
    debugPrint("Clearing Apple IAP flow");

    selectedApplePlan = null;
    _isUserInitiatedPurchase = false;
    _isProcessingPurchase = false;
  }

  Future<void> restoreApplePurchase(SubscriptionPlan plan) async {
    _isUserInitiatedPurchase = true;
    selectedApplePlan = null;
    selectedRestorePlan = plan;
    await InAppPurchase.instance.restorePurchases();
  }
  Future<void> openAppleSubscriptions() async {
    final Uri url = Uri.parse(
      'https://apps.apple.com/account/subscriptions',
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open subscriptions';
    }
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;

      print("deviceId--->${deviceId}");
    }
    return deviceId;
  }
  ///IOS Methods
/*  PlayerPlanData? selectedApplePlan;

  Future<void> loadIosProducts() async {
    final ids = playerSubscriptionList
        .map((e) => e.iosProductId)
        .whereType<String>()
        .toSet();

    final response = await _iap.queryProductDetails(ids);

    if (response.error != null) {
      debugPrint(response.error!.message);
      return;
    }

    iosProducts.assignAll(response.productDetails);
  }
  Future<void> createIosSubscriptionApi(BuildContext context,{
    required String iosProductId,
    required String planId,
    required String paymentMethodId,
  }) async {
    try {
      LoaderDialog.show(context);
      Map<String, Object> body = {
        "iosProductId": "monthlyPrice4_99",
        "planId": "6971b63b45d27831eadff575",
        "paymentMethod": "pm_1SaCf6JjC9TnMfqDkcqXOfGv"
      };
      var response = await state.createIosSubscription(body);

      if (response.statusCode == 200) {
        getUserProfile();
        LoaderDialog.hide(context);
        successToast("Your subscription has been activated!".tr);
        Get.offAllNamed(AppRouter.getDashboardRoute());
      } else {
        LoaderDialog.hide(context);
        String message = "Something went wrong";
        try {
          if (response.data is String) {
            final dataMap = jsonDecode(response.data);
            message = dataMap["responseMessage"]?.toString() ?? message;
          } else if (response.data is Map<String, dynamic>) {
            message = response.data["responseMessage"]?.toString() ?? message;
          }
        } catch (_) {}

        errorToast(message);
      }
    } catch (error) {
      LoaderDialog.hide(context);
      ApiException apiError = ApiException.fromError(error);
      errorToast(apiError.message);
    }
  }
  void buyApplePlan(PlayerPlanData plan) {
    selectedApplePlan = plan;
    final product = iosProducts.firstWhere(
          (p) => p.id == plan.iosProductId,
    );

    final param = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: param);
  }
  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _sendReceiptToBackend(purchase);
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }
  Future<void> _sendReceiptToBackend(PurchaseDetails purchase) async {
    final plan = selectedApplePlan!;
    print("iosProductId::::::::${plan.iosProductId}");
    print("planId::::::::${plan.sId}");
    final body = {
      "iosProductId": plan.iosProductId,
      "planId": plan.sId,
      "paymentMethod": purchase.purchaseID,
    };

    await state.createIosSubscription(body);
  }*/


}
