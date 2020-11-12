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
        User(id: 9, name: "Alex Anderson"),
        User(id: 1, name: "Ben Ha"),
        User(id: 11, name: "Christine Chang"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sounds great!",
      lastMessageTime: DateTime(2020, 11, 12, 9, 00, 00),
      users: [
        User(id: 1, name: "Ben Ha"),
        User(id: 2, name: "Josephine Estudillo"),
        User(id: 6, name: "Michelle Weremczuk"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sure, no problem!",
      lastMessageTime: DateTime(2020, 11, 11, 14, 59, 59),
      users: [
        User(id: 1, name: "Ben Ha"),
        User(id: 2, name: "Josephine Estudillo"),
        User(id: 3, name: "Jeffrey Davis"),
        User(id: 5, name: "Robert Andruchow"),
      ],
    ),
    Conversation(
      isTyping: false,
      lastMessage: "I'm great! How are you?",
      lastMessageTime: DateTime(2020, 11, 8, 00, 30, 00),
      users: [
        User(id: 1, name: "Ben Ha"),
        User(id: 10, name: "Bob Billy"),
      ],
    ),
  ];
}
