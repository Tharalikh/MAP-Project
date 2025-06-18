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
  final DateTime createdAt;
  final String poster;

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
    required this.createdAt,
    required this.poster,
  });

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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] ?? 1,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      poster: map['poster'] ?? '',
    );
  }

}
