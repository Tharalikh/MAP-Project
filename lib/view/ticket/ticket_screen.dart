import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'active_ticket_view_screen.dart';
import 'history_ticket_view_screen.dart';
import '../../view_model/ticket_viewModel.dart';
import '../../model/ticket_model.dart';

class TicketScreen extends StatefulWidget {
  final int initialTabIndex;
  const TicketScreen({super.key, this.initialTabIndex = 0});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewModel>(context, listen: false).loadUserTickets();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TicketViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ticket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(context, '/notification'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Ticket'),
            Tab(text: 'Ticket History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTickets(
            context,
            vm.activeTickets,
            "No active tickets found.",
            isActiveTab: true,
          ),
          _buildTickets(
            context,
            vm.historyTickets,
            "No history tickets yet.",
            isActiveTab: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTickets(
      BuildContext context,
      List<TicketModel> tickets,
      String emptyText, {
        required bool isActiveTab,
      }) {
    final vm = Provider.of<TicketViewModel>(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tickets.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Poster image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ticket.poster.isNotEmpty
                      ? Image.network(
                    ticket.poster,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 60),
                  )
                      : Container(
                    color: Colors.grey[300],
                    height: 80,
                    width: 80,
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),

                // Ticket details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(child: Text(ticket.location, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('RM${ticket.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green)),
                      Text('${ticket.date} ${ticket.time}'),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // View button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isActiveTab
                            ? ActiveTicketScreen(ticket: ticket)
                            : HistoryTicketScreen(ticket: ticket),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("View Ticket"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
