import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/ticket_viewModel.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TicketViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('My Ticket'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => Navigator.pushNamed(context, '/notification'),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
            const SizedBox(width: 10),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Ticket'),
              Tab(text: 'Ticket History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TicketList(tickets: vm.activeTickets, isHistory: false),
            _TicketList(tickets: vm.ticketHistory, isHistory: true),
          ],
        ),
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final List<Map<String, String>> tickets;
  final bool isHistory;

  const _TicketList({required this.tickets, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (_, index) {
        final ticket = tickets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
            ),
            title: Text(ticket['name'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📍 ${ticket['location']}'),
                Text('🎟️ ${ticket['amount']}'),
                Text('📅 ${ticket['date']}'),
              ],
            ),
            trailing: isHistory
                ? const Text('Completed', style: TextStyle(color: Colors.green))
                : ElevatedButton(
              onPressed: () {},
              child: const Text('View Ticket'),
            ),
          ),
        );
      },
    );
  }
}
