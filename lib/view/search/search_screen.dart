import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/search_viewModel.dart';
import '../../model/event_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onChanged: (query) {
            vm.updateSearchQuery(query);
          },
        ),
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
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(vm.selectedCity),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    // Show city change logic (modal or dropdown)
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: vm.filteredEvents.isEmpty
                ? const Center(child: Text('No events found.'))
                : ListView.builder(
              itemCount: vm.filteredEvents.length,
              itemBuilder: (context, index) {
                final event = vm.filteredEvents[index];
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.date),
                  // Add more fields as you wish
                  onTap: () => Navigator.pushNamed (
                    context,
                    '/event_detail',
                    arguments: event.id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
