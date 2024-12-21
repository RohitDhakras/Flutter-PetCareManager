import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_pet_tile.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:provider/provider.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetsList>().list;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pet Tiles
            SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: pets.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  // Get Individual Schedule
                  Pet pet = pets[index];
                  // Return as Pet Tile
                  return MyPetTile(pet: pet);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MyButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/pet_add_page');
        },
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
    );
  }
}
