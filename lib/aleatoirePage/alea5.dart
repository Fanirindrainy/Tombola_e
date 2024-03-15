import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tombola/pdf.dart';
import 'package:tombola/service/billet.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:tombola/aleatoire.dart';
import 'package:tombola/config.dart';

class Alea5Page extends StatefulWidget {
  @override
  State<Alea5Page> createState() => _Alea5PageState();
}

List<int> selectedChiffresBillet5 = [];

class _Alea5PageState extends State<Alea5Page> {
  final TextEditingController _controller = TextEditingController();
  final int itemsPerPage = 56;
  final PageController _pageController = PageController();
  List<int> randomChiffres = [];
  int numberOfBilletsInt = 0;
  late String selectedPath = '';

  @override
  void initState() {
    super.initState();
    _controller.text = "0";
    fetchData();
  }

  Future<void> fetchData() async {
    final responseBillet5 = await CinqService.getCinqFromServer();
    if (responseBillet5.statusCode == 200) {
      selectedChiffresBillet5 =
          List<int>.from(jsonDecode(responseBillet5.body));
    }
  }

  static List<int> generateRandomNumbers(
      List<int> selectedChiffres, int numberOfBillets) {
    List<int> randomChiffres = [];
    Random random = Random();

    // Vérifiez si la liste sélectionnée n'est pas vide
    if (selectedChiffres.isNotEmpty) {
      for (int i = 0; i < numberOfBillets; i++) {
        // Choisissez un indice aléatoire dans la liste sélectionnée
        int randomIndex = random.nextInt(selectedChiffres.length);

        // Ajoutez le chiffre correspondant à l'indice choisi
        randomChiffres.add(selectedChiffres[randomIndex]);
      }
    }

    return randomChiffres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 6),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        'Nombre de billets à générer',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 100.0),
                    child: SpinBox(
                      key: UniqueKey(),
                      min: 0,
                      max: 1500,
                      value: randomChiffres.length.toDouble(),
                      onChanged: (value) {
                        _controller.text = value.toString();
                      },
                      direction: Axis.horizontal,
                      textStyle: TextStyle(fontSize: 16),
                      incrementIcon: Icon(Icons.add, size: 20),
                      decrementIcon: Icon(Icons.remove, size: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150.0,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _startButtonPressed();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Démarrer",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 8),
                          Image.asset(
                            "assets/images/ale.png",
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Les billets choisis: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (selectedChiffresBillet5.length > itemsPerPage)
                          Image.asset(
                            "assets/images/arow.png",
                            width: 24,
                            height: 24,
                          ),
                      ],
                    ),
                    _buildRandomChiffres(randomChiffres),
                    SizedBox(height: 10),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showConfirmationAlert();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Générer le(s) billets",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 8),
                            Image.asset(
                              "assets/images/tic1.png",
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomChiffres(List<int> randomChiffres) {
    return _buildChiffresList();
  }

  Widget _buildChiffresList() {
    return Expanded(
      child: Container(
        child: PageView.builder(
          controller: _pageController,
          itemCount: (randomChiffres.length / itemsPerPage).ceil(),
          itemBuilder: (context, index) {
            return _buildChiffresPage(index);
          },
          onPageChanged: (int page) {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildChiffresPage(int pageIndex) {
    List<int> chiffres = [];
    int startIndex = pageIndex * itemsPerPage;
    int endIndex = (pageIndex + 1) * itemsPerPage;
    endIndex =
        endIndex < randomChiffres.length ? endIndex : randomChiffres.length;

    for (int i = startIndex; i < endIndex; i++) {
      chiffres.add(randomChiffres[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        Expanded(
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: chiffres.length,
              itemBuilder: (context, index) {
                final chiffre = chiffres[index];

                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      chiffre.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _startButtonPressed() {
    double numberOfBillets =
        _controller.text.isNotEmpty ? double.parse(_controller.text) : 4;
    numberOfBilletsInt = numberOfBillets.toInt();
    randomChiffres =
        generateRandomNumbers(selectedChiffresBillet5, numberOfBilletsInt);
    setState(() {
      numberOfBilletsInt = randomChiffres.length;
    });
  }

    void _showConfirmationAlert() {
    if (randomChiffres.isEmpty) {
      Fluttertoast.showToast(
        msg: "Veuillez taper le nombre de billet que vous voulez",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Êtes-vous sûr de générer les billets là?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("NON"),
              ),
               TextButton(
                             onPressed: () async {
    // Show CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 50.0, // Adjust the size as needed
            height: 50.0, // Adjust the size as needed
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF02023B)),
              ),
            ),
          ),
        );
      },
    );

       try {
    final response =
        await CinqVenduService.vendreBillets(
            randomChiffres);
Navigator.pop(context); 
    if (response.statusCode == 200) {
       Navigator.pop(context);
      _showDownloadModal(context, response.body);

    } else {
      Navigator.pop(context);

    }
    } catch (error) {
    Navigator.pop(context);

    }
  },
                              child: Text("OUI"),
                            ),
            ],
          );
        },
      );
    }
  }

  void _generateBillets() {
    // Logique pour générer les billets ici
    // Utilisez la liste randomChiffres pour générer les billets
    // ...

    _pageController.jumpToPage(0);

    setState(() {
      numberOfBilletsInt = randomChiffres.length;
    });
  }

  void _releaseFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
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
        Navigator.of(context).pop();
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
                        MaterialPageRoute(builder: (context) => AleaView()),
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
