import 'package:CapstoneProject/screens/authentication/login_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: "Conversation App",
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: (snapshot.hasError)
                ? Center(
                    child: Text(snapshot.error.toString()),
                  )
                : (snapshot.connectionState == ConnectionState.done)
                    ? LoginMain()
                    : Center(
                        child: Text(
                          "Loading...",
                        ),
                      ),
          );
        });
  }
}
