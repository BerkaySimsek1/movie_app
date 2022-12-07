import 'package:flutter/material.dart';

class customPP extends StatelessWidget {
  const customPP({
    Key? key,
    required this.photoPath,
  }) : super(key: key);

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        photoPath,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}
