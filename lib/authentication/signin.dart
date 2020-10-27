//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.black),
                decoration:
                    InputDecoration(hintText: "email"), //InputDecoration
              ), //TextField
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(hintText: "password"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.topRight,
                child: Text("Forgot Password?"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.pink, Colors.pink[300]]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign In"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.blue[300]]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign in with Google"),
              ),
              SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account?"),
                Text(
                  "Sign Up Now",
                  style: TextStyle(decoration: TextDecoration.underline),
                )
              ]),
              SizedBox(height: 50),
            ],
          ),
        ));
  }
}
