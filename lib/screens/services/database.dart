import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserbyUsername(String uname) async{
    return await FirebaseFirestore.instance.collection("registeredUser")
    .where("username", isEqualTo: uname)
    .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("registeredUser")
    .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  getUsers(){

  }
}