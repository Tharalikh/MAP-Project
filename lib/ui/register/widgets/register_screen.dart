import '../../../data/services/user_service.dart';
import '../../login/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../../../data/services/shared_preference.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
  }

  class _RegisterState extends State<RegisterScreen> {
  String username = '', profileName = '', email = '', phoneNum = '', password = '', confirmPassword = '';
  TextEditingController usernameController = new TextEditingController();
  TextEditingController profileNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  registration() async {
    print('==> registration() called');
    print('email: $email');
    print('password: $password');

    if (password != null &&
        confirmPassword == password  &&
        usernameController.text != "" &&
        profileNameController.text != "" &&
        emailController.text != "" &&
        phoneNumController.text != ""
    ) try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String id = randomAlphaNumeric(10);
      Map<String, dynamic> userMap = {
        "username": usernameController.text,
        "profileName": profileNameController.text,
        "email": emailController.text,
        "phoneNum": phoneNumController.text,
        "id": id,
      };
      await SharedPreferenceHelper().saveUsername(usernameController.text);
      await SharedPreferenceHelper().saveName(profileNameController.text);
      await SharedPreferenceHelper().saveEmail(emailController.text);
      await SharedPreferenceHelper().savePhone(phoneNumController.text);
      await SharedPreferenceHelper().saveUserId(id);
      await UserService().addUserInfo(userMap, id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(
            "Registered Successfully",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (builder)=> LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Password is too weak",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Email is already in use",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Align(alignment: Alignment.topLeft, child: BackButton()),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: profileNameController,
              decoration: const InputDecoration(labelText: 'Profile Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                email = emailController.text.trim();
                password = passwordController.text;

                if (usernameController.text.isEmpty ||
                    profileNameController.text.isEmpty ||
                    email.isEmpty ||
                    phoneNumController.text.isEmpty ||
                    password.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                confirmPassword = confirmPasswordController.text;
                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }
                registration(); // only called if all valid
              },
              child: Center(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 104, 189, 200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: Text(
                        "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
