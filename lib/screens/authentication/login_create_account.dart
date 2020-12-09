//import 'package:CapstoneProject/widgets/widgets.dart';
import 'dart:async';

import 'package:CapstoneProject/app.dart';
import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/services/auth.dart';
import 'package:CapstoneProject/screens/services/constants.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/screens/services/helper_functions.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class LoginCreateAccount extends StatefulWidget {
  @override
  _LoginCreateAccountState createState() => _LoginCreateAccountState();
}

class _LoginCreateAccountState extends State<LoginCreateAccount> {
  DatabaseService db = DatabaseService();
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();
  QuerySnapshot snapshotUserInfo;

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();

  setConstants(){
    Constants.myFirstName = firstNameController.text;
    Constants.myLastName = lastNameController.text;
    Constants.myEmail = emailController.text;
    Constants.myUsername = usernameController.text;
  }

  signUpUser(){
    if(formKey.currentState.validate()){

      Map<String, dynamic> userInfoMap = {
          "username" : usernameController.text,
          "email" : emailController.text,
          "firstName" : firstNameController.text,
          "lastName" : lastNameController.text,
          "profilePicture" : "",
          "conversations": [],
      };

      //HelperFunctions.saveUserNameSP(usernameController.text);
      //HelperFunctions.saveUserEmailSP(emailController.text);
      setConstants();
      
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserbyEmail(emailController.text)
        .then((val){
          snapshotUserInfo = val;
        });

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        print("${val.userId}");
        print(Constants.myUsername);

        databaseMethods.uploadUserInfo(userInfoMap);

        Map<String, dynamic> userInfo = {
          "email": emailController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "profilePicture": "",
          "conversations": [""],
        };

        db.addUser(val.userId, userInfo).then((_) {
          User user = User(
            id: val.userId,
            email: userInfo["email"],
            firstName: userInfo["firstName"],
            lastName: userInfo["lastName"],
            profilePicture: userInfo["profilePicture"],
            conversations: userInfo["conversations"],
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CustomNavigatorHomePage(me: user),
              ),
              ModalRoute.withName('/'));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    focusNode1.addListener(() {
      if (focusNode1.hasFocus)
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
    });
    focusNode2.addListener(() {
      if (focusNode2.hasFocus)
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
    });
    focusNode3.addListener(() {
      if (focusNode3.hasFocus)
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
    });
    focusNode4.addListener(() {
      if (focusNode4.hasFocus)
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
    });
    focusNode5.addListener(() {
      if (focusNode5.hasFocus)
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                controller: scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 100.0,
                          right: 50.0,
                          bottom: 0.0,
                          left: 50.0,
                        ),
                        child: Image.asset(
                          "assets/logo.png",
                        ),
                      ),
                      isLoading
                          ? Expanded(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: formKey,
                                    child: Column(children: [
                                      TextFormField(
                                        focusNode: focusNode1,
                                        textInputAction: TextInputAction.next,
                                        controller: usernameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "username",
                                          hintStyle: TextStyle(
                                            color: MyTheme.whiteColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        focusNode: focusNode2,
                                        textInputAction: TextInputAction.next,
                                        controller: firstNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "First name",
                                          hintStyle: TextStyle(
                                            color: MyTheme.whiteColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        focusNode: focusNode3,
                                        textInputAction: TextInputAction.next,
                                        controller: lastNameController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "Last name",
                                          hintStyle: TextStyle(
                                            color: MyTheme.whiteColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        focusNode: focusNode4,
                                        textInputAction: TextInputAction.next,
                                        validator: (val) {
                                          return RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(val)
                                              ? null
                                              : "Please provide valid email";
                                        },
                                        controller: emailController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "email",
                                          hintStyle: TextStyle(
                                            color: MyTheme.whiteColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        focusNode: focusNode5,
                                        textInputAction: TextInputAction.done,
                                        validator: (val) {
                                          return val.length > 6
                                              ? null
                                              : "Password needs to be longer than 6 characters";
                                        },
                                        controller: passwordController,
                                        obscureText: true,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "password",
                                          hintStyle: TextStyle(
                                            color: MyTheme.whiteColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Timer(
                                          Duration(milliseconds: 100),
                                          () {
                                            FocusScope.of(context).unfocus();
                                            print(emailController.text);
                                            signUpUser();
                                            print(passwordController.text);
                                          },
                                        );
                                      },
                                      color: MyTheme.whiteColor,
                                      splashColor: MyTheme.orangeColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Text("Create account",
                                          style: TextStyle(
                                            color: MyTheme.orangeColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }

  _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }
}
