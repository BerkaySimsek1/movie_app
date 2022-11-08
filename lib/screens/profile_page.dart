import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/commentScreen.dart';
import 'package:movie_app/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  Future<void> getUsername() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Auth().currentuser!.uid)
        .get()
        .then((value) => username = value.data()!["username"]);
    Future.delayed(const Duration(microseconds: 1));
    setState(() {});
  }

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
            Text(username),
            ElevatedButton(onPressed: () {}, child: const Text("Profile")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileCommentPage(),
                      ));
                },
                child: const Text("Comments")),
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
