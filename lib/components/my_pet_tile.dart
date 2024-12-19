import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:provider/provider.dart';

class MyPetTile extends StatelessWidget {
  final Pet pet;
  const MyPetTile({super.key, required this.pet});

  // Add to List
  void addPet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Add Pet to my Pets List'),
        actions: [
          // Cancel Button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),

          // Yes Button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PetsList>().addPet(pet);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(7),
      padding: EdgeInsets.all(10),
      width: 150,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pet Image
            Text('Image'),
            // AspectRatio(
            //   aspectRatio: 1,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).colorScheme.secondary,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     width: double.infinity,
            //     padding: EdgeInsets.all(25),
            //   ),
            // ),
            const SizedBox(width: 20),

            // Pet Data
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pet Name
                Text(
                  pet.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),

                // Animal Type
                Text(
                  'Animal: ${pet.animalType}',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),

                // Animal Breed
                Text(
                  'Breed: ${pet.breed}',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),

                // Animal Age
                Text(
                  'Age: ${pet.age.toString()}',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
