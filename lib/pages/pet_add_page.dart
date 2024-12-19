import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_care_manager/models/pet.dart';
import 'package:pet_care_manager/models/pets_list.dart';
import 'package:provider/provider.dart';

class PetAddPage extends StatelessWidget {
  const PetAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Key
    final _formKey = GlobalKey<FormState>();
    // Controllers
    final TextEditingController nameController = TextEditingController();
    final TextEditingController animalTypeController = TextEditingController();
    final TextEditingController breedController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    void addPet() {
      if (_formKey.currentState!.validate()) {
        final pet = Pet(
          name: nameController.text,
          animalType: animalTypeController.text,
          breed: breedController.text,
          age: int.tryParse(ageController.text)!,
        );
        context.read<PetsList>().addPet(pet);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/pets_page');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Add Pet'),
      ),
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                'Add New Pet',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 35),

              // Fields
              // Name Field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Valid Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Animal Type Field
              TextFormField(
                controller: animalTypeController,
                decoration: const InputDecoration(
                  labelText: 'Animal Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Valid Animal Type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Breed Field
              TextFormField(
                controller: breedController,
                decoration: const InputDecoration(
                  labelText: 'Animal Breed',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Valid Animal Breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Age Field
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Pet Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Valid Age';
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
                      Navigator.pushNamed(context, '/pets_page');
                    }, // Add Pet to List
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
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
                    onPressed: addPet, // Add Pet to List
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 57, 57, 57),
                    ),
                    child: const Text(
                      'Add Pet',
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
