import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  String selectedCity = "Johor Bahru";

  void changeCity(String city) {
    selectedCity = city;
    notifyListeners();
  }
}
