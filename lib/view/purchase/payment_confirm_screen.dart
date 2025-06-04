import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/purchase_viewModel.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PurchaseViewModel>(context);
    final String method = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Payment")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ticket Detail:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Section A ............................................. ${vm.quantity}x",
              ),
              Text("Total Price: \$${vm.total.toStringAsFixed(2)}"),
              const SizedBox(height: 20),
              Text("Payment Method: ${vm.paymentMethod}"),
              if (method == 'E-Money')
                TextField(
                  decoration: const InputDecoration(labelText: 'Wallet ID'),
                )
              else ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Card Number'),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cardholder Name',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Expiry Date'),
                ),
                TextField(decoration: const InputDecoration(labelText: 'CVV')),
              ],
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/barcode');
                  },
                  child: const Text("Confirm Purchase"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
