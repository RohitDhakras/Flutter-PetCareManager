import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';
import 'package:pet_care_manager/models/pet.dart';

class LostAndFoundList extends ChangeNotifier {
  // User
  final user = FirebaseAuth.instance.currentUser;

  // Lost and Found List
  final List<LostAndFound> _list = [];

  // Get Lost and Found List
  List<LostAndFound> get list => _list;

  // Get Lost And Found Reports List
  void getLostAndFoundReports() async {
    _list.clear();
    await FirebaseFirestore.instance
        .collection('Lost And Found')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        Timestamp stamp = doc.data()['missingDate'];
        Pet pet = Pet(
          name: doc.data()['pet']['petName'],
          animalType: doc.data()['pet']['animal_type'],
          breed: doc.data()['pet']['breed'],
          age: doc.data()['pet']['age'],
        );
        LostAndFound report = LostAndFound(
          userName: doc.data()['userName'],
          userEmail: doc.data()['userEmail'],
          missingDate: stamp.toDate(),
          pet: pet,
          phoneNumber: doc.data()['phoneNumber'],
          message: doc.data()['message'],
        );
        _list.add(report);
      }
    });
  }

  void addToList(var list) {
    for (var item in list) {
      _list.add(item);
    }
  }

  // Add Lost and Found Report
  void addLostAndFoundReport(LostAndFound report) async {
    _list.add(report);
    await FirebaseFirestore.instance.collection('Lost And Found').add({
      'userName': report.userName,
      'userEmail': report.userEmail,
      'pet': {
        'petName': report.pet.name,
        'animal_type': report.pet.animalType,
        'breed': report.pet.breed,
        'age': report.pet.age,
      },
      'missingDate': report.missingDate,
      'phoneNumber': report.phoneNumber,
      'message': report.message,
    });
    notifyListeners();
  }

  // Remove Lost and Found Report
  void removeLostAndFoundReport(LostAndFound report) async {
    _list.remove(report);
    await FirebaseFirestore.instance
        .collection('Lost And Found')
        .where('userEmail', isEqualTo: user!.email)
        .where('pet.petName', isEqualTo: report.pet.name)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    notifyListeners();
  }

  // Update Lost and Found Report
  void updateLostAndFoundReport(LostAndFound prev, LostAndFound report) async {
    var index = _list.indexOf(prev);
    _list[index] = report;
    await FirebaseFirestore.instance
        .collection('Lost And Found')
        .where('userEmail', isEqualTo: user!.email)
        .where('pet.petName', isEqualTo: prev.pet.name)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.set({
          'userName': report.userName,
          'userEmail': report.userEmail,
          'pet': {
            'petName': report.pet.name,
            'animal_type': report.pet.animalType,
            'breed': report.pet.breed,
            'age': report.pet.age,
          },
          'missingDate': report.missingDate,
          'phoneNumber': report.phoneNumber,
          'message': report.message,
        });
      }
    });
    notifyListeners();
  }
}
