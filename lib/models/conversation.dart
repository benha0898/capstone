import 'package:CapstoneProject/models/contact.dart';

class Conversation {
  final bool isTyping;
  final String lastMessage;
  final String lastMessageTime;
  final Contact contact;

  Conversation(
      {this.isTyping, this.lastMessage, this.lastMessageTime, this.contact});

  static List<Conversation> list = [
    Conversation(
      isTyping: true,
      lastMessage: "hello!",
      lastMessageTime: "2d",
      contact: Contact(name: "Alex Anderson"),
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sounds great!",
      lastMessageTime: "1d",
      contact: Contact(name: "Bob Billy"),
    ),
    Conversation(
      isTyping: false,
      lastMessage: "Sure, no problem!",
      lastMessageTime: "3d",
      contact: Contact(name: "Christine Chang"),
    ),
  ];
}
