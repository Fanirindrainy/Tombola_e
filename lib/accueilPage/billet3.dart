import 'package:flutter/material.dart';
import 'package:tombola/service/billet.dart';
import 'package:tombola/pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:tombola/config.dart';
import 'package:tombola/accueil.dart';

class Billet3Page extends StatefulWidget {
  @override
  State<Billet3Page> createState() => _Billet3PageState();
}

List<int> selectedChiffresBillet3 = [];

class _Billet3PageState extends State<Billet3Page> {
  final int itemsPerPage = 100;
  int currentPage = 0;
  List<int> chiffresToDisplay = [];
  List<int> billets3Selectionnes = [];
  List<int> tousLesBilletsSelectionnes = [];
  List<List<int>> selectedIndexesByPage = [];
  late String selectedPath = '';
  List<int> selectedIndexes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final responseBillet3 = await TroisService.getTroisFromServer();
    if (responseBillet3.statusCode == 200) {
      setState(() {
        selectedChiffresBillet3 = List<int>.from(jsonDecode(responseBillet3.body));
       
      });
     while (selectedIndexesByPage.length < (selectedChiffresBillet3.length / itemsPerPage).ceil()) {
      selectedIndexesByPage.add([]);
    }
      filterChiffres(searchController.text); // Appel de filterChiffres avec le texte actuel du champ de recherche
    }
  }
  List<int> getBillet3List(int currentPage, int itemsPerPage) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (endIndex > selectedChiffresBillet3.length) {
      endIndex = selectedChiffresBillet3.length;
    }

    return selectedChiffresBillet3.sublist(startIndex, endIndex);
  }


void filterChiffres(String searchTerm) {
  setState(() {
    if (searchTerm.isEmpty) {

      // Ne changez que les éléments existants, ne réinitialisez pas la liste
      chiffresToDisplay = List.from(getBillet3List(currentPage, itemsPerPage));
    } else {
      chiffresToDisplay.clear();
      chiffresToDisplay.addAll(getBillet3List(currentPage, itemsPerPage)
          .where((chiffre) => chiffre.toString().contains(searchTerm.toLowerCase()))
          .toList());
    
    }
  });
}


  @override
  Widget build(BuildContext context) {
    filterChiffres(searchController.text);
  while (selectedIndexesByPage.length <= currentPage) {
    selectedIndexesByPage.add([]);
  }
     selectedIndexes = selectedIndexesByPage[currentPage];

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 6),
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.5, // Ajustez la largeur comme souhaité
        height: 40.0, // Ajustez la hauteur comme souhaité
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black, // Couleur de la bordure
            width: 2.0, // Largeur de la bordure
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              filterChiffres(value);
            },
            decoration: InputDecoration(
              hintText: 'Rechercher le numéro de billet', // Utilisez hintText au lieu de labelText
              border: InputBorder.none, // Cela supprime la bordure par défaut du TextField
            ),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          filterChiffres(searchController.text);
        },
      ),
    ],
  ),
),

          Expanded(
            child: Container(
              color: Colors.white,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemCount: chiffresToDisplay.length,
                itemBuilder: (context, index) {
                  final chiffre = chiffresToDisplay[index];
                  bool isSelected = selectedIndexes.contains(index);

                  return InkWell(
                    onTap: () {
                      handleChiffreClick(index, selectedIndexes);
                    },
                    child: Container(
                      margin: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Color(0xFF02023B) : Colors.white,
                        border: Border.all(
                          color: Color(0xFF02023B),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          chiffre.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Color(0xFF02023B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedChiffresBillet3.length > itemsPerPage)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 0
                        ? () => goToPage(currentPage - 1)
                        : null,
                    icon: Icon(Icons.arrow_left),
                  ),
                  SizedBox(width: 100),
                  IconButton(
                    onPressed: currentPage <
                            (selectedChiffresBillet3.length - 1) ~/ itemsPerPage
                        ? () => goToPage(currentPage + 1)
                        : null,
                    icon: Icon(Icons.arrow_right),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Column(
              children: [
                Text(
                  "BILLET",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Nombre de billets sélectionnés: ${tousLesBilletsSelectionnes.length}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    billets3Selectionnes = selectedIndexes
                        .map((index) => chiffresToDisplay[index])
                        .toList();

                    tousLesBilletsSelectionnes
                      ..removeWhere(
                          (billet) => chiffresToDisplay.contains(billet))
                      ..addAll(billets3Selectionnes);

                    if (tousLesBilletsSelectionnes.isEmpty) {
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
                            content: Text(
                                "Êtes-vous sûr de générer les billets là?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("NON"),
                              ),
                              TextButton(

                               onPressed: () async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: 50.0,
          height: 50.0,
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
    final response = await TroisVenduService.vendreBillets(tousLesBilletsSelectionnes);
     Navigator.pop(context); 
    if (response.statusCode == 200) {
      Navigator.pop(context); // Fermer le dialogue ici
      _showDownloadModal(context, response.body);
    } else {
      Navigator.pop(context); // Fermer le dialogue ici en cas d'échec
     
    }
  } catch (error) {
    Navigator.pop(context); // Fermer le dialogue ici en cas d'erreur
  
  }
},
child: Text("OUI"),

                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("Confirmer"),
                ),
                Text("Billets sélectionnés: $tousLesBilletsSelectionnes"),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
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

void handleChiffreClick(int index, List<int> selectedIndexes) {
  if (mounted) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }

      List<int> selectedTicketsOnThisPage = selectedIndexes
          .map((index) => chiffresToDisplay[index])
          .toList();

      tousLesBilletsSelectionnes
        ..clear()
        ..addAll(selectedTicketsOnThisPage);
    });
  }
}

void goToPage(int page) {
  
    setState(() {
      currentPage = page;
    
    });
  
}



}

