import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  const Result({Key? key, required this.title, required this.result});

  final String title;
  final String result;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image en haut
            Image.asset(
              'assets/images/EMIM.png',
              width: 200.0,
              height: 120.0,
            ),

            SizedBox(height: 20),
            // Texte 'TOMBOLA' avec votre image 'cadeau.png'
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cadeau.png', // Remplacez par le chemin de votre image
                  width: 30.0,
                  height: 30.0,
                ),
                SizedBox(width: 10), // Espace entre le texte et l'image

                Text(
                  'TOMBOLA',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10), // Espace entre le texte et l'image

                Image.asset(
                  'assets/images/celebrate.png', // Remplacez par le chemin de votre image
                  width: 30.0,
                  height: 30.0,
                ),
              ],
            ),
            SizedBox(height: 20), // Espace entre le texte et le texte suivant

            // Texte pour afficher le numéro du billet scanné
            Text(
              'Numéro du billet scanné:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget
                  .result, // Utilisez widget.result pour accéder à la valeur de result
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
