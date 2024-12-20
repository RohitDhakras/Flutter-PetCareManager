import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/pet.dart';

class PetsList extends ChangeNotifier {
  // User
  final user = FirebaseAuth.instance.currentUser;

  // User's Pets List
  final List<Pet> _list = [];

  // Get a list of User's Pets
  List<Pet> get list => _list;

  // Add Pet to List
  void addPet(Pet pet) async {
    _list.add(pet);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Pets')
        .doc(pet.name)
        .set({
      'name': pet.name,
      'animal_type': pet.animalType,
      'breed': pet.breed,
      'age': pet.age,
    });
    notifyListeners();
  }

  // Remove Pet from List
  void removePet(Pet pet) {
    _list.remove(pet);
    notifyListeners();
  }
}
