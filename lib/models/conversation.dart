import 'package:CapstoneProject/models/user.dart';

class Conversation {
  bool isTyping;
  String lastMessage;
  DateTime lastMessageTime;
  List<User> users;

  Conversation(
      {this.isTyping, this.lastMessage, this.lastMessageTime, this.users});

  static List<Conversation> list = [
    Conversation(
      isTyping: true,
      lastMessage: "hello!",
      lastMessageTime: DateTime(2020, 10, 31, 19, 30, 00),
      users: [
        User(id: 9, firstName: "Alex", lastName: "Anderson"),
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 11, firstName: "Christine", lastName: "Chang"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sounds great!",
      lastMessageTime: DateTime(2020, 11, 12, 9, 00, 00),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
        User(id: 6, firstName: "Michelle", lastName: "Weremczuk"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sure, no problem!",
      lastMessageTime: DateTime(2020, 11, 11, 14, 59, 59),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
        User(id: 3, firstName: "Jeffrey", lastName: "Davis"),
        User(id: 5, firstName: "Robert", lastName: "Andruchow"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "I'm great! How are you?",
      lastMessageTime: DateTime(2020, 11, 8, 00, 30, 00),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 10, firstName: "Bob", lastName: "Billy"),
      ],
    ),
  ];
}
