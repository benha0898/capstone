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
}
