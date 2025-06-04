import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/forgot_viewModel.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We'll send a password reset link to your email.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: vm.setEmail,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (vm.email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your email")),
                  );
                  return;
                }

                final error = await vm.sendResetEmail();
                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reset email sent!")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              child: const Text("Send Reset Email"),
            ),
          ],
        ),
      ),
    );
  }
}
