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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Add share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ticket Card
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Event Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: ticket.poster.isNotEmpty
                          ? Image.network(
                        ticket.poster,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Image not available', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('No image available', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Ticket Information
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        Text(
                          ticket.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Event Details
                        _buildInfoRow(
                          Icons.location_on,
                          'Location',
                          ticket.location,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.calendar_today,
                          'Date',
                          ticket.date,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.access_time,
                          'Time',
                          ticket.time,
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.confirmation_number,
                          'Quantity',
                          ticket.quantity.toString(),
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.badge,
                          'Ticket ID',
                          ticket.id,
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.withValues(alpha: 0.1),
                                  Colors.grey.withValues(alpha: 0.5),
                                  Colors.grey.withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // QR Code Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Scan this QR code at the venue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                          child: QrImageView(
                            data: 'TICKET:${ticket.name}-${ticket.id}',
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Ticket ID: ${ticket.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Download ticket functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download ticket functionality coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Ticket'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Important Notes
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Important Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Please arrive 30 minutes before the event starts\n'
                        '• Keep your ticket ready for scanning\n'
                        '• No refunds or exchanges allowed\n'
                        '• Bring a valid ID for verification',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}