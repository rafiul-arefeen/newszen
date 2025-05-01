import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:news_zen/features/main/presentation/bottom_nav/bottom_nav.dart';
import 'package:news_zen/features/main/presentation/signupform/signup_form_screen.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../login_form_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState>
{
  LoginCubit() : super (LoginState());

  final GlobalKey<FormState> formkey =GlobalKey<FormState>();


  final TextEditingController EmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void validateInput(BuildContext context)
  {
    if(formkey.currentState!.validate())
    {
      _login(context);
    }
  }

  Future<void> _login(BuildContext context) async{
    await PrefUtils.init();

    String email = EmailController.text.trim();
    String password = passwordController.text.trim();


    var regBody = {
      "email":email,
      "password":password,

    };

    var response = await http.post(
      Uri.parse(loginurl),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );
    print('apiworked');

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {
      late String dbemail;
      late String username;
      var mytoken = jsonResponse['token'];

      await PrefUtils.saveToken(mytoken);

      Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(mytoken);

      dbemail = jwtDecodedToken['email'];
      username = jwtDecodedToken['username'];

      await PrefUtils.saveEmail(dbemail);
      await PrefUtils.saveUserName(username);
      await PrefUtils.savePassword(password);


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainBottomBar()),
      );
    }



  }

  void signup(BuildContext context)
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupFormScreen()),
    );
  }

  void logout(BuildContext context) async {
    await PrefUtils.clearLoginInfo(); // Remove stored credentials

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginFormScreen()),
          (route) => false, // Clear navigation stack
    );
  }
}


