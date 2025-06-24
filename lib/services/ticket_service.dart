import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ticket_model.dart';

class TicketService {
  final CollectionReference _ticketCollection =
  FirebaseFirestore.instance.collection('tickets');

  Future<void> createTicket(TicketModel ticket) async {
    await _ticketCollection.doc(ticket.id).set(ticket.toMap());
  }

  Future<List<TicketModel>> getTicketsForUser(String userId) async {
    final snapshot = await _ticketCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TicketModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTicketFeedback({
    required String ticketId,
    required int rating,
    required String feedback,
  }) async {
    await FirebaseFirestore.instance.collection('tickets').doc(ticketId).update({
      'rating': rating,
      'feedback': feedback,
      'feedbackSubmittedAt': FieldValue.serverTimestamp(), // optional
    });
  }

}
