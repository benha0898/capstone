import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/theme/flutter_icons.dart';
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

  
  List<QueryDocumentSnapshot> _friends = List<QueryDocumentSnapshot>();
  List<QueryDocumentSnapshot> _selectedFriends = List<QueryDocumentSnapshot>();
  Conversation newConversation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      getFriends();
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

getFriends() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((querySnapshot) {
              _friends = querySnapshot.docs;
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Browse Decks",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: TextButton(
          child: Text(
            "Sort by",
            style: TextStyle(
              color: AppColors.blueColor,
            ),
          ),
          onPressed: () {},
        ),
        leadingWidth: 70,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.blueColor,
            ),
            onPressed: () {},
          ),
        ],
      ),    
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ToggleButtons(
                  selectedColor: AppColors.blueColor,
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _categorySelections != null
                        ? ToggleButtons(
                            renderBorder: false,
                            color: Colors.black38,
                            selectedColor: Colors.black,
                            fillColor: Colors.transparent,
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
              ],
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
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                          ),
                          itemBuilder: (context, index) {
                            return FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        snapshot.data.documents[index]['name']);
                                    _showDeckDescription(context,
                                        snapshot.data.documents[index], _friends);
                                  },
                                  child: Text(
                                    snapshot.data.documents[index]['name'],
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

  _showDeckDescription(BuildContext context, DocumentSnapshot deck, List<DocumentSnapshot> friends){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              deck['name'],
            ),
            content: Text(
              deck['description'],
            ),
            actions: [
              FlatButton(
                child: Text("Back"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Invite Players"),
                onPressed: () {
                  print("This should show invite players pop up");
                  _invitePlayers(context, deck, friends);
                },
              ),
            ],
          );
        });
  }

  _invitePlayers(BuildContext context, DocumentSnapshot deck, List<DocumentSnapshot> friends){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: ListTile(
            title: Text('Add Friends'),
            leading: FlatButton(
              onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BrowseDecksScreen()),
            );
          }, child: Text('Cancel'),),
            trailing: IconButton(icon: Icon(FlutterIcons.search), onPressed: null)),
          content: 
          Column(
          children: [
          Container(
            height: 320.0,
            width: 400.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(friends[index].get('firstName')),
                  leading:IconButton(
                    icon: Icon(FlutterIcons.add_circle_outline),
                    onPressed: () {
                      _selectedFriends.add(friends[index]);
                      print(friends[index].get('firstName'));
                      print(_selectedFriends);
                    }),
                );
              }),
          ),
          Container(
            height: 100.0,
            width: 400.0,
            child: Column(
              children: [
              Text('Deck Selected: ${deck['name']}'),
              ButtonTheme(
                minWidth: 30.0,
                height: 30.0,
                child: RaisedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('edit'))
              ),
              Text('Friends Selected: '),
            ],),
          )
          ],),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text('Back'),),
            FlatButton(
              child: Text('Start Playing'),
              onPressed: null,),
          ],
        );
      }
    );
  }
}
