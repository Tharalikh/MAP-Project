import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_viewModel.dart';

class ForgotpassScreen extends StatelessWidget {
  const ForgotpassScreen({super.key});

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
            ),
          ],
        ),
      ),
    );
  }
}
