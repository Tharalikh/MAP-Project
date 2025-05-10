import 'dart:math';
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
          _buildSection(context, title: 'Recommended', itemCount: 5),
          _buildSection(context, title: 'Concert', itemCount: 5),
          _buildSection(context, title: 'Event', itemCount: 5),
          _buildSection(context, title: 'Sports', itemCount: 5),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required int itemCount}) {
    final bool isRecommended = title == 'Recommended';
    final List<String> posters = List.generate(15, (index) => 'assets/images/${index + 1}.png');
    final random = Random();

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
              final imagePath = posters[random.nextInt(posters.length)];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/event_detail', arguments: index);
                },
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
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
