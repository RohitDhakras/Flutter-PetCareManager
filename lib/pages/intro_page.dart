import 'package:flutter/material.dart';
import 'package:pet_care_manager/components/my_button.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Pet Care Manager',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            MyButton(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/login_page'),
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
