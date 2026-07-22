import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeServices{
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(BuildContext context) async {
    try {
      CardFieldInputDetails? cardDetails;
      bool saveCard = false; // <-- Added checkbox state

      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Enter Card Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardField(
                    onCardChanged: (card) {
                      setState(() => cardDetails = card);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CheckboxTheme(
                        data: CheckboxThemeData(
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ), // ← round inner square
                          ),
                        ),
                        child: Checkbox(
                          value: saveCard,
                          onChanged: (value) {
                            setState(() {
                              saveCard = value!;
                            });
                          },
                        ),
                      ),
                      const Expanded(child: Text("Save this card for future payments")),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (cardDetails == null || !cardDetails!.complete) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter complete card details")),
                      );
                      return;
                    }

                    try {
                      // 1️⃣ Create PaymentMethod
                      final pm = await Stripe.instance.createPaymentMethod(
                        params: PaymentMethodParams.card(
                          paymentMethodData: PaymentMethodData(),
                        ),
                      );

                      if (kDebugMode) {
                        print("PaymentMethod: ${pm.id}");
                      }

                      // 2️⃣ Create Token
                      final token = await Stripe.instance.createToken(
                        const CreateTokenParams.card(params: CardTokenParams()),
                      );

                      print("Card Token: ${token.id}");

                      Navigator.pop(context, {
                        "pm": pm.id,
                        "token": token.id,
                      });
                    } catch (e) {
                      print("Stripe error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$e")),
                      );
                    }
                  },
                  child: const Text("Continue"),
                )
              ],
            );
          });
        },
      ).then((result) {
        if (result != null) {
          if (kDebugMode) {
            print("SEND TO BACKEND: $result");
          }
        }
      });

    } catch (e) {
      print("Payment Error: $e");
    }
  }

  createPaymentIntent(int amount, String currency, String paymentMethodId) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method': paymentMethodId,
        'confirmation_method': 'manual',
        'confirm': 'true',
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (kDebugMode) {
        print("response--->${response.body}");
      }
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }


  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Successful!"),
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Error is:---> $e');
      }
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  String calculateAmount(int amount){
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
