// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_be_immutable, library_private_types_in_public_api, prefer_is_not_empty, unnecessary_null_comparison

import 'package:flutter/material.dart';

class TextFieldEmail extends StatefulWidget {
  void Function(String?) onSaved;
  final TextEditingController controller;

  TextFieldEmail({
    required this.onSaved,
    required this.controller,
  });

  @override
  _TextFieldEmailState createState() => _TextFieldEmailState();
}

class _TextFieldEmailState extends State<TextFieldEmail> {
  String? _errorText;
  String? _buttonText;

  // Fonction pour vérifier la validité de l'e-mail
  bool _isEmailValid(String email) {
    return email.isNotEmpty &&
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
  }

  // Mettre à jour le texte du bouton en fonction de la validité de l'e-mail
  void _updateButtonText(String email) {
    setState(() {
      _buttonText =
          _isEmailValid(email) ? 'SE CONNECTER' : 'Adresse e-mail invalide';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          _isEmailValid(value);
          _updateButtonText(value);
        },
        onSaved: (newValue) {
          widget.onSaved?.call(newValue ?? '');
        },
        validator: (_) => _errorText, // Utilisez _errorText pour la validation
        decoration: InputDecoration(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          hintText: 'e-mail',
          hintStyle: TextStyle(
            color: Color(0xFF020238), // Couleur du texte de l'étiquette
          ),
          errorText: _errorText,
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontFamily: 'Lexend',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
