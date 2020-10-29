import 'package:CapstoneProject/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signUpUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        print("$val");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(children: [
                          TextFormField(
                            validator: (val) {
                              return val.isEmpty || val.length < 2
                                  ? "Invalid Username"
                                  : null;
                            },
                            controller: userNameTextEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(hintText: "username"),
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Invalid Email";
                            },
                            controller: emailTextEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(hintText: "email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Insufficient Password";
                            },
                            controller: passwordTextEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(hintText: "password"),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUpUser();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.pink[300]]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Sign Up"),
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
                          gradient: LinearGradient(
                              colors: [Colors.red, Colors.red[300]]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("Sign Up with Google"),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.blue[300]]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("Sign Up with Facebook"),
                      ),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            Text(
                              "Sign In Now",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )
                          ]),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ));
  }
}
