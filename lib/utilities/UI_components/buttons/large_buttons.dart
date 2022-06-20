import 'package:flutter/material.dart';

typedef ButtonCallback = void Function();

class LargePrimaryButton extends StatelessWidget {
  const LargePrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final ButtonCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFFffffff)),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 4,
          primary: const Color(0xFF7f3dff),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}

class LargeSecondaryButton extends StatelessWidget {
  const LargeSecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final ButtonCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7f3dff)),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 4,
          primary: const Color(0xFF7F3DFF),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
