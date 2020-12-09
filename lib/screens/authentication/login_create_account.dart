//import 'package:CapstoneProject/widgets/widgets.dart';
import 'package:CapstoneProject/app.dart';
import 'package:CapstoneProject/screens/services/auth.dart';
import 'package:CapstoneProject/screens/services/constants.dart';
import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/screens/services/helper_functions.dart';
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
  HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

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

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        print("${val.userId}");
        print(Constants.myUsername);

        databaseMethods.uploadUserInfo(userInfoMap);

        //HelperFunctions.getUserLoggedInSP(true);

      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomNavigatorHomePage(),
            ));
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
              child:
              Column(children: [
                TextFormField(
                  validator: (val){
                    return val.length > 0 ? null : "Field cannot be empty";
                  },
                  controller: firstNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "first name"),
                ),
                TextFormField(
                  validator: (val){
                    return val.length > 0 ? null : "Field cannot be empty";
                  },
                  controller: lastNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "last name"),
                ),
                TextFormField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "username"),
                ),
                TextFormField(
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please provide valid email";
                  },
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "email",
                    ),
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
              ]),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: (){
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
                  child: Text("Sign Up",
                      style: TextStyle(color: Colors.white)),
              )),
              SizedBox(height: 50),
          ])));
  }
}
