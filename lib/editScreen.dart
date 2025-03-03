import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/athleteItem.dart';
import 'package:account/provider/athleteProvider.dart';

class EditScreen extends StatefulWidget {
  final Athlete athlete;

  EditScreen({super.key, required this.athlete});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final ageController = TextEditingController();
  DateTime? birthDate;
  String selectedSport = 'Football';

  final sportsList = ['Football', 'Basketball', 'Tennis', 'Baseball', 'Volleyball'];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.athlete.name;
    scoreController.text = widget.athlete.scoreInteresting.toString();
    ageController.text = widget.athlete.age.toString();
    birthDate = widget.athlete.birth;
    selectedSport = widget.athlete.sport;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Athlete',
          style: TextStyle(fontSize: 16, color: Colors.white), // Set font size to 16 and color to white
        ),
        backgroundColor: Colors.blue, // Set AppBar background to blue
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) return "Please enter the name";
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Interesting Score input field
                  TextFormField(
                    controller: scoreController,
                    decoration: const InputDecoration(
                      label: Text('Interesting Score'),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
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
                    controller: ageController,
                    decoration: const InputDecoration(
                      label: Text('Age'),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    keyboardType: TextInputType.number,
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
                        initialDate: birthDate!,
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

                  // Update Athlete button
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var provider = Provider.of<AthleteProvider>(context, listen: false);
                        Athlete updatedAthlete = Athlete(
                          keyID: widget.athlete.keyID,
                          name: nameController.text,
                          scoreInteresting: double.parse(scoreController.text),
                          age: int.parse(ageController.text),
                          birth: birthDate!,
                          sport: selectedSport,
                        );
                        provider.deleteAthlete(widget.athlete);
                        provider.addAthlete(updatedAthlete);
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
                    child: const Text(
                      'Update Athlete',
                      style: TextStyle(color: Colors.white),
                    ),
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