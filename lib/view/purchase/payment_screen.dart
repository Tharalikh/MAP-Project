/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/purchase_viewModel.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PurchaseViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Payment Method")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Payment Method:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  vm.setPaymentMethod("Debit");
                  Navigator.pushNamed(
                    context,
                    '/payment_confirm',
                    arguments: "Debit Card",
                  );
                },
                child: const Text("Debit"),
              ),
              ElevatedButton(
                onPressed: () {
                  vm.setPaymentMethod("Credit");
                  Navigator.pushNamed(
                    context,
                    '/payment_confirm',
                    arguments: "Credit Card",
                  );
                },
                child: const Text("Credit"),
              ),
              ElevatedButton(
                onPressed: () {
                  vm.setPaymentMethod("E-Wallet");
                  Navigator.pushNamed(
                    context,
                    '/payment_confirm',
                    arguments: "E-Money",
                  );
                },
                child: const Text("E-Wallet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/