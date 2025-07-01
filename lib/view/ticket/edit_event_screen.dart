import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/createEvent_viewModel.dart';
import '../../view_model/my_event_viewModel.dart';
import '../../view_model/dashboard_viewModel.dart';
import '../../model/event_model.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _posterController = TextEditingController();
  final _capacityController = TextEditingController();

  String? selectedCategory;
  String? selectedLocation;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Fixed categories - exactly 3 as intended (ensure proper capitalization)
  static const List<String> categories = ['Concert', 'Festival', 'Sports'];
  final List<String> locations = [
    'Kuala Lumpur', 'Petaling Jaya', 'Shah Alam', 'Subang Jaya',
    'Putrajaya', 'Cyberjaya', 'George Town', 'Ipoh', 'Johor Bahru',
    'Kota Kinabalu', 'Kuching', 'Alor Setar', 'Melaka', 'Seremban', 'Miri',
    'Sepang'
  ];

  @override
  void initState() {
    super.initState();
    _populateFormWithEventData();
  }

  void _populateFormWithEventData() {
    // Pre-populate form fields with existing event data
    _titleController.text = widget.event.title;
    _descriptionController.text = widget.event.description;
    _priceController.text = widget.event.price;
    _posterController.text = widget.event.poster;
    _capacityController.text = widget.event.capacity.toString();

    selectedCategory = widget.event.category;
    selectedLocation = widget.event.location;

    // Parse date from string (assuming format: YYYY-MM-DD)
    try {
      final dateParts = widget.event.date.split('-');
      if (dateParts.length == 3) {
        selectedDate = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        );
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    // Parse time from string (assuming format: HH:MM)
    try {
      final timeParts = widget.event.time.split(':');
      if (timeParts.length == 2) {
        selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      print('Error parsing time: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _posterController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _selectCategory() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isDismissible: true,
      enableDrag: true,
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
                  onPressed: () {
                    if (categories.contains(category)) {
                      Navigator.pop(context, category);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getCategoryColor(category),
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );

    if (selected != null && categories.contains(selected)) {
      setState(() {
        selectedCategory = selected;
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'concert':
        return Colors.purple;
      case 'festival':
        return Colors.orange;
      case 'sports':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  bool _isValidCategory(String? category) {
    return category != null && categories.contains(category);
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isValidCategory(selectedCategory)) {
      _showSnackBar("Please select a valid category", Colors.red);
      return;
    }
    if (selectedDate == null) {
      _showSnackBar("Please select a date", Colors.red);
      return;
    }
    if (selectedTime == null) {
      _showSnackBar("Please select a time", Colors.red);
      return;
    }

    final createEventVM = Provider.of<CreateEventViewModel>(context, listen: false);
    final myEventsVM = Provider.of<MyEventsViewModel>(context, listen: false);
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);

    // Parse capacity
    final newCapacity = int.tryParse(_capacityController.text.trim()) ?? 0;

    // Get current tickets sold from MyEventsViewModel
    final currentTicketsSold = myEventsVM.ticketCounts[widget.event.id] ?? 0;

    // Validate capacity against current tickets sold
    if (newCapacity < currentTicketsSold) {
      _showSnackBar(
          "Capacity cannot be less than current tickets sold ($currentTicketsSold)",
          Colors.red
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create updated event model
      final updatedEvent = EventModel(
        id: widget.event.id, // Keep the same ID
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _formatDate(selectedDate!),
        time: _formatTime(selectedTime!),
        price: _priceController.text.trim(),
        location: selectedLocation!,
        poster: _posterController.text.trim(),
        category: selectedCategory!,
        creatorId: widget.event.creatorId, // Keep the same creator ID
        capacity: newCapacity,
        bookedCount: currentTicketsSold, // Use current tickets sold
      );

      // Update event using the view model
      final success = await createEventVM.updateEvent(updatedEvent);

      Navigator.of(context).pop(); // Close loading dialog

      if (success) {
        // Refresh dashboard to show updated event
        await dashboardVM.fetchEvents();

        // Refresh my events to show updated event
        await myEventsVM.fetchMyEvents();

        // Return success result
        Navigator.of(context).pop(true);

        _showSnackBar("Event updated successfully!", Colors.green);
      } else {
        _showSnackBar("Failed to update event. Please try again.", Colors.red);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showSnackBar("An error occurred: $e", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Consumer<MyEventsViewModel>(
        builder: (context, myEventsVM, _) {
          // Get current tickets sold from the view model
          final currentTicketsSold = myEventsVM.ticketCounts[widget.event.id] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Event Title *",
                      hintText: "Enter event title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter event title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description *",
                      hintText: "Enter event description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter event description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category Selection
                  InkWell(
                    onTap: _selectCategory,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isValidCategory(selectedCategory) ? Colors.grey : Colors.red.shade300,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: selectedCategory != null ? _getCategoryColor(selectedCategory!).withAlpha((255 * 0.1).round()) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (selectedCategory != null) ...[
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(selectedCategory!),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                selectedCategory ?? "Select Category *",
                                style: TextStyle(
                                  color: selectedCategory != null ? Colors.black : Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: selectedCategory != null ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                              if (selectedCategory != null && _isValidCategory(selectedCategory)) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              ],
                            ],
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    decoration: const InputDecoration(
                      labelText: "Location *",
                      hintText: "Select location",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    items: locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a location";
                      }
                      return null;
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),

                  // Date and Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? _formatDate(selectedDate!)
                                      : "Select Date *",
                                  style: TextStyle(
                                    color: selectedDate != null ? Colors.black : Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: _selectTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedTime != null
                                      ? _formatTime(selectedTime!)
                                      : "Select Time *",
                                  style: TextStyle(
                                    color: selectedTime != null ? Colors.black : Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price and Capacity Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Price (RM) *",
                            hintText: "Enter ticket price",
                            border: OutlineInputBorder(),
                            prefixText: "RM ",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter ticket price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid price";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Capacity *",
                            hintText: "Enter max capacity",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.group),
                            helperStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter capacity";
                            }
                            final capacity = int.tryParse(value);
                            if (capacity == null || capacity <= 0) {
                              return "Please enter a valid capacity";
                            }
                            if (capacity < currentTicketsSold) {
                              return "Cannot be less than tickets sold ($currentTicketsSold)";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Booking Status Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booking Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$currentTicketsSold of ${widget.event.capacity} tickets sold",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Poster URL
                  TextFormField(
                    controller: _posterController,
                    decoration: const InputDecoration(
                      labelText: "Poster Image URL",
                      hintText: "Enter image URL (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _updateEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Update Event",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}