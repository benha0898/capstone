import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GeneratedDeck {
  final String id;
  final String category;
  final String deckID;
  final String categoryID;
  final String name;
  final DateTime timestamp;
  final int totalQuestions;
  final bool completed;
  final List<int> questionsOrder;
  final int questionsGenerated;
  final Color color;

  GeneratedDeck({
    this.id,
    this.category,
    this.deckID,
    this.categoryID,
    this.name,
    this.totalQuestions,
    this.questionsOrder,
    timestamp,
    completed,
    questionsGenerated,
    color,
  })  : this.timestamp = timestamp ?? DateTime.now(),
        this.completed = completed ?? false,
        this.questionsGenerated = questionsGenerated ?? 0,
        this.color = MyTheme.greyColor;

  GeneratedDeck.fromSnapshot(DocumentSnapshot snapshot)
      : this.id = snapshot.id,
        this.category = snapshot["category"],
        this.deckID = snapshot["deckID"],
        this.categoryID = snapshot["categoryID"],
        this.name = snapshot["name"],
        this.timestamp = snapshot["timestamp"].toDate(),
        this.totalQuestions = snapshot["totalQuestions"],
        this.completed = snapshot["completed"],
        this.questionsOrder = snapshot["questionsOrder"].cast<int>(),
        this.questionsGenerated = snapshot["questionsGenerated"],
        this.color = Color(snapshot["color"]).withOpacity(1);
}
