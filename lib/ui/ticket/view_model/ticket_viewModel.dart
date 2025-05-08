import 'package:flutter/material.dart';

class TicketViewModel extends ChangeNotifier {
  List<Map<String, String>> activeTickets = [
    {
      'name': 'Music Fest',
      'location': 'Dewan Raya',
      'amount': 'RM120',
      'date': 'May 10',
    },
  ];

  List<Map<String, String>> ticketHistory = [
    {
      'name': 'Pop Night',
      'location': 'Open Air',
      'amount': 'RM80',
      'date': 'April 5',
    },
  ];
}
