import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/dashboard_viewModel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FestQuest'),
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
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSection(title: 'Recommended', itemCount: 5),
          _buildSection(title: 'Concert', itemCount: 5),
          _buildSection(title: 'Event', itemCount: 5),
          _buildSection(title: 'Sports', itemCount: 5),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required int itemCount}) {
    final bool isRecommended = title == 'Recommended';

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ),
      ],
    );

    return isRecommended
        ? Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: content,
    )
        : content;
  }
}
