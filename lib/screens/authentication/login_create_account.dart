//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/app.dart';
import 'package:CapstoneProject/screens/services/auth.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class LoginCreateAccount extends StatefulWidget {
  @override
  _LoginCreateAccountState createState() => _LoginCreateAccountState();
}

class _LoginCreateAccountState extends State<LoginCreateAccount> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  signUpUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        print("${val.userId}");

        Map<String, dynamic> userInfoMap = {
          "username": usernameController.text,
          "email": emailController.text,
          "firstName": "",
          "lastName": "",
          "profilePicture": "",
          "conversations": [],
        };

        databaseMethods.uploadUserInfo(userInfoMap);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomNavigatorHomePage(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading
              ? Container(
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
                            controller: usernameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "username",
                              hintStyle: TextStyle(
                                color: MyTheme.whiteColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                          TextFormField(
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
                                color: MyTheme.whiteColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                          TextFormField(
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
                                color: MyTheme.whiteColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(passwordController.text);
                          signUpUser();
                          print(emailController.text);
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
                          child: Text("Submit",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                )),
    );
  }
}
