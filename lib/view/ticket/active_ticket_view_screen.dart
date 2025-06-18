import 'package:festquest/model/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../view_model/ticket_viewModel.dart';

class ActiveTicketScreen extends StatelessWidget {
  final TicketModel ticket;

  const ActiveTicketScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Text('📍 Location: ${ticket.location}'),
            Text('📅 Date: ${ticket.date}'),
            Text('🕒 Time: ${ticket.time}'),
            Text('🎫 Quantity: ${ticket.quantity}'),
            const SizedBox(height: 16),
            Center(
              child: QrImageView(
                data: ticket.id,
                version: QrVersions.auto,
                size: 180.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

