import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/purchase_viewModel.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PurchaseViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Event 1")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/1.png',
                  fit: BoxFit.cover,
                ),
              ),),
            const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Lorem ipsum dolor sit amet...\nLine 2...\nLine 3..."),
            const SizedBox(height: 10),
            const Text("Date: 12/12/2025"),
            const Text("Location: Arena Stadium, KL"),
            Text("Price: \$${vm.pricePerTicket}"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: vm.decrement, icon: const Icon(Icons.remove_circle)),
                Text(vm.quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(onPressed: vm.increment, icon: const Icon(Icons.add_circle)),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/payment_type'),
                child: const Text("Purchase"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
