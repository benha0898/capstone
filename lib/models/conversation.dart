import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conversation {
  String id;
  Map<String, dynamic> typing;
  String groupPicture;
  String lastActivity;
  DateTime timestamp;
  List<Map<String, String>> users;
  Color color;

  Conversation({
    this.id,
    this.typing,
    this.groupPicture,
    this.lastActivity,
    this.timestamp,
    this.users,
    this.color,
  });

  Conversation.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.typing = snapshot["typing"];
    this.groupPicture = snapshot["groupPicture"];
    this.lastActivity = snapshot["lastActivity"];
    this.timestamp = snapshot["timestamp"].toDate();

    this.users = List<Map<String, String>>();
    this.users.addAll(List.generate(snapshot["users"].length,
        (index) => Map<String, String>.from(snapshot["users"][index])));
    this.color = snapshot.data().containsKey("color")
        ? Color(snapshot["color"]).withOpacity(1)
        : MyTheme.greyColor;
  }
}
