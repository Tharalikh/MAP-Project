import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festquest/model/ticket_model.dart';
import 'package:flutter/material.dart';

class HistoryTicketScreen extends StatefulWidget {
  final TicketModel ticket;

  const HistoryTicketScreen({super.key, required this.ticket});

  @override
  State<HistoryTicketScreen> createState() => _HistoryTicketScreenState();
}

class _HistoryTicketScreenState extends State<HistoryTicketScreen> {
  int rating = 0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ticket History Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
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
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.location_on, 'Location', ticket.location),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.calendar_today, 'Date', ticket.date),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.access_time, 'Time', ticket.time),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.confirmation_number, 'Quantity', ticket.quantity.toString()),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.badge, 'Ticket ID', ticket.id),
                        const SizedBox(height: 24),

                        // ⭐ Rating Section
                        const Text(
                          'Rate Your Experience:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: index < rating ? Colors.orange : Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 12),

                        // 📝 Feedback Field
                        const Text(
                          'Leave a Feedback:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: feedbackController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Write your feedback here...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              final feedback = feedbackController.text.trim();

                              if (rating == 0 || feedback.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please rate and provide feedback")),
                                );
                                return;
                              }

                              try {
                                await FirebaseFirestore.instance
                                    .collection('tickets')
                                    .doc(ticket.id)
                                    .update({
                                  'rating': rating,
                                  'feedback': feedback,
                                  'feedbackSubmittedAt': FieldValue.serverTimestamp(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("✅ Feedback submitted!")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("❌ Failed to submit feedback: $e")),
                                );
                              }
                            }, child: const Text('Submit'),
                        ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
