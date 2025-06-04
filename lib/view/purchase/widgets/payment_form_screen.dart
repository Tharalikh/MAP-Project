import 'package:flutter/material.dart';

class SubscriptionPaymentFormScreen extends StatelessWidget {
  const SubscriptionPaymentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String method = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Pay with $method')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (method == 'E-Money')
              TextField(
                decoration: const InputDecoration(labelText: 'Wallet ID'),
              )
            else ...[
              TextField(
                decoration: const InputDecoration(labelText: 'Card Number'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Expiry Date'),
              ),
              TextField(decoration: const InputDecoration(labelText: 'CVV')),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Subscription Successful!')),
                );
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/subscription'),
                );
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
