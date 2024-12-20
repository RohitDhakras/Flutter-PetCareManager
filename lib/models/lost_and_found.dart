import 'package:pet_care_manager/models/pet.dart';

class LostAndFound {
  String userName;
  String userEmail;
  Pet pet;
  DateTime missingDate;
  String phoneNumber;
  String message;

  LostAndFound({
    required this.userName,
    required this.userEmail,
    required this.pet,
    required this.missingDate,
    required this.phoneNumber,
    required this.message,
  });
}
