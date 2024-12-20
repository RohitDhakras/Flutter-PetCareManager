import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/schedule.dart';

class SchedulesList extends ChangeNotifier {
  // User
  final user = FirebaseAuth.instance.currentUser;

  // Schedules List
  final List<Schedule> _list = [];

  // Get Schedules List
  List<Schedule> get list => _list;

  // Add Schedule to the List
  void addSchedule(Schedule schedule) async {
    _list.add(schedule);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Schedules')
        .add({
      'dateTime': schedule.dateTime,
      'petName': schedule.petName,
      'title': schedule.title,
      'location': schedule.location,
    });
    notifyListeners();
  }

  // Remove Schedule to the List
  void removeSchedule(Schedule schedule) {
    _list.remove(schedule);
    notifyListeners();
  }
}
