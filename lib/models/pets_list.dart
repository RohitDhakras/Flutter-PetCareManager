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
  void removePet(Pet pet) async {
    _list.remove(pet);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Pets')
        .doc(pet.name)
        .delete();
    notifyListeners();
  }

  // Update Pet in List
  void updatePet(Pet prev, Pet pet) async {
    final index = _list.indexWhere((pet) => pet.name == prev.name);
    _list[index] = pet;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Pets')
        .doc(prev.name)
        .set({
      'name': pet.name,
      'animal_type': pet.animalType,
      'breed': pet.breed,
      'age': pet.age,
    });
  }
}
