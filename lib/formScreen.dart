import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ProfessionalAthletes_App/model/athleteItem.dart'; // Rename model to Athlete
import 'package:ProfessionalAthletes_App/provider/athleteProvider.dart'; // Rename provider to AthleteProvider

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final ageController = TextEditingController();
  DateTime? birthDate;
  String selectedSport = 'Football';

  final sportsList = ['Football', 'Basketball', 'Tennis', 'Baseball', 'Volleyball'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Athlete',
        style: TextStyle(color: Colors.white, fontSize: 20),)
        ,
        backgroundColor: Colors.blue, // Set AppBar background to blue
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
        titleTextStyle: const TextStyle(color: Colors.white), // Set title text color to white
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  // Name input field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    controller: nameController,
                    validator: (String? value) {
                      if (value!.isEmpty) return "Please enter the name";
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  
                  // Interesting Score input field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Interesting Score',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    controller: scoreController,
                    validator: (String? value) {
                      try {
                        double score = double.parse(value!);
                        if (score < 0 || score > 10) return "Score must be between 0 and 10";
                      } catch (e) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  
                  // Age input field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    validator: (String? value) {
                      try {
                        int age = int.parse(value!);
                        if (age <= 0) return "Age must be positive";
                      } catch (e) {
                        return "Please enter a valid age";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  
                  // Birth Date Picker Button
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null && pickedDate != birthDate) {
                        setState(() {
                          birthDate = pickedDate;
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      birthDate == null
                          ? 'Select Birth Date'
                          : 'Birth Date: ${birthDate?.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown for Sport selection
                  DropdownButtonFormField<String>(
                    value: selectedSport,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSport = newValue!;
                      });
                    },
                    items: sportsList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Sport',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Add Athlete button
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var provider = Provider.of<AthleteProvider>(context, listen: false);
                        Athlete athlete = Athlete(
                          name: nameController.text,
                          scoreInteresting: double.parse(scoreController.text),
                          age: int.parse(ageController.text),
                          birth: birthDate!,
                          sport: selectedSport,
                        );
                        provider.addAthlete(athlete);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add Athlete',
                    style: TextStyle(color: Colors.white, fontSize: 16),),
                    
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
