import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPrefUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";

  //saving data to shared preference

static Future<void> saveUserLoggedInSP(bool isUserLoggedIn) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharedPrefUserLoggedInKey, isUserLoggedIn);
}

static Future<void> saveUserNameSP(String username) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPrefUserNameKey, username);
}

static Future<void> saveUserEmailSP(String userEmail) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPrefUserEmailKey, userEmail);
}

//getting data from shared preference

static Future<bool> getUserLoggedInSP(bool isUserLoggedIn) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(sharedPrefUserLoggedInKey);
}

static Future<String> getUserNameSP(String username) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(sharedPrefUserNameKey);
}

static Future<String> getUserEmailSP(String userEmail) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(sharedPrefUserEmailKey);
}

}