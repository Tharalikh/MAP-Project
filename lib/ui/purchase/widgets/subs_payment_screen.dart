import 'package:flutter/material.dart';

class SubscriptionPaymentMethodScreen extends StatelessWidget {
  const SubscriptionPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Payment Method')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _methodTile(context, 'Debit Card'),
          _methodTile(context, 'Credit Card'),
          _methodTile(context, 'E-Money'),
        ],
      ),
    );
  }

  Widget _methodTile(BuildContext context, String method) {
    return ListTile(
      title: Text(method),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/subscription/payment_form',
          arguments: method,
        );
      },
    );
  }
}
