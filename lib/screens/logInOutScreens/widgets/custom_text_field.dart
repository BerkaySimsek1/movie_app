import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController tfUsername,
    required this.keyboardType,
    required this.obscure,
    required this.text,
  })  : _tfUsername = tfUsername,
        super(key: key);

  final TextEditingController _tfUsername;
  final TextInputType keyboardType;
  final bool obscure;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _tfUsername,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(hintText: text),
    );
  }
}
