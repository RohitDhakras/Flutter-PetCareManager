import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const MyButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 211, 211, 211),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
            )),
        padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
        child: child,
      ),
    );
  }
}
