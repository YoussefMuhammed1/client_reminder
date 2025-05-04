import 'package:flutter/material.dart';

Widget defaultFormField(
        {required TextEditingController controller,
        TextInputType? type,
        onSubmit,
        onChange,
        bool isPassword = false,
        required validate,
        required String label,
        required IconData prefix,
        IconData? suffix,
        Color? color,
        suffixPressed}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 174, 73, 102),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 174, 73, 102),
          ),
        ),
        labelStyle: TextStyle(color: Color.fromARGB(255, 174, 73, 102)),
        labelText: label,
        prefixIcon: Icon(
          prefix,
          color: color,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
