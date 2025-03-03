import 'package:flutter/foundation.dart';
import 'package:account/model/athleteItem.dart';  // Import your Athlete model
import 'package:account/database/athleteDB.dart'; // Import Athlete database file

class AthleteProvider with ChangeNotifier {
  List<Athlete> athletes = []; // List of athletes

  // Get the list of athletes
  List<Athlete> getAthletes() {
    return athletes;
  }

  // Initialize data (load from database)
  void initData() async {
    var db = AthleteDB(dbName: 'athletes.db');  // Database instance for athletes
    athletes = await db.loadAllData();  // Load data from the database
    notifyListeners();  // Notify listeners to update the UI
  }

  // Add a new athlete to the database
  void addAthlete(Athlete athlete) async {
    var db = AthleteDB(dbName: 'athletes.db');  // Database instance for athletes
    await db.insertDatabase(athlete);  // Insert the new athlete into the database
    athletes = await db.loadAllData();  // Reload all data after adding
    notifyListeners();  // Notify listeners to update the UI
  }

  // Delete an athlete from the database
  void deleteAthlete(Athlete athlete) async {
    var db = AthleteDB(dbName: 'athletes.db');  // Database instance for athletes
    await db.deleteData(athlete);  // Delete the athlete from the database
    athletes = await db.loadAllData();  // Reload all data after deletion
    notifyListeners();  // Notify listeners to update the UI
  }

  // Update an existing athlete's data in the database
  void updateAthlete(Athlete athlete) async {
    var db = AthleteDB(dbName: 'athletes.db');  // Database instance for athletes
    await db.updateData(athlete);  // Update the athlete data in the database
    athletes = await db.loadAllData();  // Reload all data after updating
    notifyListeners();  // Notify listeners to update the UI
  }
}
