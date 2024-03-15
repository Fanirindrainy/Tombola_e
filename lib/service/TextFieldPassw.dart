// ignore_for_file: prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class TextFieldPass extends StatefulWidget {
  void Function(String?) onSaved;
  TextEditingController controller;

  TextFieldPass({
    required this.onSaved,
    required this.controller,
  });

  @override
  State<TextFieldPass> createState() => _TextFieldPassState();
}

class _TextFieldPassState extends State<TextFieldPass> {
  bool _isObscure = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: TextFormField(
        obscureText: !_isObscure,
        controller: widget.controller,
        onSaved: (newValue) {
          widget.onSaved?.call(newValue ?? '');
        },
        decoration: InputDecoration(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          hintText: 'mot de passe',
          hintStyle: TextStyle(
            color: Color(0xFF020238), // Couleur du texte de l'étiquette
          ),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            child: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: widget.controller.text.isNotEmpty
                  ? Color(0xFF020238)
                  : Colors.white,
            ),
          ),
        ),
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
