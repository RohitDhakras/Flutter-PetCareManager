import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:pet_care_manager/models/schedules_list.dart';
import 'package:pet_care_manager/pages/home.dart';
import 'package:pet_care_manager/pages/intro_page.dart';
import 'package:pet_care_manager/pages/login.dart';
import 'package:pet_care_manager/pages/pet_add_page.dart';
import 'package:pet_care_manager/pages/pets_page.dart';
import 'package:pet_care_manager/pages/schedule_add_page.dart';
import 'package:pet_care_manager/pages/shedules_page.dart';
import 'package:pet_care_manager/pages/signup.dart';
import 'package:pet_care_manager/themes/light_mode.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PetsList(),
        ),
        ChangeNotifierProvider(
          create: (context) => SchedulesList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Care',
        home: IntroPage(),
        theme: lightmode,
        routes: {
          'intro_page': (context) => IntroPage(),
          '/signup_page': (context) => SignupPage(),
          '/login_page': (context) => LoginPage(),
          '/home_page': (context) => HomePage(),
          '/pets_page': (context) => PetsPage(),
          '/pet_add_page': (context) => PetAddPage(),
          '/schedules_page': (context) => SchedulesPage(),
          '/schedule_add_page': (context) => ScheduleAddPage(),
        },
      ),
    );
  }
}
