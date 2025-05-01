import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:news_zen/features/main/presentation/login_form/login_form_screen.dart';
import 'package:http/http.dart' as http;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState>
{
  SignupCubit():super(SignupState());

  final GlobalKey<FormState> signupformkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  void validateInput(BuildContext context){
    if(signupformkey.currentState!.validate())
    {
      _signup(context);
    }
  }

  Future<void> _signup (BuildContext context) async
  {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    var regBody = {
      "email":email,
      "password":password,
      "username":username
    };

    var response = await http.post(
      Uri.parse(registration),
      headers: {"Content-type":"application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if(jsonResponse['status'])
    {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginFormScreen()),
      );
    }

  }

  void login(BuildContext context)
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginFormScreen()),
    );
  }


}