import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final void Function()? onTap;
  final TextInputType keyboardType; 
  final bool readOnly; 
  final Color? fillColor; 
  final Color? textColor; 

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.readOnly = false, 
    this.fillColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: TextStyle(color: textColor), 
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
