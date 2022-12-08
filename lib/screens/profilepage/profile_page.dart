import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/profilepage/widgets/customProfilePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String profilePic = '';
  @override
  void initState() {
    getUsernameAndPhoto();

    super.initState();
  }

  Future<void> getUsernameAndPhoto() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Auth().currentuser!.uid)
        .get()
        .then((value) {
      username = value.data()!["username"];
      profilePic = value.data()!["profilePhoto"];
    });
    Future.delayed(const Duration(microseconds: 1));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profilePic == ''
                ? Text('')
                : SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          profilePic,
                          fit: BoxFit.cover,
                        )),
                  ),
            Text(
              username,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            CustomElevatedButton(
                pages: '/comments', text: 'Comments', isLogOut: false),
            CustomElevatedButton(
                pages: '/login', text: 'Log out', isLogOut: true),
          ],
        ),
      ),
    );
  }
}
