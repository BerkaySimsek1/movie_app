import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/bottom_nav_bar.dart';
import 'package:movie_app/screens/logInOutScreens/sign_up.dart';
import 'package:movie_app/screens/logInOutScreens/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _tfEmail = TextEditingController();
  final TextEditingController _tfPassword = TextEditingController();
  bool isError = false;

  Future<void> login(String email, String password) async {
    await Auth()
        .signIn(email: email, password: password)
        .catchError((error) => isError = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                tfUsername: _tfEmail,
                keyboardType: TextInputType.emailAddress,
                obscure: false,
                text: "Email"),
            CustomTextField(
                tfUsername: _tfPassword,
                keyboardType: TextInputType.text,
                obscure: true,
                text: "Password"),
            ElevatedButton(
                onPressed: () {
                  login(_tfEmail.text, _tfPassword.text).then((value) {
                    if (isError) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Email or password is not correct. Please try again.")));
                      isError = false;
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBar(),
                          ));
                    }
                  });
                },
                child: const Text("Log in")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                    },
                    child: const Text("Sign up."))
              ],
            )
          ],
        ),
      ),
    );
  }
}
