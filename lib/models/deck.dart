import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Deck {
  final String id;
  final String name;
  final String category;
  final String categoryID;
  final String description;
  final List<String> questions;
  final Color color;
  final String graphic;
  final String background;

  Deck({
    this.id,
    this.name,
    this.category,
    this.categoryID,
    this.description,
    questions,
    color,
    graphic,
    background,
  })  : this.questions = questions ?? List<String>(),
        this.color = color ?? MyTheme.greyColor,
        this.graphic = graphic ?? "",
        this.background = background ?? "";

  Deck.fromSnapshot(DocumentSnapshot snapshot)
      : this.id = snapshot.id,
        this.name = snapshot["name"],
        this.category = snapshot["category"],
        this.categoryID = snapshot["categoryID"],
        this.description = snapshot["description"],
        this.questions = snapshot["questions"].cast<String>(),
        this.color = Color(snapshot["color"]).withOpacity(1),
        this.graphic = snapshot["graphic"],
        this.background = snapshot["background"];

  Deck.from(Deck deck)
      : this.id = deck.id,
        this.name = deck.name,
        this.category = deck.category,
        this.categoryID = deck.categoryID,
        this.description = deck.description,
        this.questions = new List<String>.from(deck.questions),
        this.color = Color(deck.color.value).withOpacity(1),
        this.graphic = deck.graphic,
        this.background = deck.background;
}
