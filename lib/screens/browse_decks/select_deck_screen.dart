import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/services/database.dart';
//import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/screens/browse_decks/deck_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:CapstoneProject/theme/consts.dart';

class SelectDeckScreen extends StatefulWidget {
  final Conversation conversation;
  final User me;

  const SelectDeckScreen({Key key, this.conversation, this.me})
      : super(key: key);

  @override
  _SelectDeckScreenState createState() => _SelectDeckScreenState();
}

class _SelectDeckScreenState extends State<SelectDeckScreen> {
  DatabaseService db = DatabaseService();

  List<bool> _categorySelections;
  List<QueryDocumentSnapshot> _categories = List<QueryDocumentSnapshot>();
  QueryDocumentSnapshot _selectedCategory;

  //List<QueryDocumentSnapshot> _friends = List<QueryDocumentSnapshot>();
  //List<QueryDocumentSnapshot> _selectedFriends = List<QueryDocumentSnapshot>();
  TextEditingController usernameController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Conversation newConversation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      //getFriends();
    });
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection("categories")
        .get()
        .then((value) => setState(() {
              _categories.addAll(value.docs);
              _selectedCategory = _categories[0];
              _categorySelections =
                  List.generate(_categories.length, (index) => (index == 0));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyTheme.mainColor,
          title: Text(
            "Select Deck",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyTheme.whiteColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: MyTheme.whiteColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Category Names
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _categorySelections != null
                    ? ToggleButtons(
                        renderBorder: false,
                        color: MyTheme.greyColor,
                        selectedColor: MyTheme.whiteColor,
                        fillColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        textStyle: Theme.of(context).textTheme.headline4,
                        children: List<Widget>.generate(
                          _categories.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _categories[index]['name'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        isSelected: _categorySelections,
                        onPressed: (int index) {
                          setState(() {
                            for (var i = 0;
                                i < _categorySelections.length;
                                i++) {
                              _categorySelections[i] = (i == index);
                            }
                            _selectedCategory = _categories[index];
                          });
                        },
                      )
                    : Text("Loading..."),
              ),
            ),
            _selectedCategory != null
                ? Expanded(
                    child: StreamBuilder(
                        stream:
                            db.getDecksByCategory(_selectedCategory['name']),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Text('Loading...');
                          return GridView.builder(
                            itemCount: snapshot.data.documents.length,
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 5 / 7,
                            ),
                            itemBuilder: (context, index) {
                              Deck deck = Deck.fromSnapshot(
                                  snapshot.data.documents[index]);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: deck.color,
                                  elevation: 10.0,
                                  shadowColor: Colors.black,
                                  child: InkWell(
                                    onTap: () {
                                      print(deck.name);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => DeckViewScreen(
                                          me: widget.me,
                                          deck: deck,
                                          conversation: widget.conversation,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          deck.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
