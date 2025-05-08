import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_viewModel.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: BackButton(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: vm.setUsername,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Profile Name'),
              onChanged: vm.setProfileName,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: vm.setEmail,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: vm.setPhoneNum,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: vm.setPassword,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              onChanged: vm.setConfirmPassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await vm.register();
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
