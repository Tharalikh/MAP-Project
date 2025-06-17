import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

const String stripePublishableKey = "pk_test_51RXztXHvyUcnnF5YPbWyJk97n3lGG5WVQtcnRO9s5Fbz4t2XKPENbPo5Uh4KNgRQVCaOJdxP5ablMGo6BaMD1ujC006bF5zUM1";
const String stripeSecretKey = "sk_test_51RXztXHvyUcnnF5YRaE1mNMVb9PuxjyXSDWIsFzBt4cGstSwIHYAZVNawiX40102pc7FH7qOECqzE7Dmw9kiZ6TX00p5vx63Tj";

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(double amount) async {
    try {
      final clientSecret = await _createPaymentIntent(amount, "myr");
      if (clientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "FestQuest",
        ),
      );

      await processPayment();
    } catch (e) {
      print("Stripe error: $e");
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();

      final data = {
        'amount': calculateAmount(amount), // must be int (in cents)
        'currency': currency,
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data["client_secret"] != null) {
        return response.data["client_secret"];
      } else {
        print("Stripe response error: ${response.data}");
      }
    } catch (e) {
      print("Stripe payment intent error: $e");
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

  int calculateAmount(double amount) {
    return (amount * 100).round(); // convert MYR to cents
  }
}
