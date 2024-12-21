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

  // Get Schedules List
  void getSchedules() async {
    _list.clear();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Schedules')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        Timestamp stamp = doc.data()['dateTime'];
        Schedule schedule = Schedule(
          dateTime: stamp.toDate(),
          petName: doc.data()['petName'],
          title: doc.data()['title'],
          location: doc.data()['location'],
        );
        _list.add(schedule);
        print(_list);
      }
    });
  }

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
  void removeSchedule(Schedule schedule) async {
    _list.remove(schedule);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Schedules')
        .where('dateTime', isEqualTo: schedule.dateTime)
        .where('petName', isEqualTo: schedule.petName)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    notifyListeners();
  }

  // Update Schedule to the List
  void updateSchedule(Schedule prev, Schedule schedule) async {
    var index = _list.indexOf(prev);
    _list[index] = schedule;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('Schedules')
        .where('dateTime', isEqualTo: prev.dateTime)
        .where('petName', isEqualTo: prev.petName)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.set({
          'dateTime': schedule.dateTime,
          'petName': schedule.petName,
          'title': schedule.title,
          'location': schedule.location,
        });
      }
    });
    notifyListeners();
  }
}
