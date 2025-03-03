import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ProfessionalAthletes_App/model/athleteItem.dart'; // Rename model to Athlete
import 'package:ProfessionalAthletes_App/provider/athleteProvider.dart'; // Rename provider to AthleteProvider
import 'formScreen.dart';
import 'package:ProfessionalAthletes_App/editScreen.dart'; // Assuming you have an edit screen for athletes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AthleteProvider()) // Updated provider name
      ],
      child: MaterialApp(
        title: 'Professional Athletes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const MyHomePage(title: 'Professional Athletes'), // Updated page title
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize data
    AthleteProvider provider = Provider.of<AthleteProvider>(context, listen: false);
    provider.initData(); // Assuming this loads initial athlete data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set app bar background to blue
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white), // Set title text to white
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FormScreen(); // Form to add new athlete
              }));
            },
          ),
        ],
      ),
      body: Consumer<AthleteProvider>(
        builder: (context, provider, child) {
          List<Athlete> sortedAthletes = List.from(provider.athletes);
          sortedAthletes.sort((a, b) => b.scoreInteresting.compareTo(a.scoreInteresting));

          int itemCount = sortedAthletes.length;
          if (itemCount == 0) {
            return Center(
              child: Text(
                'ไม่มีรายการ',
                style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                Athlete athlete = sortedAthletes[index];
                return Dismissible(
                  key: Key(athlete.keyID.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    provider.deleteAthlete(athlete);
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: Text(
                          athlete.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          'Age: ${athlete.age} | Sport: ${athlete.sport}',
                          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Score: ${athlete.scoreInteresting}',
                              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: DefaultTextStyle(
                                        style: const TextStyle(color: Colors.black),
                                        child: const Text('Are you sure you want to delete this athlete?'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            provider.deleteAthlete(athlete);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: FittedBox(
                            child: Text(
                              athlete.scoreInteresting.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return EditScreen(athlete: athlete); // Edit athlete
                          }));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}