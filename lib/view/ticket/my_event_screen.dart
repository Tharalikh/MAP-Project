import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/event_model.dart';
import '../../view_model/my_event_viewModel.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MyEventsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Events")),
      body: vm.myEvents.isEmpty
          ? const Center(child: Text("You haven't uploaded any events yet."))
          : ListView.builder(
        itemCount: vm.myEvents.length,
        itemBuilder: (context, index) {
          final event = vm.myEvents[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.poster != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    /*child: Image.file(
                      event.poster!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),*/
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("📍 ${event.location}"),
                      Text("📅 ${event.date}"),
                      //Text("🎫 RM ${event.price.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
