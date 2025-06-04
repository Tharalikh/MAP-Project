import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/login_viewModel.dart';
import '../../view_model/profile_viewModel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('FestQuest', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: vm.setUsername,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: vm.setPassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await vm.login();
                if (user != null) {
                  // Update the profile user
                  final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
                  profileVM.updateUser(user);

                  Navigator.pushNamed(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text(
                "Don’t have account?",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot'),
              child: const Text(
                "Forgot password?",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
