import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/screens/browse_decks/deck_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:CapstoneProject/theme/consts.dart';

class BrowseDecksScreen extends StatefulWidget {
  @override
  _BrowseDecksScreenState createState() => _BrowseDecksScreenState();
}

class _BrowseDecksScreenState extends State<BrowseDecksScreen> {
  DatabaseService db = DatabaseService();

  List<bool> _viewSelections = [true, false];
  List<bool> _categorySelections;
  List<QueryDocumentSnapshot> _categories = List<QueryDocumentSnapshot>();
  QueryDocumentSnapshot _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.mainColor,
        title: Text(
          "Browse Decks",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ToggleButtons(
            color: MyTheme.greyAccentColor,
            selectedColor: MyTheme.yellowAccentColor,
            fillColor: MyTheme.yellowColor,
            constraints: BoxConstraints(minHeight: 40.0, minWidth: 40.0),
            children: [
              Icon(Icons.view_module_rounded),
              Icon(Icons.view_list_rounded),
            ],
            isSelected: _viewSelections,
            onPressed: (int index) {
              setState(() {
                for (var i = 0; i < _viewSelections.length; i++) {
                  _viewSelections[i] = (i == index);
                }
              });
            },
          ),
        ),
        leadingWidth: 100,
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
                          for (var i = 0; i < _categorySelections.length; i++) {
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
                      stream: db.getDecksByCategory(_selectedCategory['name']),
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
                                        deck: deck,
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
              : Text("Loading..."),
        ],
      ),
    );
  }

  // _showDeckDescription(BuildContext context, Deck deck) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: deck.color,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20.0),
  //           ),
  //           title: Align(
  //             alignment: Alignment.bottomLeft,
  //             child: IconButton(
  //                 padding: EdgeInsets.zero,
  //                 alignment: Alignment.centerLeft,
  //                 highlightColor: Colors.transparent,
  //                 icon: Icon(
  //                   Icons.arrow_back_ios_sharp,
  //                   color: MyTheme.mainColor,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 }),
  //           ),
  //           content: SingleChildScrollView(
  //             child: AspectRatio(
  //               aspectRatio: 5 / 6,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Text(
  //                     deck.name,
  //                     style: Theme.of(context).textTheme.headline2,
  //                   ),
  //                   Text(
  //                     deck.description,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
  //           actions: [
  //             RaisedButton(
  //               color: MyTheme.whiteColor,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(5.0),
  //               ),
  //               child: Text("Select"),
  //               onPressed: () {
  //                 print("TODO");
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
}
