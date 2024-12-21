import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_lost_and_found_tile.dart';
import 'package:pet_care_manager/components/my_user_lost_and_found_tile.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';
import 'package:pet_care_manager/models/lost_and_found_list.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:provider/provider.dart';

class MyLostAndFoundPage extends StatefulWidget {
  const MyLostAndFoundPage({super.key});

  @override
  State<MyLostAndFoundPage> createState() => _MyLostAndFoundPageState();
}

class _MyLostAndFoundPageState extends State<MyLostAndFoundPage> {
  var user = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<LostAndFoundList>().list;
    final userReports =
        reports.where((report) => report.userEmail == user).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lost And Found Reports'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 35),
            Text(
              'My Missing Pet Reports',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: userReports.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  // Get Individual Report
                  LostAndFound report = userReports[index];

                  // Return as Lost And Found Tile
                  return MyUserLostAndFoundTile(report: report);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MyButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/lost_and_found_add_page');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
