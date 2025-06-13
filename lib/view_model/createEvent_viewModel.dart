import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventViewModel extends ChangeNotifier {
  String _title = '';
  String _description = '';
  String _category = '';
  String _location = '';
  String _date = '';
  String _time = '';
  String _price = '';
  String _poster = '';

  // Valid categories with proper capitalization
  static const List<String> validCategories = ['Concert', 'Festival', 'Sports'];

  // Getters
  String get title => _title;
  String get description => _description;
  String get category => _category;
  String get location => _location;
  String get date => _date;
  String get time => _time;
  String get price => _price;
  String get poster => _poster;

  // Setters
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setCategory(String category) {
    print("=== setCategory DEBUG ===");
    print("Input category: '$category'");

    // Ensure proper capitalization by finding the correct match
    String validatedCategory = category;

    for (String correctCategory in validCategories) {
      if (correctCategory.toLowerCase() == category.toLowerCase()) {
        validatedCategory = correctCategory;
        print("Corrected category: '$validatedCategory'");
        break;
      }
    }

    // Only set if it's a valid category
    if (validCategories.contains(validatedCategory)) {
      _category = validatedCategory;
      print("Final category set: '$_category'");
    } else {
      print("ERROR: Invalid category '$category' rejected");
      return;
    }

    notifyListeners();
  }

  void setLocation(String location) {
    _location = location;
    notifyListeners();
  }

  void setDate(String date) {
    _date = date;
    notifyListeners();
  }

  void setTime(String time) {
    _time = time;
    notifyListeners();
  }

  void setPrice(String price) {
    _price = price;
    notifyListeners();
  }

  void setPoster(String poster) {
    _poster = poster;
    notifyListeners();
  }

  Future<bool> saveEvent() async {
    try {
      print("=== SAVE EVENT DEBUG ===");
      print("Saving event with category: '$_category'");

      // Double-check category before saving
      if (!validCategories.contains(_category)) {
        print("ERROR: Attempting to save invalid category '$_category'");
        return false;
      }

      final eventData = {
        'title': _title,
        'description': _description,
        'category': _category, // This should be properly capitalized now
        'location': _location,
        'date': _date,
        'time': _time,
        'price': _price,
        'poster': _poster,
        'createdAt': FieldValue.serverTimestamp(),
        // Add any other fields you need
      };

      print("Event data being saved: $eventData");
      print("Category in data: '${eventData['category']}'");

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('events')
          .add(eventData);

      print("Event saved successfully");

      // Clear form after successful save
      clearForm();

      return true;
    } catch (e) {
      print("Error saving event: $e");
      return false;
    }
  }

  void clearForm() {
    _title = '';
    _description = '';
    _category = '';
    _location = '';
    _date = '';
    _time = '';
    _price = '';
    _poster = '';
    notifyListeners();
  }
}