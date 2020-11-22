import 'package:cloud_firestore/cloud_firestore.dart';

class ChatItem {
  final Map<String, String> sender;
  final String text;
  final String deck;
  final String question;
  final DateTime timestamp;

  ChatItem({uid, sender, profilePicture, text, deck, question, timestamp})
      : this.sender = sender ?? "",
        this.text = text ?? "",
        this.deck = deck ?? "",
        this.question = question ?? "",
        this.timestamp = timestamp ?? DateTime.now();

  ChatItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.sender = Map<String, String>.from(snapshot["sender"]),
        this.text = snapshot["text"],
        this.deck = snapshot["deck"],
        this.question = snapshot["question"],
        this.timestamp = snapshot["timestamp"].toDate();

  Map<String, dynamic> toJsonMessage() => {
        "sender": {
          "id": this.sender["id"],
          "firstName": this.sender["firstName"],
          "lastName": this.sender["lastName"],
          "profilePicture": this.sender["profilePicture"],
        },
        "text": this.text,
        "deck": "",
        "question": "",
        "timestamp": DateTime.now(),
      };
  Map<String, dynamic> toJsonReply() => {
        "sender": {
          "id": this.sender["id"],
          "firstName": this.sender["firstName"],
          "lastName": this.sender["lastName"],
          "profilePicture": this.sender["profilePicture"],
        },
        "text": this.text,
        "timestamp": DateTime.now(),
      };
}
