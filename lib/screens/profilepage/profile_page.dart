import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';

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
    getUsername();

    super.initState();
  }

  Future<void> getUsername() async {
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
                pages: '/comments', text: 'Profile', isLogOut: false),
            CustomElevatedButton(
                pages: '/comments', text: 'Comments', isLogOut: false),
            CustomElevatedButton(
                pages: '/comments', text: 'Settings', isLogOut: false),
            CustomElevatedButton(
                pages: '/login', text: 'Log out', isLogOut: true)
          ],
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {Key? key,
      required this.pages,
      required this.text,
      required this.isLogOut})
      : super(key: key);
  String pages, text;
  bool isLogOut;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 175,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              isLogOut
                  ? {
                      Navigator.pushReplacementNamed(context, pages),
                      Auth().logOut()
                    }
                  : Navigator.pushNamed(context, pages);
            },
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            )),
      ),
    );
  }
}
