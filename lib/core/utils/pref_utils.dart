import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

import '../../features/main/presentation/login_form/login_form_screen.dart';

class PrefUtils{
  static SharedPreferences? _sharedPreferences;

  PrefUtils(){
    SharedPreferences.getInstance().then((value)
    {
      _sharedPreferences = value ;
    });
  }

  static Future<void> _ensureInitialized() async {
    if (_sharedPreferences == null) {
      await init();
    }
  }

  static Future<void> init() async{
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> clearPreferencesData() async {
    await _sharedPreferences?.clear();
  }

  static Future<void> saveEmail(String email) async {
    await _ensureInitialized();
    await _sharedPreferences?.setString('email', email);
  }
  static Future<void> saveUserName(String userName) async {
    await _ensureInitialized();
    await _sharedPreferences?.setString('username', userName);
  }

  /// Save password
  static Future<void> savePassword(String password) async {
    await _ensureInitialized();
    await _sharedPreferences?.setString('password', password);
  }

  /// Save token
  static Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _sharedPreferences?.setString('token', token);
  }

  /// Retrieve email
  static Future<String?> getEmail() async {
    await _ensureInitialized();
    return _sharedPreferences?.getString('email');
  }

  /// Retrieve username
  static Future<String?> getUserName() async {
    await _ensureInitialized();
    return _sharedPreferences?.getString('username');
  }

  /// Retrieve password
  static Future<String?> getPassword() async {
    await _ensureInitialized();
    return _sharedPreferences?.getString('password');
  }

  // Clear all login-related information
  static Future<void> clearLoginInfo() async {
    await _ensureInitialized();
    await _sharedPreferences?.remove('email'); // Remove email
    await _sharedPreferences?.remove('username'); // Remove username
    await _sharedPreferences?.remove('password'); // Remove password
    await _sharedPreferences?.remove('token'); // Remove token (if applicable)
  }

  void logout(BuildContext context) async {
    //await PrefUtils.clearLoginInfo(); // Remove stored credentials

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginFormScreen()),
          (route) => false, // Clear navigation stack
    );
  }
}
