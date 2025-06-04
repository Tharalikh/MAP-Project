import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/createEvent_viewModel.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateEventViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: vm.setTitle,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: vm.setDescription,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Date (e.g., 2025-06-30)'),
              onChanged: vm.setDate,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Time (e.g., 18:00)'),
              onChanged: vm.setTime,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: vm.setPrice,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: vm.setLocation,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Poster URL or Path'),
              onChanged: vm.setPoster,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'concert', child: Text('Concert')),
                DropdownMenuItem(value: 'event', child: Text('Gathering')),
                DropdownMenuItem(value: 'sport', child: Text('Sport')),
                DropdownMenuItem(value: 'seminar', child: Text('Seminar'))
              ],
              onChanged: (value) => vm.setCategory(value ?? ''),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await vm.saveEvent();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event saved successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save event')),
                  );
                }
              },
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
