import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/model/Event/event_model.dart';
import '../../ticket/view_model/my_event_viewModel.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String title = '', date = '', location = '', price = '';
  TextEditingController titleController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  event() async {
    if (titleController.text.isEmpty &&
        dateController.text.isEmpty &&
        locationController.text.isEmpty &&
        priceController.text.isEmpty)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
  }
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  File? _posterImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _posterImage = File(picked.path);
      });
    }
  }

  void _uploadEvent() {
    if (_formKey.currentState!.validate() && _posterImage != null) {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        date: _dateController.text,
        location: _locationController.text,
        price: double.parse(_priceController.text),
        posterPath: _posterImage, // ✅ Add this field to Event model
      );

      // ✅ Add this to your ViewModel
      // (Assuming you’ve registered MyEventsViewModel globally)
      Provider.of<MyEventsViewModel>(context, listen: false).addEvent(newEvent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event submitted successfully!")),
      );

      _formKey.currentState!.reset();
      setState(() => _posterImage = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload an image.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Your Event")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _posterImage == null
                    ? Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Tap to upload poster")),
                )
                    : Image.file(_posterImage!, height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Event Title"),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "Date (e.g. 2025-12-31)"),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadEvent,
                child: const Text("Upload Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
