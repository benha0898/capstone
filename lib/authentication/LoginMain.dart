//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/authentication/LoginCreateAccount.dart';
import 'package:CapstoneProject/authentication/LoginEmptyForm.dart';
import 'package:CapstoneProject/core/consts.dart';
import 'package:flutter/material.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
} 

class _LoginMainState extends State<LoginMain> {

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
              SizedBox(
                height: 8,
              ),
              GestureDetector( onTap: () {
                Navigator.of(context).push(
                 MaterialPageRoute(
                   builder: (_) => LoginEmptyForm()
                   ),
                );
              },
              child:
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.deepOrange, Colors.orange, Colors.deepOrange]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Sign in", style: TextStyle(color: Colors.white)),
              ),
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
                child: Text("Sign in with Facebook", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector( onTap: () {
                Navigator.of(context).push(
                 MaterialPageRoute(
                   builder: (_) => LoginCreateAccount()
                   ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blueGrey, Colors.white54, Colors.blueGrey]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Create Account", style: TextStyle(color: Colors.white)),
              ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ));
  }
}
