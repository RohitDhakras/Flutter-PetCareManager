import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_manager/models/lost_and_found.dart';
import 'package:pet_care_manager/models/lost_and_found_list.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:provider/provider.dart';

class LostAndFoundAddPage extends StatefulWidget {
  const LostAndFoundAddPage({super.key});

  @override
  State<LostAndFoundAddPage> createState() => _LostAndFoundAddPageState();
}

class _LostAndFoundAddPageState extends State<LostAndFoundAddPage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final TextEditingController dateController = TextEditingController();
  DateTime? date;
  Pet? pet;

  @override
  Widget build(BuildContext context) {
    // Key
    final formKey = GlobalKey<FormState>();
    // Controllers
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController petNameController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    final pets = context.watch<PetsList>().list;

    void addReport() {
      if (formKey.currentState!.validate() && date != null && pet != null) {
        LostAndFound report = LostAndFound(
          userName: 'Rohit',
          userEmail: userEmail!,
          pet: pet!,
          missingDate: date!,
          phoneNumber: phoneNumberController.text,
          message: messageController.text,
        );
        context.read<LostAndFoundList>().addLostAndFoundReport(report);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/my_lost_and_found_page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lost ANd Found Report'),
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
                'Add Report',
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
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/my_lost_and_found_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 54, 54, 54),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Add Button
                  ElevatedButton(
                    onPressed: addReport, // Add Schedule to List
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 57, 57, 57),
                    ),
                    child: Text(
                      'Add',
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
