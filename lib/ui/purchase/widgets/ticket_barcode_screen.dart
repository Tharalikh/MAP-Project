import 'package:flutter/material.dart';

class TicketSuccessScreen extends StatelessWidget {
  const TicketSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Confirmation")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.qr_code_2, size: 200),
              const SizedBox(height: 20),
              const Text(
                "Thank You for Purchasing!",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: const Text("Download")),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
