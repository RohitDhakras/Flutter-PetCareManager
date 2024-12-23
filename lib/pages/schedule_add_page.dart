import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:pet_care_manager/models/schedule.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:provider/provider.dart';

class ScheduleAddPage extends StatefulWidget {
  const ScheduleAddPage({super.key});

  @override
  State<ScheduleAddPage> createState() => _ScheduleAddPageState();
}

class _ScheduleAddPageState extends State<ScheduleAddPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  DateTime? dateTime;
  TimeOfDay? timeOfDay;
  Pet? pet;

  @override
  Widget build(BuildContext context) {
    // Key
    final formKey = GlobalKey<FormState>();
    // Controllers
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    // Pets List
    final pets = context.watch<PetsList>().list;
    print(dateTime);

    void addSchedule() {
      if (formKey.currentState!.validate()) {
        DateTime newDateTime = DateTime(
          dateTime!.year,
          dateTime!.month,
          dateTime!.day,
          timeOfDay!.hour,
          timeOfDay!.minute,
        );
        final schedule = Schedule(
          dateTime: newDateTime,
          petName: petNameController.text,
          title: titleController.text,
          location: locationController.text,
        );
        context.read<SchedulesList>().addSchedule(schedule);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/schedules_page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Schedule'),
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
                'Add Schedule',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 35),

              // Fields
              // Date Time Field
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
                    dateTime = pickedDate;
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

              GestureDetector(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: dateTime!.hour,
                      minute: dateTime!.minute,
                    ),
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

                  if (pickedTime != null) {
                    timeController.text =
                        '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                    timeOfDay = pickedTime;
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.timer_outlined),
                      labelText: "Select Time",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

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

              // Title
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Location
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Location';
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
                      Navigator.pushNamed(context, '/schedules_page');
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
                    onPressed: addSchedule, // Add Schedule to List
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
