import 'package:CapstoneProject/theme/consts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

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
            theme: MyTheme.themeData,
            home: Container(
              decoration: BoxDecoration(
                image: MyTheme.backgroundImage,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: (snapshot.hasError)
                    ? Center(
                        child: Text(snapshot.error.toString()),
                      )
                    : (snapshot.connectionState == ConnectionState.done)
                        ? CustomNavigatorHomePage()
                        : Center(
                            child: Text(
                              "Loading...",
                            ),
                          ),
              ),
            ),
          );
        });
  }
}
