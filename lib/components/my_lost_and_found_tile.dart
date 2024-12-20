import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';

class MyLostAndFoundTile extends StatelessWidget {
  final LostAndFound report;
  const MyLostAndFoundTile({super.key, required this.report});

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
        child: Column(
          children: [
            // Owner's Name
            Center(
              child: Text(
                'Missing ${report.pet.animalType}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Center(
                  child: Text('Image'),
                ),
                SizedBox(width: 30),

                // Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet's name
                    Text(
                      'Pet Name : ${report.pet.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Animal
                    Text(
                      'Animal : ${report.pet.animalType}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Breed
                    Text(
                      'Breed : ${report.pet.breed}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Pet's Age
                    Text(
                      'Pet\'s Age : ${report.pet.age}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Owner's Name
                    Text(
                      'Owner Name : ${report.userName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Owner's Email
                    Text(
                      'Owner Email : ${report.userEmail}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Center(
              child: Text(
                report.message,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
