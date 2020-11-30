//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/screens/user_file/user_search.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class LoginEmptyForm extends StatefulWidget {
  @override
  _LoginEmptyFormState createState() => _LoginEmptyFormState();
}

class _LoginEmptyFormState extends State<LoginEmptyForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.mainColor,
        body: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Username"),
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: "Password"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                  child: Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white54),
              )),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserSearch()),
                  );
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
