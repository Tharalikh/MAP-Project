import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/ticket_viewModel.dart';
import 'active_ticket_view_screen.dart'; // Import the new screen

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
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.confirmation_number_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isHistory ? 'No ticket history' : 'No active tickets',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHistory
                  ? 'Your completed tickets will appear here'
                  : 'Your purchased tickets will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (_, index) {
        final ticket = tickets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              ticket['name'] ?? 'Event Name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ticket['location'] ?? 'Location not specified',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        ticket['amount'] ?? 'Free',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        ticket['date'] ?? 'Date not specified',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: isHistory
                ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            )
                : ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveTicketViewScreen(ticket: ticket),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'View Ticket',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}