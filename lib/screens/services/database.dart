import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserbyEmail(String uname) async{
    return await FirebaseFirestore.instance.collection("registeredUser")
    .where("email", isEqualTo: uname)
    .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("registeredUser") 
    .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  getUsers() async{
    return await FirebaseFirestore.instance.collection("registeredUser").get();
  }

  createConversation(convoMap){
    FirebaseFirestore.instance.collection('conversations')
    .add(convoMap).catchError((e){
      print(e.toString());
    });
  }
}