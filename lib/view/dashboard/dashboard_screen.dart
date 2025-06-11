import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/event_model.dart';
import '/view_model/dashboard_viewModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedCategory;
  String? selectedLocation;
  DateTime? selectedDate;

  final List<String> locations = [
    'Kuala Lumpur', 'Petaling Jaya', 'Shah Alam', 'Subang Jaya',
    'Putrajaya', 'Cyberjaya', 'George Town', 'Ipoh', 'Johor Bahru',
    'Kota Kinabalu', 'Kuching', 'Alor Setar', 'Melaka', 'Seremban', 'Miri',
    'Sepang'
  ];

  final List<String> categories = ['Concert', 'Festival', 'Sports'];

  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure the widget is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).fetchEvents();
    });
  }

  void _applyFilters() {
    context.read<DashboardViewModel>().filterEvents(
      category: selectedCategory,
      date: selectedDate?.toIso8601String().split('T').first,
      location: selectedLocation,
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedLocation = null;
      selectedDate = null;
    });
    context.read<DashboardViewModel>().clearFilters();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _applyFilters();
      });
    }
  }

  void _pickLocation(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: locations.map((location) => ListTile(
                  title: Text(location),
                  onTap: () => Navigator.pop(context, location),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        selectedLocation = selected;
        _applyFilters();
      });
    }
  }

  void _pickCategory(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categories.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, category),
                  child: Text(category),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        selectedCategory = selected;
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FestQuest'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardViewModel>().fetchEvents();
            },
          ),
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterButton(
                        label: selectedCategory ?? 'Category',
                        isSelected: selectedCategory != null,
                        onPressed: () => _pickCategory(context),
                        icon: Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterButton(
                        label: selectedLocation ?? 'Location',
                        isSelected: selectedLocation != null,
                        onPressed: () => _pickLocation(context),
                        icon: Icons.location_on_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterButton(
                        label: selectedDate != null
                            ? selectedDate!.toIso8601String().split('T').first
                            : 'Date',
                        isSelected: selectedDate != null,
                        onPressed: () => _pickDate(context),
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterButton(
                        label: 'Reset',
                        isSelected: false,
                        onPressed: _resetFilters,
                        icon: Icons.clear_all,
                        isReset: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DashboardViewModel>(
              builder: (context, viewModel, _) {
                // Show loading indicator
                if (viewModel.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading events...'),
                      ],
                    ),
                  );
                }

                // Show error message if any
                if (viewModel.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading events',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            viewModel.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.fetchEvents(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Debug print to check if events are loaded
                print('Total events: ${viewModel.filteredEvents.length}');

                if (viewModel.filteredEvents.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters or check back later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final eventsByCategory = viewModel.groupedByCategory();
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: eventsByCategory.entries.map((entry) {
                    return _buildSection(entry.key, entry.value);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
    required IconData icon,
    bool isReset = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: isReset
            ? Colors.red[600]
            : isSelected
            ? Colors.white
            : Colors.black87,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isReset
              ? Colors.red[600]
              : isSelected
              ? Colors.white
              : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isReset
            ? Colors.red[50]
            : isSelected
            ? Colors.blue[600]
            : Colors.white,
        foregroundColor: isReset
            ? Colors.red[600]
            : isSelected
            ? Colors.white
            : Colors.black87,
        elevation: isSelected ? 2 : 1,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isReset
                ? Colors.red[200]!
                : isSelected
                ? Colors.blue[600]!
                : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${events.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/event_detail',
                  arguments: event,
                ),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: event.poster.isNotEmpty
                              ? Image.network(
                            event.poster,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.event,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  event.date,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}