import 'dart:io';
import 'package:ProfessionalAthletes_App/model/athleteItem.dart';
import 'package:path/path.dart';
import 'package:ProfessionalAthletes_App/provider/athleteProvider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class AthleteDB {
  String dbName;

  AthleteDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(Athlete athlete) async {
    var db = await openDatabase();

    var store = intMapStoreFactory.store('athletes');

    Future<int> keyID = store.add(db, {
      'name': athlete.name,
      'scoreInteresting': athlete.scoreInteresting,
      'age': athlete.age,
      'birth': athlete.birth.toIso8601String(),
      'sport': athlete.sport,
    });
    db.close();
    return keyID;
  }

  Future<List<Athlete>> loadAllData() async {
    var db = await openDatabase();

    var store = intMapStoreFactory.store('athletes');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('birth', false)]));

    List<Athlete> athletes = [];

    for (var record in snapshot) {
      Athlete athlete = Athlete(
        keyID: record.key,
        name: record['name'].toString(),
        scoreInteresting: double.parse(record['scoreInteresting'].toString()),
        age: int.parse(record['age'].toString()),
        birth: DateTime.parse(record['birth'].toString()),
        sport: record['sport'].toString(),
      );
      athletes.add(athlete);
    }
    db.close();
    return athletes;
  }

  deleteData(Athlete athlete) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('athletes');
    store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, athlete.keyID)));
    db.close();
  }

  updateData(Athlete athlete) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('athletes');

    store.update(
        db,
        {
          'name': athlete.name,
          'scoreInteresting': athlete.scoreInteresting,
          'age': athlete.age,
          'birth': athlete.birth.toIso8601String(),
          'sport': athlete.sport,
        },
        finder: Finder(filter: Filter.equals(Field.key, athlete.keyID))
    );

    db.close();
  }
}
