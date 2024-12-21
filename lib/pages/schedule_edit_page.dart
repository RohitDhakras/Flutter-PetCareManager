import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:pet_care_manager/models/schedule.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:provider/provider.dart';

class ScheduleEditPage extends StatefulWidget {
  final Schedule schedule;
  const ScheduleEditPage({super.key, required this.schedule});

  @override
  State<ScheduleEditPage> createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  // Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();
  DateTime? dateTime;
  TimeOfDay? timeOfDay;
  Pet? pet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.schedule.title;
    petNameController.text = widget.schedule.petName;
    locationController.text = widget.schedule.location;
    final tempDateTime = widget.schedule.dateTime;
    dateTime =
        DateTime(tempDateTime.year, tempDateTime.month, tempDateTime.day);
    timeOfDay = TimeOfDay(hour: tempDateTime.hour, minute: tempDateTime.minute);
    dateController.text =
        DateFormat('dd-MM-yyyy').format(widget.schedule.dateTime);
    timeController.text =
        '${timeOfDay!.hour.toString().padLeft(2, '0')}:${timeOfDay!.minute.toString().padLeft(2, '0')}';
    pet = context
        .read<PetsList>()
        .list
        .firstWhere((p) => p.name == widget.schedule.petName);
  }

  @override
  Widget build(BuildContext context) {
    // Key
    final formKey = GlobalKey<FormState>();
    // Pets List
    final pets = context.watch<PetsList>().list;

    void updateSchedule() {
      if (formKey.currentState!.validate()) {
        DateTime newDateTime = DateTime(
          dateTime!.year,
          dateTime!.month,
          dateTime!.day,
          timeOfDay!.hour,
          timeOfDay!.minute,
        );
        final newSchedule = Schedule(
          dateTime: newDateTime,
          petName: petNameController.text,
          title: titleController.text,
          location: locationController.text,
        );
        context
            .read<SchedulesList>()
            .updateSchedule(widget.schedule, newSchedule);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/schedules_page');
      }
    }

    void deleteSchedule() {
      context.read<SchedulesList>().removeSchedule(widget.schedule);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/schedules_page');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Schedule'),
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
                'Edit Schedule',
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
                  // Delete Button
                  ElevatedButton(
                    onPressed: deleteSchedule, // Delete Schedule From List
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
                    onPressed: updateSchedule, // Update Schedule to List
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
