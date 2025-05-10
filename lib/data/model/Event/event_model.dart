import 'dart:io';

class Event {
  final int id;
  final String title;
  final String date;
  final String location;
  final double price;
  final File? posterPath;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.posterPath,
  });
}
