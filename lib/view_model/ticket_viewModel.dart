import 'package:flutter/material.dart';

class TicketViewModel extends ChangeNotifier {
  List<Map<String, String>> activeTickets = [
    {
      'name': 'Music Fest 2025',
      'location': 'Dewan Raya, JB',
      'amount': 'RM120',
      'date': 'June 25, 2025',
      'time': '7:00 PM',
      'ticketId': 'TKT001258963',
      'category': 'Festival',
      'description': 'Annual music festival featuring local and international artists',
    },
    {
      'name': 'Football Championship',
      'location': 'Stadium Larkin',
      'amount': 'RM55',
      'date': 'July 15, 2025',
      'time': '8:00 PM',
      'ticketId': 'TKT002147852',
      'category': 'Sports',
      'description': 'Local football championship final match',
    },
  ];

  List<Map<String, String>> ticketHistory = [
    {
      'name': 'Pop Night Extravaganza',
      'location': 'Open Air Stadium',
      'amount': 'RM80',
      'date': 'April 5, 2025',
      'time': '8:00 PM',
      'ticketId': 'TKT001789456',
      'category': 'Concert',
      'description': 'Pop music concert featuring top artists',
      'status': 'completed',
    },
    {
      'name': 'Badminton Tournament',
      'location': 'Sports Complex JB',
      'amount': 'RM35',
      'date': 'March 22, 2025',
      'time': '2:00 PM',
      'ticketId': 'TKT001456789',
      'category': 'Sports',
      'description': 'Regional badminton championship tournament',
      'status': 'completed',
    },
    {
      'name': 'Cultural Heritage Festival',
      'location': 'Heritage Park',
      'amount': 'RM25',
      'date': 'February 18, 2025',
      'time': '10:00 AM',
      'ticketId': 'TKT001234567',
      'category': 'Festival',
      'description': 'Traditional Malaysian cultural festival celebration',
      'status': 'completed',
    },
  ];

  // Method to add a new ticket (for when user purchases)
  void addActiveTicket(Map<String, String> ticket) {
    activeTickets.add(ticket);
    notifyListeners();
  }

  // Method to move ticket from active to history
  void completeTicket(String ticketId) {
    final ticketIndex = activeTickets.indexWhere((ticket) => ticket['ticketId'] == ticketId);
    if (ticketIndex != -1) {
      final ticket = activeTickets.removeAt(ticketIndex);
      ticket['status'] = 'completed';
      ticketHistory.insert(0, ticket); // Add to the beginning of history
      notifyListeners();
    }
  }

  // Method to get ticket by ID
  Map<String, String>? getTicketById(String ticketId) {
    try {
      return activeTickets.firstWhere((ticket) => ticket['ticketId'] == ticketId);
    } catch (e) {
      try {
        return ticketHistory.firstWhere((ticket) => ticket['ticketId'] == ticketId);
      } catch (e) {
        return null;
      }
    }
  }

  // Method to check if ticket is active
  bool isTicketActive(String ticketId) {
    return activeTickets.any((ticket) => ticket['ticketId'] == ticketId);
  }

  // Get total number of tickets
  int get totalTickets => activeTickets.length + ticketHistory.length;

  // Get active tickets count
  int get activeTicketsCount => activeTickets.length;

  // Get history tickets count
  int get historyTicketsCount => ticketHistory.length;
}