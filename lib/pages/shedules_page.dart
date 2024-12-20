import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_schedule_tile.dart';
import 'package:pet_care_manager/models/schedule.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:provider/provider.dart';

class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Schedule Tiles
            SizedBox(
              height: 550,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.email.toString())
                    .collection('Schedules')
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
                      Timestamp stamp = snapshot.data!.docs[index]["dateTime"];
                      // Get Individual Schedule
                      Schedule schedule = Schedule(
                        dateTime: stamp.toDate(),
                        petName: snapshot.data!.docs[index]["petName"],
                        title: snapshot.data!.docs[index]["title"],
                        location: snapshot.data!.docs[index]["location"],
                      );
                      context.read<SchedulesList>().list.add(schedule);
                      // Return as Schedule Tile
                      return MyScheduleTile(schedule: schedule);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: MyButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/schedule_add_page');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
