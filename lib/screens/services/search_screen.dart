import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/theme/consts.dart';

class SearchScreen extends StatefulWidget {
  final Deck deck;

  const SearchScreen({Key key, this.deck}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<QueryDocumentSnapshot> _friends = List<QueryDocumentSnapshot>();
  List<DocumentSnapshot> friendlist = List<DocumentSnapshot>();
  DatabaseMethods db = DatabaseMethods();
  User registeredUser = new User();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFriends();
    });
  }

  getFriends() async {
    await FirebaseFirestore.instance
        .collection("registeredUser")
        .get()
        .then((querySnapshot) {
      _friends = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    friendlist = _friends;
    return AlertDialog(
      backgroundColor: widget.deck.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
          onPressed: () {},
        ),
      ),
      content: SingleChildScrollView(
        child: AspectRatio(
          aspectRatio: 5 / 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Invite Friends",
                style: Theme.of(context).textTheme.headline2,
              ),
              Expanded(
                child:
              ListView.builder(
                      //shrinkWrap: true,
                      itemCount: friendlist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(friendlist[index].get('username')),
                          leading: IconButton(
                            icon: Icon(FlutterIcons.add_circle_outline),
                            onPressed: () {
                              print("user: ${friendlist[index].get('username')} clicked");
                            },
                          ),
                        );
                      }),
              ),
              Container(
                  child: Column(
                    children: [
                Text(
                  'Deck Selected: ${widget.deck.name}',
                ),
                ButtonTheme(
                  minWidth: 30.0,
                  height: 30.0,
                  child: RaisedButton(
                    onPressed: () {
                      print('go back to card description');
                    },
                    child: Text("edit"),
                  ),
                ),
                Text("Friends Selected: ")
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
    );
  }
}
