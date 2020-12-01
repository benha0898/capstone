import 'package:CapstoneProject/models/user_info.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/theme/flutter_icons.dart';
//import 'package:CapstoneProject/models/conversation.dart';
//import 'package:CapstoneProject/screens/conversations/conversation_screen.dart';

import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  List<UserId> list = UserId.list;
  //List<Conversation> listU = Conversation.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.mainColor,
        title: Text(
          "Friends",
          style: TextStyle(fontSize: 32),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white30,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.white30,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),

          //LIST OF USERS SHOWN
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // onTap: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (_) =>
                  //           ConversationScreen(conversation: listU[index]),
                  //     ),
                  //   );
                  // },
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage("assets/default.jpg"),
                      ),
                    ),
                  ),
                  title: Text(
                    "TO-DO", //list[index].name.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        list[index].userName,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    FlutterIcons.add_circle_outline,
                    color: Colors.white,
                    size: 35,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
