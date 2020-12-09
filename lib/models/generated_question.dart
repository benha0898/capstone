import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GeneratedQuestion {
  String id;
  int number;
  int totalQuestions;
  String deck;
  String deckName;
  String text;
  DateTime timestamp;
  List<Message> answers = List<Message>();
  List<Message> replies = List<Message>();
  bool answered;
  Color color;
  String background;

  GeneratedQuestion({
    this.id,
    this.number,
    this.totalQuestions,
    this.deck,
    this.deckName,
    this.text,
    timestamp,
    answers,
    replies,
    answered,
    color,
    background,
  })  : this.timestamp = timestamp ?? DateTime.now(),
        this.answers = answers ?? List<Map<String, dynamic>>(),
        this.replies = replies ?? List<Map<String, dynamic>>(),
        this.answered = answered ?? false,
        this.color = color ?? MyTheme.greyColor,
        this.background = background ?? "";

  GeneratedQuestion.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.number = snapshot["number"];
    this.totalQuestions = snapshot["totalQuestions"];
    this.deck = snapshot["deck"];
    this.deckName = snapshot["deckName"];
    this.text = snapshot["text"];
    this.timestamp = snapshot["timestamp"].toDate();
    if (snapshot.data().containsKey("answers")) {
      this.answers.addAll(List.generate(
          snapshot["answers"].length,
          (index) => Message.fromMap(
              Map<String, dynamic>.from(snapshot["answers"][index]))));
      this.answers.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    if (snapshot.data().containsKey("replies")) {
      this.replies.addAll(List.generate(
          snapshot["replies"].length,
          (index) => Message.fromMap(
              Map<String, dynamic>.from(snapshot["replies"][index]))));
      this.replies.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    this.answered = snapshot["answered"];
    this.color = Color(snapshot["color"]).withOpacity(1);
    this.background = snapshot["background"];
  }
}
