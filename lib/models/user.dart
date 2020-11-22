import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String profilePicture;
  List<String> conversations;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.profilePicture,
      this.conversations});

  User.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        firstName = snapshot["firstName"],
        lastName = snapshot["lastName"],
        profilePicture = snapshot["profilePicture"],
        conversations = snapshot["conversations"].cast<String>();

  String get name {
    return '$firstName $lastName';
  }

  Map<String, String> get info => {
        "id": this.id,
        "firstName": this.firstName,
        "lastName": this.lastName,
        "profilePicture": this.profilePicture,
      };

  // static List<User> names = [
  //   User(id: 1, firstName: "Ben", lastName: "Ha"),
  //   User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
  //   User(id: 3, firstName: "Jeffrey", lastName: "Davis"),
  //   User(id: 4, firstName: "Cam", lastName: "Macdonell"),
  //   User(id: 5, firstName: "Robert", lastName: "Andruchow"),
  //   User(id: 6, firstName: "Michelle", lastName: "Weremczuk"),
  //   User(id: 7, firstName: "Quinton", lastName: "Wong"),
  //   User(id: 8, firstName: "Rebecca", lastName: "Hardy"),
  //   User(id: 9, firstName: "Alex", lastName: "Anderson"),
  //   User(id: 10, firstName: "Bob", lastName: "Billy"),
  //   User(id: 11, firstName: "Christine", lastName: "Chang"),
  // ];
}
