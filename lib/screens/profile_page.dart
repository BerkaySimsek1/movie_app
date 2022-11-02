import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text("Pic"),
              ),
            ),
            const Text("Username"),
            ElevatedButton(onPressed: () {}, child: const Text("Profile")),
            ElevatedButton(onPressed: () {}, child: const Text("Favorite")),
            ElevatedButton(onPressed: () {}, child: const Text("Settings")),
            ElevatedButton(
                onPressed: () {
                  Auth().logOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text("Log out")),
          ],
        ),
      ),
    );
  }
}
