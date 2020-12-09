import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String firstName;
  String lastName;
  String profilePicture;
  List<String> conversations;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.profilePicture,
      this.conversations});

  User.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        email = snapshot["email"],
        firstName = snapshot["firstName"],
        lastName = snapshot["lastName"],
        profilePicture = snapshot["profilePicture"],
        conversations = snapshot["conversations"].cast<String>();

  String get name {
    return '$firstName $lastName';
  }

  Map<String, String> get info => {
        "id": this.id,
        "email": this.email,
        "firstName": this.firstName,
        "lastName": this.lastName,
        "profilePicture": this.profilePicture,
      };
}
