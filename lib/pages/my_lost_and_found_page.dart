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

class MyLostAndFoundPage extends StatefulWidget {
  const MyLostAndFoundPage({super.key});

  @override
  State<MyLostAndFoundPage> createState() => _MyLostAndFoundPageState();
}

class _MyLostAndFoundPageState extends State<MyLostAndFoundPage> {
  var user = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
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
              'Missing Pet Reports',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 550,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection('Reports')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('An Error Occured');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      Timestamp stamp =
                          snapshot.data!.docs[index]['missingDate'];
                      // Get Individual Report
                      LostAndFound report = LostAndFound(
                        userName: snapshot.data!.docs[index]['userName'],
                        userEmail: snapshot.data!.docs[index]['userEmail'],
                        pet: Pet(
                          name: snapshot.data!.docs[index]['pet']['petName'],
                          animalType: snapshot.data!.docs[index]['pet']
                              ['animal_type'],
                          breed: snapshot.data!.docs[index]['pet']['breed'],
                          age: snapshot.data!.docs[index]['pet']['age'],
                        ),
                        missingDate: stamp.toDate(),
                        phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                        message: snapshot.data!.docs[index]['message'],
                      );

                      context.read<LostAndFoundList>().list.add(report);

                      // Return as Lost And Found Tile
                      return MyLostAndFoundTile(report: report);
                    },
                  );
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