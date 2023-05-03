// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  late final Color colour;
  late final String title;
  late final VoidCallback onPressed;

  RoundedButton(
      {super.key, required this.colour, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: colour,
        child: MaterialButton(
          minWidth: 300.0,
          height: 42.0,
          onPressed: onPressed,
          child: Text(
            title,
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
