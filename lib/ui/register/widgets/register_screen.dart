import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_viewModel.dart';
import '../../login/widgets/login_screen.dart';

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
            const Align(alignment: Alignment.topLeft, child: BackButton()),
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (val) => vm.updateField(username: val),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Profile Name'),
              onChanged: (val) => vm.updateField(name: val),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (val) => vm.updateField(email: val),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (val) => vm.updateField(phoneNum: val),
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (val) => vm.updateField(password: val),
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              onChanged: (val) => vm.updateField(confirmPassword: val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!vm.validateForm()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid input or password mismatch')),
                  );
                  return;
                }

                final error = await vm.register();
                if (error == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed: $error')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
