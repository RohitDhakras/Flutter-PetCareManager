import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pet_care_manager/components/my_button.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:pet_care_manager/pages/pet_edit_page.dart';
import 'package:provider/provider.dart';

class PetProfilePage extends StatefulWidget {
  final Pet pet;
  const PetProfilePage({super.key, required this.pet});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final user = FirebaseAuth.instance.currentUser!.email.toString();
  final Gemini gemini = Gemini.instance;
  var dietPlan = "";
  var exercisePlan = "";
  String type = 'diet';
  String planResponse = "";
  bool showResponse = false;

  Future<void> getPetData() async {
    try {
      // Fetch the pet document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user)
          .collection('Pets')
          .doc(widget.pet.name)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            dietPlan = doc.data()!['dietPlan'];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> savePetData() async {
    if (type == 'diet') {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user)
          .collection('Pets')
          .doc(widget.pet.name)
          .update({
        'dietPlan': dietPlan,
      });
    } else if (type == 'exercise') {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user)
          .collection('Pets')
          .doc(widget.pet.name)
          .update({
        'exercisePlan': exercisePlan,
      });
    }
  }

  String _cleanResponse(List<dynamic>? parts) {
    if (parts == null) return "";

    return parts
        .map((part) {
          String text = part.text ?? '';
          return text.replaceAll(RegExp(r'\|~|\[.?\]'), '').trim();
        })
        .join(" ")
        .trim();
  }

  void generateResponse() {
    final String question =
        "Give a single short daily $type Plan for a ${widget.pet.animalType} of breed ${widget.pet.breed} and age ${widget.pet.age} years.";
    StringBuffer responseBuffer = StringBuffer();
    gemini.streamChat([
      Content(parts: [Part.text(question)]),
    ]).listen((response) {
      if (response.content?.parts != null) {
        final cleanResponse = _cleanResponse(response.content?.parts);
        responseBuffer.write(cleanResponse);
        setState(() {
          planResponse = responseBuffer.toString().trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getPetData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profile'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Image'),
                  SizedBox(width: 20),
                  Text(
                    widget.pet.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name : ${widget.pet.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Animal : ${widget.pet.animalType}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Breed : ${widget.pet.breed}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Age : ${widget.pet.age}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              SizedBox(height: 35),
              Text(
                'Diet Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Text(
                  dietPlan,
                  style: TextStyle(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Exercise Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Text(
                  exercisePlan,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          type = 'diet';
                        });
                        generateResponse();
                        setState(() {
                          showResponse = true;
                        });
                      }, // Add Pet to List
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Generate Diet Plan',
                        style: TextStyle(
                          color: Color.fromARGB(255, 54, 54, 54),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Add Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          type = 'exercise';
                        });
                        generateResponse();
                        setState(() {
                          showResponse = true;
                        });
                      }, // Add Pet to List
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 57, 57),
                      ),
                      child: const Text(
                        'Generate Exercise Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (showResponse)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Generated $type Plan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Text(
                          planResponse,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        onTap: () {
                          if (type == 'diet') {
                            setState(() {
                              dietPlan = planResponse;
                              showResponse = false;
                            });
                          } else if (type == 'exercise') {
                            setState(() {
                              exercisePlan = planResponse;
                              showResponse = false;
                            });
                          }
                          savePetData();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        context.read<PetsList>().removePet(widget.pet);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/pets_page');
                      }, // Add Pet to List
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Color.fromARGB(255, 54, 54, 54),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Add Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetEditPage(pet: widget.pet),
                          ),
                        );
                      }, // Add Pet to List
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 57, 57),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
