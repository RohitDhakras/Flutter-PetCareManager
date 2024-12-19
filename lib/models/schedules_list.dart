import 'package:flutter/material.dart';
import 'package:pet_care_manager/models/schedule.dart';

class SchedulesList extends ChangeNotifier {
  // Schedules List
  final List<Schedule> _list = [
    Schedule(
        dateTime: DateTime(2024, 12, 27, 17, 30),
        petName: 'Rocky',
        title: 'Vaccination',
        location: 'Kalyan'),
    Schedule(
        dateTime: DateTime(2024, 12, 20, 15, 00),
        petName: 'Bella',
        title: 'Vet Visit',
        location: 'Thane'),
    Schedule(
        dateTime: DateTime(2024, 12, 30, 17, 00),
        petName: 'Cooper',
        title: 'Vet Visit',
        location: 'Mumbai'),
  ];

  // Get Schedules List
  List<Schedule> get list => _list;

  // Add Schedule to the List
  void addSchedule(Schedule schedule) {
    _list.add(schedule);
    notifyListeners();
  }

  // Remove Schedule to the List
  void removeSchedule(Schedule schedule) {
    _list.remove(schedule);
    notifyListeners();
  }
}
