// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, sort_child_properties_last, non_constant_identifier_names, unused_local_variable, unused_element, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({required this.colour, required this.title, required this.onPressed});
  final Color? colour;
  final String? title;
  final  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$title',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
