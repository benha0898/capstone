//import 'package:CapstoneProject/models/user.dart';

class UserId {
  final String userName;
  final String email;
  //final User2 name;

  UserId({
    this.userName,
    this.email,
    //this.name,
  });

  static List<UserId> list = [
    UserId(
      userName: "alex_anderson",
      email: "andersona01@hotmail.com",
      //name: User2(id: 9, firstName: "Alex", lastName: "Anderson"),
    ),
    UserId(
      userName: "BBob_01",
      email: "billyB@gmail.com",
      //name: User2(id: 10, firstName: "Bob", lastName: "Billy"),
    ),
    UserId(
      userName: "christinechang",
      email: "christinechang@gmail.com",
      //name: User2(id: 11, firstName: "Christine", lastName: "Chang"),
    ),
  ];
}
