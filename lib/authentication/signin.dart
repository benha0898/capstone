//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/core/consts.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainColor,
        body: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration:
                    InputDecoration(hintText: "email"), 
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "password"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: Text("Forgot Password?", style: TextStyle(color: Colors.white54)),
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
                      LinearGradient(colors: [Colors.blueGrey, Colors.white54, Colors.blueGrey]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign In", style: TextStyle(color: Colors.white)),
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
                      LinearGradient(colors: [Colors.red[800], Colors.redAccent, Colors.red[800]]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign in with Google", style: TextStyle(color: Colors.white)),
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
                      LinearGradient(colors: [Colors.blue[800], Colors.blueAccent, Colors.blue[800]]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Continue with Facebook", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account?", style: TextStyle(color: Colors.white54)),
                Text(
                  "Sign Up Now",
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.white70),
                )
              ]),
              SizedBox(height: 50),
            ],
          ),
        ));
  }
}