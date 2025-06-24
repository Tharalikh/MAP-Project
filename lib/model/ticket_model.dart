import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id;
  final String eventId;
  final String userId;
  final String name;
  final String location;
  final String date;
  final String time;
  final double price;
  final int quantity;
  final String poster;
  final DateTime createdAt;
  final String qrCode;
  final int? rating;
  final String? feedback;


  TicketModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.quantity,
    required this.poster,
    required this.createdAt,
    required this.qrCode,
    required this.rating,
    required this.feedback
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'quantity': quantity,
      'poster': poster,
      'createdAt': Timestamp.fromDate(createdAt),
      'qrCode': qrCode,
      'rating' : rating,
      'feedback' : feedback,
    };
  }

  // Create from Map (Firestore data)
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      poster: map['poster'] ?? '',
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      qrCode: map['qrCode'] ?? '',
      rating: map['rating'] ?? 0,
      feedback: map['feedback'] ?? '',
    );
  }

  // Generate unique QR code data
  static String generateQRCode(String ticketId, String eventId, String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'FESTQUEST:$ticketId:$eventId:$userId:$timestamp';
  }
}
