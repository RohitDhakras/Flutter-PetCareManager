import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';

class LostAndFoundList extends ChangeNotifier {
  // User
  final user = FirebaseAuth.instance.currentUser;

  // Lost and Found List
  final List<LostAndFound> _list = [];

  // Get Lost and Found List
  List<LostAndFound> get list => _list;

  void addToList(var list) {
    for (var item in list) {
      _list.add(item);
    }
  }

  // Add Lost and Found Report
  void addLostAndFoundReport(LostAndFound report) async {
    _list.add(report);
    final data = {
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
    };
    await FirebaseFirestore.instance.collection('Lost And Found').add(data);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Reports')
        .add(data);
    notifyListeners();
  }

  // Remove Lost and Found Report
  void removeLostAndFoundReport(LostAndFound report) {
    _list.remove(report);
    notifyListeners();
  }
}
