import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/editProfile_viewModel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final vm = Provider.of<EditProfileViewModel>(context, listen: false);
    await vm.loadCurrentUser();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EditProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 40),
            Text('@${vm.userName}', style: const TextStyle(fontSize: 16)),
            TextField(
              controller: vm.usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: vm.setUserName,
            ),
            TextField(
              controller: vm.profileNameController,
              decoration: const InputDecoration(labelText: 'Profile Name'),
              onChanged: vm.setProfileName,
            ),
            TextField(
              controller: vm.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: vm.setEmail,
            ),
            TextField(
              controller: vm.phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: vm.setPhone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (vm.updateUser() == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields correctly')),
                  );
                  return;
                }

                final success = await vm.updateUser();
                if (success != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Update failed')),
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
