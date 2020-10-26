import 'package:CapstoneProject/core/consts.dart';
import 'package:CapstoneProject/core/flutter_icons.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/screens/conversation_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Conversation> list = Conversation.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Conversations",
          style: TextStyle(fontSize: 32),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FlutterIcons.filter,
              color: AppColors.blueColor,
            ),
            onPressed: () {},
          ),
        ],
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
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ConversationScreen(otherMember: list[index]),
                      ),
                    );
                  },
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
                    list[index].contact.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: list[index].isTyping
                      ? Row(
                          children: [
                            SpinKitThreeBounce(
                              color: AppColors.blueColor,
                              size: 20.0,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              list[index].lastMessage,
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              list[index].lastMessageTime + " days ago",
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
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
