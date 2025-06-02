import 'package:festquest/ui/login/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/profile_viewModel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(30.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/subscription'),
                child: const Text(
                  'Subscription',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/edit_profile'),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const CircleAvatar(radius: 40),
          Center(child: Text(vm.name)),
          Center(child: Text(vm.phone)),
          ListTile(
            leading: Icon(Icons.confirmation_num),
            title: Text('My Ticket'),
            onTap: () {
              Navigator.pushNamed(context, '/ticket');
            },
          ),
          const ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('My Voucher'),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction History'),
          ),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy and Security'),
          ),
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Payment Method'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create_event');
            },
            child: const Text("Have an event?"),
          ),
        ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
