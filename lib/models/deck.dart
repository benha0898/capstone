import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Deck {
  final String id;
  final String name;
  final String description;
  final List<String> questions;
  final Color color;

  Deck({
    this.id,
    this.name,
    this.description,
    questions,
    color,
  })  : this.questions = questions ?? List<String>(),
        this.color = color ?? MyTheme.greyColor;

  Deck.fromSnapshot(DocumentSnapshot snapshot)
      : this.id = snapshot.id,
        this.name = snapshot["name"],
        this.description = snapshot["description"],
        this.questions = snapshot["questions"].cast<String>(),
        this.color = Color(snapshot["color"]).withOpacity(1);
}
