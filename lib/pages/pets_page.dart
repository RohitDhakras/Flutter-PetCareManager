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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.email.toString())
                    .collection('Pets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
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
                      Pet pet = Pet(
                        name: snapshot.data!.docs[index]["name"],
                        animalType: snapshot.data!.docs[index]["animal_type"],
                        breed: snapshot.data!.docs[index]["breed"],
                        age: snapshot.data!.docs[index]["age"],
                      );
                      context.read<PetsList>().list.add(pet);
                      return MyPetTile(pet: pet);
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
