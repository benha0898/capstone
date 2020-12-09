//import 'package:CapstoneProject/widgets/widgets.dart';
import 'dart:async';

import 'package:CapstoneProject/screens/authentication/login_create_account.dart';
import 'package:CapstoneProject/screens/authentication/login_empty_form.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        Timer(
                          Duration(milliseconds: 100),
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginEmptyForm()),
                          ),
                        );
                      },
                      color: MyTheme.whiteColor,
                      splashColor: MyTheme.yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Sign in",
                          style: TextStyle(
                            color: MyTheme.yellowColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        Timer(
                          Duration(milliseconds: 100),
                          () => print("Sign in with Google"),
                        );
                      },
                      color: MyTheme.whiteColor,
                      splashColor: MyTheme.redColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Sign in with Google",
                          style: TextStyle(
                            color: MyTheme.redColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        Timer(
                          Duration(milliseconds: 100),
                          () => print("Sign in with Facebook"),
                        );
                      },
                      color: MyTheme.whiteColor,
                      splashColor: MyTheme.blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Sign in with Facebook",
                          style: TextStyle(
                            color: MyTheme.blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        Timer(
                          Duration(milliseconds: 100),
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => LoginCreateAccount()),
                          ),
                        );
                      },
                      color: MyTheme.whiteColor,
                      splashColor: MyTheme.orangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("Create Account",
                          style: TextStyle(
                            color: MyTheme.orangeColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ));
  }
}
