import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/services/database.dart';
//import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:CapstoneProject/theme/consts.dart';

class BrowseDecksScreen extends StatefulWidget {
  final User me;

  const BrowseDecksScreen({Key key, this.me}) : super(key: key);

  @override
  _BrowseDecksScreenState createState() => _BrowseDecksScreenState();
}

class _BrowseDecksScreenState extends State<BrowseDecksScreen> {
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

/*
getFriends() async {
    await FirebaseFirestore.instance
        .collection("registeredUser")
        .get()
        .then((querySnapshot) {
              _friends = querySnapshot.docs;
            });
  }
*/
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
        leading: SizedBox(),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ToggleButtons(
        //     color: MyTheme.greyAccentColor,
        //     selectedColor: MyTheme.yellowAccentColor,
        //     fillColor: MyTheme.yellowColor,
        //     constraints: BoxConstraints(minHeight: 40.0, minWidth: 40.0),
        //     children: [
        //       Icon(Icons.view_module_rounded),
        //       Icon(Icons.view_list_rounded),
        //     ],
        //     isSelected: _viewSelections,
        //     onPressed: (int index) {
        //       setState(() {
        //         for (var i = 0; i < _viewSelections.length; i++) {
        //           _viewSelections[i] = (i == index);
        //         }
        //       });
        //     },
        //   ),
        // ),
        // leadingWidth: 100,
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
                      // splashColor: Colors.transparent,
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
                              // color: Color(_categories[index]['color']).withOpacity(1),
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
                  : SizedBox(),
            ),
          ),
          _selectedCategory != null
              ? Expanded(
                  child: StreamBuilder(
                      stream: db.getDecksByCategory(_selectedCategory['name']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
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
                                    Navigator.pushNamed(context, 'deck_view',
                                        arguments: {
                                          "deck": deck,
                                        });
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //   builder: (_) => DeckViewScreen(
                                    //     deck: deck,
                                    //   ),
                                    // ));
                                  },
                                  child: Container(
                                    decoration: (deck.graphic != "")
                                        ? BoxDecoration(
                                            color: deck.color,
                                            image: DecorationImage(
                                              image: Image.network(
                                                deck.graphic,
                                              ).image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          )
                                        : BoxDecoration(
                                            color: deck.color,
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
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
              : Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
/*
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
            trailing: 
            IconButton(
              icon: Icon(FlutterIcons.search),
              onPressed: (){
                _searchplayers(context);
              }
              )),
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
                  title: Text(friends[index].get('username')),
                  leading:IconButton(
                    icon: Icon(FlutterIcons.add_circle_outline),
                    onPressed: () {
                      _selectedFriends.add(friends[index]);
                      print(friends[index].get('username'));
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

QuerySnapshot searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserbyUsername(usernameController.text)
    .then((val){
      print(val.toString());
      setState(() {
         searchSnapshot = val;
      });
    });
  }

  _searchplayers(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: ListTile(
            title: TextFormField(
              controller: usernameController,
              style: TextStyle(color: Colors.blueAccent),
              decoration: InputDecoration(
                hintText: "search username")
            ),
            trailing: 
            IconButton(
              icon: Icon(FlutterIcons.search),
              onPressed: (){
                initiateSearch();
                }),
            ),
        content: searchSnapshot != null ?
        Container(
          height: 400.0,
          width: 400.0,
          child: ListView.builder(
          itemCount: searchSnapshot.docs.length,
          itemBuilder: (context, index){
            return SearchTile(
              userUsername: searchSnapshot.docs[index].get('username'),
              userEmail: searchSnapshot.docs[index].get('email')
            );
          })
         ) : Container(),
        );
    });
  }
}

class SearchTile extends StatelessWidget {
    final String userUsername;
    final String userEmail;
    SearchTile({this.userUsername, this.userEmail});

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Row(
          children: [
            Column(
              children: [
                Text(userUsername),
                Text(userEmail),
                ],
              ),
              Spacer(),
              Container(
                
              )
          ],
        )
      );
    }
    */
}
