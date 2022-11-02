import 'package:flutter/material.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:movie_app/screens/login_screen.dart';
import 'package:movie_app/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _tfUsername = TextEditingController();
  final TextEditingController _tfEmail = TextEditingController();
  final TextEditingController _tfPassword = TextEditingController();
  final TextEditingController _tfPassword2 = TextEditingController();
  Future<void> singUp(String email, String password, String username) async {
    await Auth().signUp(email: email, password: password, username: username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              text: "Username",
              tfUsername: _tfUsername,
              keyboardType: TextInputType.text,
              obscure: false,
            ),
            CustomTextField(
              text: "Email",
              tfUsername: _tfEmail,
              keyboardType: TextInputType.emailAddress,
              obscure: false,
            ),
            CustomTextField(
              text: "Password",
              tfUsername: _tfPassword,
              keyboardType: TextInputType.text,
              obscure: true,
            ),
            CustomTextField(
              text: "Password",
              tfUsername: _tfPassword2,
              keyboardType: TextInputType.text,
              obscure: true,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_tfPassword.text == _tfPassword2.text) {
                    singUp(_tfEmail.text, _tfPassword.text, _tfUsername.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Passwords are not same, please try again.")));
                  }
                },
                child: const Text("Sign Up")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: const Text("Log in."))
              ],
            )
          ],
        ),
      ),
    );
  }
}
