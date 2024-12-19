import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [],
      ),
    );
  }
}
