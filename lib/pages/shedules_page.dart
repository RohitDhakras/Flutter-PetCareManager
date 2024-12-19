import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/components/my_drawer.dart';
import 'package:pet_care_manager/components/my_schedule_tile.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:provider/provider.dart';

class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<SchedulesList>().list;
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Schedule Tiles
            SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: schedules.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  // Get Individual Schedule
                  final schedule = schedules[index];

                  // Return as Schedule Tile
                  return MyScheduleTile(schedule: schedule);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: MyButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/schedule_add_page');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
