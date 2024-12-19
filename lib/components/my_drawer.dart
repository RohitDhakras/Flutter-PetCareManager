import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 239, 239),
                ),
                child: Center(
                  child: Icon(
                    Icons.pets_outlined,
                    size: 48,
                    color: const Color.fromARGB(255, 155, 155, 155),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              MyListTile(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home_page');
                },
              ),

              MyListTile(
                icon: Icons.pets_outlined,
                text: 'My Pets',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/pets_page');
                },
              ),

              MyListTile(
                icon: Icons.schedule_outlined,
                text: 'Schedules',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/schedules_page');
                },
              ),
            ],
          ),

          // Exit
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: MyListTile(
                icon: Icons.exit_to_app,
                text: 'Exit',
                onTap: () {
                  // Pop
                  Navigator.pop(context);
                  // Navigate
                  Navigator.pushNamed(context, 'intro_page');
                }),
          )
        ],
      ),
    );
  }
}
