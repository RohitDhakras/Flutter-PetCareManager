import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_schedule_tile.dart';
import 'package:pet_care_manager/models/lost_and_found_list.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      context.read<PetsList>().getPets();
      context.read<SchedulesList>().getSchedules();
      context.read<LostAndFoundList>().getLostAndFoundReports();

      _isInitialized = true; // Prevent multiple calls to the fetch logic
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedules = context.read<SchedulesList>().list;
    final now = DateTime.now();
    final todaySchedules = schedules
        .where((schedule) => (schedule.dateTime.year == now.year &&
            schedule.dateTime.month == now.month &&
            schedule.dateTime.day == now.day))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 600,
        child: Column(
          children: [
            SizedBox(height: 25),
            const Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: todaySchedules.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  return MyScheduleTile(schedule: todaySchedules[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
