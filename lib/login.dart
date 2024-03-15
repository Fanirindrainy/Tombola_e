// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, prefer_const_declarations, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:tombola/scan.dart';
import 'package:tombola/service/TextFieldEmail.dart';
import 'package:tombola/service/TextFieldPassw.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'accueil.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String _email = '';
  String _password = '';
  String _buttonText = 'SE CONNECTER';
  bool isButtonEnabled = false;
  bool isLoading = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late String ipAddress = ''; // Etat pour stocker l'adresse IP saisie

  // Méthode pour afficher le modal

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  // Méthode pour afficher le modal
  void modalShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Saisir l\'adresse IP'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                ipAddress = value;
              });
            },
            decoration: InputDecoration(hintText: 'Adresse IP'),
          ),
          actions: <Widget>[
              TextButton(
                onPressed: () {
                  _saveIpAddress(ipAddress);
                  Navigator.of(context).pop();
                },
                child: Text('Valider'),
              ),
            ],
          );
        },
      );
    }

Future<void> _saveIpAddress(String ipAddress) async {
  if (ipAddress.isNotEmpty) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
  }
}



  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final String backgroundImage = orientation == Orientation.portrait
        ? 'assets/images/sary1.jpeg'
        : 'assets/images/sary2';
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Tombola'),
        actions: [
          IconButton(
            onPressed: () {
              // Action à eff
              //ectuer lorsqu'on appuie sur l'icône paramètre
              modalShow();
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanView()),
              );
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: SizedBox(
                          width: 280,
                          height: 242,
                          child: Image.asset(
                            'assets/images/logo EMIM 2023.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldEmail(
                      controller: _emailController,
                      onSaved: (value) {
                        _email = value ?? '';
                      },
                    ),
                    SizedBox(height: 5),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      height: 1, // Hauteur de la ligne horizontale
                      color: const Color.fromARGB(255, 90, 85, 85),
                      width: double.infinity, // Couleur de la ligne horizontale
                    ), // Espace de 10 pixels
                    SizedBox(height: 5),
                    TextFieldPass(
                      controller: _passwordController,
                      onSaved: (value) {
                        _password = value ?? '';
                      },
                    ),
                    SizedBox(height: 17), // Espace de 10 pixels
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              setState(() {
                                isLoading =
                                    true; // Activez le chargement avant l'envoi de la requête
                              });
                              debugPrint(_emailController.text);
                              debugPrint(_passwordController.text);
                              _submitForm();
                              Future.delayed(Duration(seconds: 10), () {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color(0xFF95CDFC),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              _buttonText,
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),

                    if (errorMessage.isNotEmpty)
                      Card(
                        elevation: 4.0,
                        margin: EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                  color: Colors
                                      .red), // Couleur du texte en rouge par exemple
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Vous pouvez utiliser les valeurs _username et _password comme vous le souhaitez.
      setState(() {
        isLoading = true; // Activez le chargement
      });

     final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('ipAddress');
   if (ipAddress.isNotEmpty) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
  }

print('Après _saveIpAddress');

     String? url = await AppConfig.urlAdress();
       if (url != null) {
    // Use apiUrl
    print(url);
     final String apiPath = 'login';
      final Uri apiUrl = Uri.parse('$url/$apiPath');  

      final response = await http.post(apiUrl, body: {'email': _email, 'password': _password});
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = json.decode(response.body);

        final donnee1 = data['email'];
        final donnee2 = data['Status'];
        final message = data['message'];

        debugPrint(message);

        await prefs.setString('utilisateur', json.encode(donnee1));

        errorMessage = "";
        if (donnee2 == "Admin") {
          // Affichez la fenêtre spéciale pour l'Admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          // Affichez la fenêtre normale pour les utilisateurs non-Admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ScanView()),
          );
        }
      } else {
        debugPrint('Erreur de requête. Statut : ${response.statusCode}');

        if (response.statusCode == 404) {
          debugPrint('La ressource demandée n\'a pas été trouvée.');
        } else if (response.statusCode == 500) {
          debugPrint('Erreur interne du serveur.');
        } else {
          setState(() {
            errorMessage = 'Vérifier votre nom utilisateur ou mot de passe.';
          });
          isLoading = false;
        }
      }
    }
  } else {
    print("Faniry");
  }

     
}
}