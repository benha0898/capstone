import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratedDeck {
  final String category;
  final String deckID;
  final String name;
  final DateTime timestamp;
  final int totalQuestions;
  final bool completed;

  GeneratedDeck({
    this.category,
    this.deckID,
    this.name,
    this.totalQuestions,
    timestamp,
    completed,
  })  : this.timestamp = timestamp ?? DateTime.now(),
        this.completed = completed ?? false;

  GeneratedDeck.fromSnapshot(DocumentSnapshot snapshot)
      : this.category = snapshot["category"],
        this.deckID = snapshot["deckID"],
        this.name = snapshot["name"],
        this.timestamp = snapshot["timestamp"].toDate(),
        this.totalQuestions = snapshot["totalQuestions"],
        this.completed = snapshot["completed"];
}
