import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/editProfile_viewModel.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EditProfileViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Align(alignment: Alignment.topLeft, child: BackButton()),
            const CircleAvatar(radius: 40),
            const Text('@username'),
            TextField(
              decoration: const InputDecoration(labelText: 'Profile Name'),
              onChanged: vm.setProfileName,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'IC/Passport Number'),
              onChanged: vm.setIcPassport,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: vm.setEmail,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: vm.setPhone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (vm.saveProfile()) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields correctly')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
