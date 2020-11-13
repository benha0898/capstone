import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/screens/conversations/conversation_screen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Conversation> list = Conversation.list;
  User me = User(id: 1, firstName: "Ben", lastName: "Ha");

  @override
  void initState() {
    super.initState();

    for (Conversation convo in list) {
      convo.users =
          convo.users.where((element) => (element.name != me.name)).toList();
      print(convo.users.map((element) => element.name).join(", "));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Conversations",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
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
            // Search bar
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
            // List of conversations
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
                    list[index].users.length > 1
                        ? list[index]
                            .users
                            .map((element) => element.firstName)
                            .join(", ")
                        : list[index]
                            .users
                            .map((element) => element.name)
                            .join(", "),
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
                              (isToday(list[index].lastMessageTime))
                                  ? DateFormat.jm()
                                      .format(list[index].lastMessageTime)
                                  : (isWithinAWeek(list[index].lastMessageTime))
                                      ? DateFormat.E()
                                          .format(list[index].lastMessageTime)
                                      : DateFormat.MMMd()
                                          .format(list[index].lastMessageTime),
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

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day);
  }

  bool isWithinAWeek(DateTime date) {
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(Duration(days: 7));
    lastWeek =
        DateTime(lastWeek.year, lastWeek.month, lastWeek.day, 23, 59, 59);
    return !isToday(date) && date.isAfter(lastWeek);
  }
}
