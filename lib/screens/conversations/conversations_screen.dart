import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  DatabaseService db = DatabaseService();
  //List<Conversation> conversations;
  User me;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("Avqp7v0qZE2iZ0yyrRO6")
        .get()
        .then((value) => setState(() {
              me = User.fromSnapshot(value);
              // conversations = List<Conversation>();
              // if (me.conversations.length > 0) {
              //   print("I have ${me.conversations.length} conversations!");
              //   for (int i = 0; 10 * i <= me.conversations.length; i++) {
              //     List<String> temp = me.conversations.sublist(
              //         i,
              //         (i + 10 <= me.conversations.length)
              //             ? i + 10
              //             : me.conversations.length);
              //     FirebaseFirestore.instance
              //         .collection("conversations")
              //         .where(FieldPath.documentId, whereIn: temp)
              //         .snapshots()
              //         .listen((data) => setState(() {
              //               conversations.addAll(List.generate(
              //                   data.docs.length,
              //                   (index) => Conversation.fromSnapshot(
              //                       data.docs[index])));
              //             }));
              //   }
              // }
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
          "Conversations",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
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
      body: (me == null)
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Container(
                //   // Search bar
                //   margin: EdgeInsets.all(16),
                //   padding: EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //     color: Colors.black45,
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //   ),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: Colors.white30,
                //       ),
                //       hintText: "Search",
                //       hintStyle: TextStyle(
                //         color: Colors.white30,
                //       ),
                //     ),
                //   ),
                // ),
                StreamBuilder(
                  stream: db.getConversations(me),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    List<Conversation> conversations = List.generate(
                        snapshot.data.documents.length,
                        (index) => Conversation.fromSnapshot(
                            snapshot.data.documents[index]));
                    return Expanded(
                      child: ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: (index % 2 == 0)
                                  ? Color(0xFFE2E2E2)
                                  : Color(0xFFD9D9D9),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, 'conversation',
                                    arguments: {
                                      "me": me,
                                      "conversation": conversations[index],
                                    });
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (_) => ConversationScreen(
                                //         conversation: conversations[index],
                                //         me: me),
                                //   ),
                                // );
                              },
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  image: DecorationImage(
                                    image: Image.network(
                                            conversations[index].groupPicture)
                                        .image,
                                  ),
                                ),
                              ),
                              title: Text(
                                conversations[index].users.length > 2
                                    ? conversations[index]
                                        .users
                                        .where(
                                            (element) => element["id"] != me.id)
                                        .map((element) => element["firstName"])
                                        .join(", ")
                                    : conversations[index]
                                        .users
                                        .where(
                                            (element) => element["id"] != me.id)
                                        .map((element) =>
                                            element["firstName"] +
                                            " " +
                                            element["lastName"])
                                        .join(", "),
                                style: TextStyle(
                                  color: MyTheme.mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: conversations[index].typing["isTyping"]
                                  ? Row(
                                      children: [
                                        SpinKitThreeBounce(
                                          color: MyTheme.blueColor,
                                          size: 20.0,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          conversations[index].lastActivity,
                                          style: TextStyle(
                                            color: MyTheme.mainColor,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                              trailing: Text(
                                (isToday(conversations[index].timestamp))
                                    ? DateFormat.jm()
                                        .format(conversations[index].timestamp)
                                    : (isWithinAWeek(
                                            conversations[index].timestamp))
                                        ? DateFormat.E().format(
                                            conversations[index].timestamp)
                                        : DateFormat.MMMd().format(
                                            conversations[index].timestamp),
                                style: TextStyle(
                                  color: MyTheme.mainColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
