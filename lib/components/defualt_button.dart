import 'package:flutter/material.dart';

Widget defualtButton(
    {double width = double.infinity,
    Color background = Colors.blue,
    required function,
    required String text}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: background,
    ),
    width: width,
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
