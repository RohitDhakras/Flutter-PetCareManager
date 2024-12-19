import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/pet.dart';

class PetsList extends ChangeNotifier {
  // User's Pets List
  final List<Pet> _list = [
    Pet(name: 'Rocky', animalType: 'Dog', breed: 'German Shephard', age: 5),
    Pet(name: 'Cooper', animalType: 'Dog', breed: 'Golden Retriever', age: 6),
    Pet(name: 'Bella', animalType: 'Cat', breed: 'Persian Cat', age: 4),
  ];

  // Get a list of User's Pets
  List<Pet> get list => _list;

  // Add Pet to List
  void addPet(Pet pet) {
    _list.add(pet);
    notifyListeners();
  }

  // Remove Pet from List
  void removePet(Pet pet) {
    _list.remove(pet);
    notifyListeners();
  }
}
