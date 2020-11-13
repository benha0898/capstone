import 'package:CapstoneProject/models/contact.dart';

class UserId {
  final String userName;
  final String email;
  final Contact name;

  UserId({
    this.userName,
    this.email,
    this.name,
  });

  static List<UserId> list = [
    UserId(
      userName: "alex_anderson",
      email: "andersona01@hotmail.com",
      name: Contact(name: "Alex Anderson")
      ),
    UserId(
      userName: "BBob_01",
      email: "billyB@gmail.com",
      name: Contact(name: "Bob Billy")
      ),
    UserId(
      userName: "christinechang",
      email: "christinechang@gmail.com",
      name: Contact(name: "Christine Chang")
      ),
  ];
}