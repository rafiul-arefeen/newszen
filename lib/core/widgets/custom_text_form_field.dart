
import 'package:flutter/material.dart';

import 'package:news_zen/core/theme/colors.dart';

class CustomTextFormField extends StatelessWidget {

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool? obscureTextOn;
  final bool? borderColour;
  final String? suffixText;

  const CustomTextFormField({super.key,required this.controller,required this.validator,this.hintText,this.obscureTextOn , this.borderColour , this.suffixText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureTextOn ?? false,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          letterSpacing: 1,
        ),
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: borderColour==true ? primary_red : Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red),
          ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder:const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Colors.red),
            ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat'
          ),
          suffixIcon: SizedBox(
            width: 40, // Adjust width as needed
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  suffixText ?? '',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14, // Adjust size as needed
                    fontWeight: FontWeight.w500,
                    color: primary_red,
                  ),
                ),
              ),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
