import 'package:festquest/view/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:festquest/view_model/profile_viewModel.dart';
import 'package:festquest/services/shared_preference.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    await vm.loadUserData();
    setState(() => isLoading = false);
  }

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
          Center(child: Text(vm.user!.name)),
          Center(child: Text(vm.user!.phone)),
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
          ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await SharedPreferenceHelper().clearPrefs();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete My Account'),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("This will permanently delete your account."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                  ],
                ),
              );

              if (confirm == true) {
                await vm.deleteAccount();
              }
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