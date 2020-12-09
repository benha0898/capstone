import 'package:CapstoneProject/app.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/services/constants.dart';
//import 'package:CapstoneProject/screens/browse_decks/browse_decks_screen.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/screens/services/search_friends_screen.dart';
//import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/theme/consts.dart';

//import 'constants.dart';

class InviteFriends extends StatefulWidget {
  final Deck deck;

  const InviteFriends({Key key, this.deck}) : super(key: key);

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          backgroundColor: widget.deck.color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: ListTile(
            leading: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                highlightColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: MyTheme.mainColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            trailing: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              icon: Icon(
                Icons.search,
                color: MyTheme.mainColor,
              ),
              onPressed: () {
                print('open search friends screen');
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchFriends()));
              },
            ),
            
            title: Text(
              'Invite Friends',
              style: TextStyle(
                fontFamily: "DottiesChocolate",
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
                color: MyTheme.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: SingleChildScrollView(
            child: AspectRatio(
              aspectRatio: 4 / 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "search email...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "DottiesChocolate",
                                  fontSize: 15.0,),
                                border: InputBorder.none),
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child:Text('search'),
                            onPressed: () {
                              print('start search');
                            }
                            ),
                      ],
                    ),
                  ),
                  SizedBox(height:8),
                  UserListCheckbox(),
                  SizedBox(height:8),
                  Text(
                      'Deck Selected: ${widget.deck.name}',
                      style: TextStyle(
                        fontFamily: "DottiesChocolate",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: MyTheme.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ButtonTheme(
                      minWidth: 30.0,
                      height: 30.0,
                      child: RaisedButton(
                        onPressed: () {
                          print('go back to card description');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => CustomNavigatorHomePage()));
                        },
                        child: Text("edit"),
                        color: MyTheme.whiteColor,
                      ),
                    ),
                  Container(
                      child: Column(children: [
                    SizedBox(
                      height: 8,
                    ),
                    
                            Text(
          "Friends Selected: ",
          style: TextStyle(
            fontFamily: "DottiesChocolate",
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: MyTheme.whiteColor,
          ),
          textAlign: TextAlign.center,
        ),
                  ]))
                ],
              ),
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
          actions: [
            RaisedButton(
              color: MyTheme.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text("Start Playing"),
              onPressed: () {
                print('start new conversation');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
class UserListTile extends StatefulWidget {
  @override
  _UserListTileState createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  List<QueryDocumentSnapshot> friends = List<QueryDocumentSnapshot>();
  List<DocumentSnapshot> invitedFriendsList = List<DocumentSnapshot>();

  DatabaseMethods dbMethods = new DatabaseMethods();

  getList() {
    dbMethods.getUsers().then((val) {
      setState(() {
        friends = val.docs;
      });
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                title: Text(
                  friends[index].get('username'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: IconButton(
                  icon: Icon(
                    FlutterIcons.add_circle_outline,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print('${friends[index].get('username')} selected');
                  },
                ),
              );
            }),
      ),
    );
  }
}
*/

class UserListCheckbox extends StatefulWidget {
  @override
  _UserListCheckboxState createState() => _UserListCheckboxState();
}

class _UserListCheckboxState extends State<UserListCheckbox> {
  List<QueryDocumentSnapshot> friends = List<QueryDocumentSnapshot>();
  List<DocumentSnapshot> invitedFriendsList = List<DocumentSnapshot>();

  DatabaseMethods dbMethods = new DatabaseMethods();

  List<String> isChecked = [];

  User me;

  getList() {
    dbMethods.getUsers().then((val) {
      setState(() {
        friends = val.docs;
      });
    });
  }

  clearList() {
    isChecked.clear();
    isChecked.add(Constants.myUsername);
  }


  @override
  void initState() {
    getList();
    clearList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (BuildContext context, index) {
                return CheckboxListTile(
                  title: Text(friends[index].get('username')),
                  subtitle: Text(friends[index].get('email')),
                  activeColor: Colors.black ,
                  checkColor: Colors.white,
                  value: isChecked.contains(friends[index].id),
                  onChanged: (bool val) {
                    if (val && isChecked.length < 8) {
                      setState(() {
                        isChecked.add(friends[index].id);
                      });
                      print('${isChecked.toString()} selected');
                    } else {
                      setState(() {
                        isChecked.remove(friends[index].id);
                      });
                      print('${isChecked.toString()} selected');
                    }
                  },
                );
              }),
        ),
        );
  }
}
