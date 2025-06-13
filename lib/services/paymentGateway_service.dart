import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

const String stripePublishableKey = "pk_test_51RXztXHvyUcnnF5YPbWyJk97n3lGG5WVQtcnRO9s5Fbz4t2XKPENbPo5Uh4KNgRQVCaOJdxP5ablMGo6BaMD1ujC006bF5zUM1";
const String stripeSecretKey = "sk_test_51RXztXHvyUcnnF5YRaE1mNMVb9PuxjyXSDWIsFzBt4cGstSwIHYAZVNawiX40102pc7FH7qOECqzE7Dmw9kiZ6TX00p5vx63Tj";

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "myr");
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Athar",
        ),
      );
      await processPayment();
    } catch (e) {
      print("Error making payment: $e");
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          "Authorization": "Bearer $stripeSecretKey",
          "Content-Type": 'application/x-www-form-urlencoded'
      },
      ),
    );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch(e) {
      print(e);
    }
    return null;
  }

  Future<void> processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print("Error processing payment: $e");
    }
  }

  String calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}