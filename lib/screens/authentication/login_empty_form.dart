//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/screens/services/auth.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/screens/services/helper_functions.dart';
//import 'package:CapstoneProject/screens/user_file/user_search.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app.dart';

class LoginEmptyForm extends StatefulWidget {
  @override
  _LoginEmptyFormState createState() => _LoginEmptyFormState();
}

class _LoginEmptyFormState extends State<LoginEmptyForm> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  QuerySnapshot snapshotUserInfo;

  signInUser(){
    if(formKey.currentState.validate()){

      //HelperFunctions.saveUserEmailSP(emailController.text);

      setState(() {
        isLoading = true;
      });

      dbMethods.getUserbyEmail(emailController.text)
      .then((val){
        snapshotUserInfo = val;
        //HelperFunctions.saveUserEmailSP(snapshotUserInfo.docs[0].get('email'));
      });

      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text)
      .then((val){
        print("${val.userId}");
        if(val != null){
          //HelperFunctions.saveUserLoggedInSP(true);
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomNavigatorHomePage(),
            ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.mainColor,
        body: isLoading
        ?Container(
          child: Center(
            child: CircularProgressIndicator()),
            )
        :Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                children: [
                  TextFormField(
                    validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please provide valid email";
                      },
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: "email"),
                  ),
                  TextFormField(
                    validator: (val){
                        return val.length > 6 ? null : "Password needs to be longer than 6 characters";
                      },
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: "password"),
                  ),
                ]
              ),),
              SizedBox(
                height: 8,
              ),
             /* Container(
                  child: Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white54),
              )),*/
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  print(emailController.text);
                  signInUser();
                  print(passwordController.text);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blueGrey,
                      Colors.white54,
                      Colors.blueGrey
                    ]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.black)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ));
  }
}
