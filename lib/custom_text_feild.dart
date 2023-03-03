// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChange;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final bool isRequiredField;
  final String? error;
  final EdgeInsets padding;

  const CustomTextFiled(
      {Key? key,
        this.hint = '',
        required this.onChange,
        required this.keyboardType,
        this.isPasswordField = false,
        this.isRequiredField = false,
        this.error,
        this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder border = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.purpleAccent, width: 2));

    UnderlineInputBorder errorBorder = const UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.white));
    return Padding(
      padding: padding,
      child: TextFormField(
          keyboardType: keyboardType,
          cursorColor: Colors.purple,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.purple)),
              fillColor: Colors.purple.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              filled: true,
              hintText: isRequiredField ? '$hint' : hint,
              border: border,
              disabledBorder: border,
              enabledBorder: border,
              errorBorder: errorBorder,
              errorText: error,
              floatingLabelBehavior: FloatingLabelBehavior.never),
          autocorrect: false,
          textInputAction: TextInputAction.done,
          obscureText: isPasswordField,
          maxLines: 1,
          onChanged: onChange),
    );
  }
}