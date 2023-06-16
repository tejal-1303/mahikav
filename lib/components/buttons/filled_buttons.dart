import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xff27374D),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: Color(0xff27374D),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xffDDE6ED),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xff27374D),
            width: 2
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 18,color: Color(0xff27374D)),
        ),
      ),
    );
  }
}
