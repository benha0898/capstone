//import 'package:CapstoneProject/widgets/widgets.dart';
import 'dart:async';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/user.dart';
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
  DatabaseService db = DatabaseService();
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods dbMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  signInUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        print("Auth id: ${val.userId}");

        db.getUserById(val.userId).then((value) {
          User user = User.fromSnapshot(value);
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

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Timer(
          Duration(milliseconds: 500),
          () {
            _scrollToBottom();
            print("I scrolled to ${scrollController.position.maxScrollExtent}");
          },
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
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
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 200.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      focusNode: focusNode,
                                      textInputAction: TextInputAction.next,
                                      validator: (val) {
                                        return RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val)
                                            ? null
                                            : "Please provide valid email";
                                      },
                                      controller: emailController,
                                      style: TextStyle(
                                        color: MyTheme.whiteColor,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "email",
                                        hintStyle: TextStyle(
                                          color: MyTheme.whiteColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: Colors.white54),
                                    )),
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
                                              signInUser();
                                              print(passwordController.text);
                                            },
                                          );
                                        },
                                        color: MyTheme.whiteColor,
                                        splashColor: MyTheme.yellowColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Text("Sign in",
                                            style: TextStyle(
                                              color: MyTheme.yellowColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
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