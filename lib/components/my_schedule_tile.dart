import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/schedule.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_manager/pages/schedule_edit_page.dart';

class MyScheduleTile extends StatelessWidget {
  final Schedule schedule;
  const MyScheduleTile({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(top: 7, bottom: 7, left: 3, right: 3),
      padding: EdgeInsets.all(10),
      width: 150,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time
                Text(
                  DateFormat('EEE, d/M/y').format(schedule.dateTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Reason
                Text(
                  schedule.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(width: 40),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet
                Row(
                  children: [
                    Text(
                      'Pet : ${schedule.petName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        print(schedule);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScheduleEditPage(schedule: schedule),
                          ),
                        );
                      },
                      child: Icon(Icons.edit),
                    )
                  ],
                ),

                // Date and Time
                Text(
                  'Time : ${DateFormat.jm().format(schedule.dateTime)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Location
                Text(
                  'Location : ${schedule.location}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
