import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/subscription_viewModel.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SubscriptionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Subscription")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Benefits',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...vm.benefits
                .map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(benefit, style: const TextStyle(fontSize: 16)),
                  ),
                )
                .toList(),
            const SizedBox(height: 30),
            Text(
              '💳 Price: ${vm.priceMonthly} or ${vm.priceYearly}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/subscription/payment_method');
                },
                child: Text(vm.isSubscribed ? 'Unsubscribe' : 'Subscribe Now'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                vm.isSubscribed
                    ? '✅ You are subscribed!'
                    : 'Stay tuned! Subscription support will be available in a future update.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
