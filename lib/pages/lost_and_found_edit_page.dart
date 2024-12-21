import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';
import 'package:pet_care_manager/models/lost_and_found_list.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:provider/provider.dart';

class LostAndFoundEditPage extends StatefulWidget {
  final LostAndFound report;
  const LostAndFoundEditPage({super.key, required this.report});

  @override
  State<LostAndFoundEditPage> createState() => _LostAndFoundEditPageState();
}

class _LostAndFoundEditPageState extends State<LostAndFoundEditPage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  // Controllers
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime? date;
  Pet? pet;
  String userName = "";

  void getUserName() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmail)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          userName = doc.data()!['userName'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    petNameController.text = widget.report.pet.name;
    dateController.text =
        DateFormat('dd-MM-yyyy').format(widget.report.missingDate);
    phoneNumberController.text = widget.report.phoneNumber;
    messageController.text = widget.report.message;
    pet = Pet(
        name: widget.report.pet.name,
        animalType: widget.report.pet.animalType,
        breed: widget.report.pet.breed,
        age: widget.report.pet.age);
    date = widget.report.missingDate;
  }

  @override
  Widget build(BuildContext context) {
    // Key
    final formKey = GlobalKey<FormState>();
    final pets = context.watch<PetsList>().list;
    pet = pets.firstWhere((p) => p.name == pet!.name);

    void updateReport() {
      if (formKey.currentState!.validate() && date != null && pet != null) {
        LostAndFound newReport = LostAndFound(
          userName: userName,
          userEmail: userEmail!,
          pet: pet!,
          missingDate: date!,
          phoneNumber: phoneNumberController.text,
          message: messageController.text,
        );
        context
            .read<LostAndFoundList>()
            .updateLostAndFoundReport(widget.report, newReport);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/my_lost_and_found_page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lost And Found Report'),
      ),
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                'Edit Report',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 35),

              // Fields
              // Pet Name
              DropdownButtonFormField(
                value: pet,
                items: List.generate(
                  pets.length,
                  (index) {
                    return DropdownMenuItem(
                      value: pets[index],
                      child: Text(pets[index].name),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    pet = value;
                    petNameController.text = value!.name;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter a Pet Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Missing Date
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.blue, // header background color
                            onPrimary: Colors.white, // header text color
                            onSurface: Colors.black, // body text color
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    dateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    date = pickedDate;
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText: "Select Date",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Message
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Phone Number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 15),

              // Message
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Delete Button
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LostAndFoundList>()
                          .removeLostAndFoundReport(widget.report);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/my_lost_and_found_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Color.fromARGB(255, 54, 54, 54),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Update Button
                  ElevatedButton(
                    onPressed: updateReport, // Add Schedule to List
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 57, 57, 57),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
