import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/createEvent_viewModel.dart';
import '../../view_model/my_event_viewModel.dart';
import '../../view_model/dashboard_viewModel.dart';
import '../../model/event_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _posterController = TextEditingController();

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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _posterController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
            // Use the fixed categories list with validation
            ...categories.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ensure we only return valid categories
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

    // Additional validation when setting the selected category
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

  // Validate category before saving
  bool _isValidCategory(String? category) {
    return category != null && categories.contains(category);
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    // Enhanced category validation
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

    // Set the form data in the view model with additional validation
    createEventVM.setTitle(_titleController.text.trim());
    createEventVM.setDescription(_descriptionController.text.trim());
    createEventVM.setDate(_formatDate(selectedDate!));
    createEventVM.setTime(_formatTime(selectedTime!));
    createEventVM.setPrice(_priceController.text.trim());
    createEventVM.setLocation(selectedLocation!);
    createEventVM.setPoster(_posterController.text.trim());

    // Ensure category is exactly one of the allowed values with proper capitalization
    String validatedCategory = selectedCategory!;

    // Find the correctly capitalized version
    for (String correctCategory in categories) {
      if (correctCategory.toLowerCase() == selectedCategory!.toLowerCase()) {
        validatedCategory = correctCategory;
        break;
      }
    }

    print("Original category: '$selectedCategory'");
    print("Validated category: '$validatedCategory'");

    createEventVM.setCategory(validatedCategory);

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Save to Firebase
      final success = await createEventVM.saveEvent();

      Navigator.of(context).pop(); // Close loading dialog

      if (success) {
        // Refresh dashboard to show new event
        await dashboardVM.fetchEvents();

        // Refresh my events to show new event
        await myEventsVM.fetchMyEvents();

        // Return success result
        Navigator.of(context).pop(true);

        _showSnackBar("Event created successfully!", Colors.green);
      } else {
        _showSnackBar("Failed to create event. Please try again.", Colors.red);
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
        title: const Text("Create Event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
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

              // Category Selection with validation indicator
              InkWell(
                onTap: _selectCategory,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isValidCategory(selectedCategory) ? Colors.grey : Colors.red.shade300,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: selectedCategory != null ? _getCategoryColor(selectedCategory!).withOpacity(0.1) : null,
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
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                dropdownColor: Colors.white,
                menuMaxHeight: 300,
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

              // Price
              TextFormField(
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

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Create Event",
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
      ),
    );
  }
}