import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_lost_and_found_tile.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';
import 'package:pet_care_manager/models/lost_and_found_list.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:provider/provider.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  var user = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<LostAndFoundList>().list;
    final nonUserReports =
        reports.where((report) => report.userEmail != user).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost And Found Reports'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35),
            MyButton(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/my_lost_and_found_page');
              },
              child: Text('My Lost And Found Reports'),
            ),
            const SizedBox(height: 35),
            Text(
              'Lost And Found Reports',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: nonUserReports.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  // Get Individual Report
                  LostAndFound report = nonUserReports[index];

                  // Return as Lost And Found Tile
                  return MyLostAndFoundTile(report: report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
