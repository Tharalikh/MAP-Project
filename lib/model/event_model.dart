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
  final int capacity;
  final int bookedCount;

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
    required this.capacity,
    this.bookedCount = 0,
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
      'capacity': capacity,
      'bookedCount': bookedCount,
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
      capacity: map['capacity'] ?? 0,
      bookedCount: map['bookedCount'] ?? 0,
    );
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? price,
    String? location,
    String? poster,
    String? category,
    String? creatorId,
    int? capacity,
    int? bookedCount,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      location: location ?? this.location,
      poster: poster ?? this.poster,
      category: category ?? this.category,
      creatorId: creatorId ?? this.creatorId,
      capacity: capacity ?? this.capacity,
      bookedCount: bookedCount ?? this.bookedCount,
    );
  }

  bool get isFullyBooked => bookedCount >= capacity;

  int get remainingCapacity => capacity - bookedCount;

  double get capacityPercentage => capacity > 0 ? bookedCount / capacity : 0.0;

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, category: $category, capacity: $capacity, bookedCount: $bookedCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}