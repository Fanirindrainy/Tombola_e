import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:tombola/accueil.dart';
import 'package:tombola/config.dart';

class PdfPage extends StatefulWidget {
  final String pdfUrl;

  const PdfPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  late String selectedPath = '';

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
                // Image.asset(
                //   'assets/images/cadeau.png',
                //   width: 30.0,
                //   height: 30.0,
                // ),
                SizedBox(width: 10),
                Text(
                 "GÉNÉRATION DE BILLETS RÉUSSIE",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
               
                // SizedBox(width: 10),
                // Image.asset(
                //   'assets/images/celebrate.png',
                //   width: 30.0,
                //   height: 30.0,
                // ),
              ],
            ),
             Text(
                 "PDF prêt à télécharger",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
            SizedBox(height: 20),
            // Texte pour afficher le numéro du billet scanné
            Text(
              widget.pdfUrl,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Ajout de l'icône de téléchargement et de la fonction de téléchargement
            IconButton(
              onPressed: () {
                _showDownloadModal(context, widget.pdfUrl);
               
              },
              icon: Icon(
                Icons.file_download,
                size: 25,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadModal(BuildContext context, pdfUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Téléchargement de : $pdfUrl',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: selectedPath),
                          decoration: InputDecoration(
                            labelText: 'Chemin de stockage',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String? path = await _browsePath();
                                if (path != null) {
                                  setState(() {
                                    selectedPath = path;
                                  });
                                }
                              },
                              icon: Icon(Icons.folder),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedPath.isNotEmpty) {
                        _downloadFile(pdfUrl, selectedPath);
                         Fluttertoast.showToast(
          msg: "Téléchargement...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Erreur : Aucun emplacement de stockage sélectionné",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                    child: Text('Télécharger'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _browsePath() async {
    String? path;

    // Obtention du chemin du répertoire
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      path = directoryPath;
    }

    return path;
  }

  Future<void> _downloadFile(String pdfUrl, String selectedPath) async {
     final String? url = await AppConfig
          .urlAdress();
    final String apiPath = '$url/download/$pdfUrl';
    try {
      final response = await http.get(Uri.parse(apiPath));

      if (response.statusCode == 200) {
        final fileSavePath = '$selectedPath/$pdfUrl';
        final file = File(fileSavePath);
        await file.writeAsBytes(response.bodyBytes);
        Fluttertoast.showToast(
          msg: "$pdfUrl téléchargé avec succès à l'emplacement : $selectedPath",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
         Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
      } else {
        Fluttertoast.showToast(
          msg: "Échec du téléchargement de $pdfUrl",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur lors du téléchargement de $pdfUrl",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
