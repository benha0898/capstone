import 'dart:async';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/user.dart';
//import 'package:CapstoneProject/screens/browse_decks/browse_decks_screen.dart';
import 'package:CapstoneProject/screens/services/search_friends_screen.dart';
//import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/theme/consts.dart';

//import 'constants.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key key}) : super(key: key);

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  DatabaseService db = DatabaseService();
  Map<String, dynamic> arguments;
  TextEditingController searchController = new TextEditingController();
  List<User> friends;
  //List<User> invitedFriendsList;
  List<User> isChecked = [];

  User me;
  Deck deck;

  getList() {
    db.getUsers(me.id).then((snapshot) {
      setState(() {
        friends = List.generate(snapshot.docs.length,
            (index) => User.fromSnapshot(snapshot.docs[index]));
      });
    });
  }

  clearList() {
    isChecked.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    me = arguments["me"];
    deck = arguments["deck"];
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          backgroundColor: arguments["deck"].color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
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
              Text(
                'Invite Friends',
                style: TextStyle(
                  fontFamily: "DottiesChocolate",
                  fontSize: 26.0,
                  fontWeight: FontWeight.w400,
                  color: MyTheme.whiteColor,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.search,
                  color: MyTheme.mainColor,
                ),
                onPressed: () {
                  // print('open search friends screen');
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (_) => SearchFriends()));
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: AspectRatio(
              aspectRatio: 5 / 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           controller: searchController,
                  //           style: TextStyle(color: Colors.black),
                  //           decoration: InputDecoration(
                  //               hintText: "search email...",
                  //               hintStyle: TextStyle(
                  //                 color: Colors.grey,
                  //                 fontFamily: "DottiesChocolate",
                  //                 fontSize: 15.0,),
                  //               border: InputBorder.none),
                  //         ),
                  //       ),
                  //       RaisedButton(
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  //         child:Text('search'),
                  //           onPressed: () {
                  //             print('start search');
                  //           }
                  //           ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height:8),
                  Expanded(
                    child: (friends == null)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: friends.length,
                            itemBuilder: (BuildContext context, index) {
                              return CheckboxListTile(
                                title: Text(friends[index].name),
                                subtitle: Text(friends[index].email),
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                                value: isChecked.contains(friends[index]),
                                onChanged: (bool val) {
                                  if (val && isChecked.length < 8) {
                                    setState(() {
                                      isChecked.add(friends[index]);
                                    });
                                  } else {
                                    setState(() {
                                      isChecked.remove(friends[index]);
                                    });
                                  }
                                },
                              );
                            }),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deck Selected: ${deck.name}',
                    style: TextStyle(
                      fontFamily: "DottiesChocolate",
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: MyTheme.whiteColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(
                  //         height: 8,
                  //       ),
                  //       Text(
                  //         "Friends Selected: ",
                  //         style: TextStyle(
                  //           fontFamily: "DottiesChocolate",
                  //           fontSize: 18.0,
                  //           fontWeight: FontWeight.w400,
                  //           color: MyTheme.whiteColor,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  RaisedButton(
                    color: MyTheme.whiteColor,
                    splashColor: deck.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "Start Playing",
                      style: TextStyle(
                        color: deck.color,
                      ),
                    ),
                    onPressed: (isChecked.length == 0)
                        ? null
                        : () {
                            print('Start new conversation with: ');
                            for (User user in isChecked) {
                              print(user.name);
                            }
                            Timer(
                              Duration(milliseconds: 100),
                              () => Navigator.popUntil(context, (route) {
                                if (route.settings.name == 'navigation') {
                                  (route.settings.arguments as Map)["friends"] =
                                      isChecked;
                                  //arguments["friends"] = isChecked;
                                  return true;
                                }
                                return false;
                              }),
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class UserListCheckbox extends StatefulWidget {
//   @override
//   _UserListCheckboxState createState() => _UserListCheckboxState();
// }

// class _UserListCheckboxState extends State<UserListCheckbox> {
//   List<QueryDocumentSnapshot> friends = List<QueryDocumentSnapshot>();
//   List<DocumentSnapshot> invitedFriendsList = List<DocumentSnapshot>();

//   DatabaseMethods dbMethods = new DatabaseMethods();

//   List<String> isChecked = [];

//   User me;

//   getList() {
//     dbMethods.getUsers().then((val) {
//       setState(() {
//         friends = val.docs;
//       });
//     });
//   }

//   clearList() {
//     isChecked.clear();
//     isChecked.add(Constants.myUsername);
//   }

//   @override
//   void initState() {
//     getList();
//     clearList();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Expanded(
//         child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: friends.length,
//             itemBuilder: (BuildContext context, index) {
//               return CheckboxListTile(
//                 title: Text(friends[index].get('username')),
//                 subtitle: Text(friends[index].get('email')),
//                 activeColor: Colors.black,
//                 checkColor: Colors.white,
//                 value: isChecked.contains(friends[index].id),
//                 onChanged: (bool val) {
//                   if (val && isChecked.length < 8) {
//                     setState(() {
//                       isChecked.add(friends[index].id);
//                     });
//                     print('${isChecked.toString()} selected');
//                   } else {
//                     setState(() {
//                       isChecked.remove(friends[index].id);
//                     });
//                     print('${isChecked.toString()} selected');
//                   }
//                 },
//               );
//             }),
//       ),
//     );
//   }
// }
