import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const MyListTile(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 48, 48, 48),
        ),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
