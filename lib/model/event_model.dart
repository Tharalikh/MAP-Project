class EventModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String price;
  final String location;
  final String poster;
  final String category;
  final String creatorId;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.price,
    required this.location,
    required this.poster,
    required this.category,
    required this.creatorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'price': price,
      'location': location,
      'poster': poster,
      'category': category,
      'creatorId': creatorId,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: map['price'] ?? '',
      location: map['location'] ?? '',
      poster: map['poster'] ?? '',
      category: map['category'] ?? '',
      creatorId: map['creatorId'] ?? '',
    );
  }
}