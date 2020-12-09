import 'package:CapstoneProject/screens/authentication/login_main.dart';
import 'package:CapstoneProject/screens/browse_decks/deck_view_screen.dart';
import 'package:CapstoneProject/screens/browse_decks/select_deck_screen.dart';
import 'package:CapstoneProject/screens/conversations/conversation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/services.dart';

//import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: "Conversation App",
            theme: MyTheme.themeData,
            routes: {
              'conversation': (context) => ConversationScreen(),
              'select_deck': (context) => SelectDeckScreen(),
              'deck_view': (context) => DeckViewScreen(),
            },
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
                        ? LoginMain()
                        : Center(
                            child: Image.asset("assets/logo.png"),
                          ),
              ),
            ),
          );
        });
  }
}
