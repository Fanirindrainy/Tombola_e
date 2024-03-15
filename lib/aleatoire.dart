import 'package:flutter/material.dart';
import 'package:tombola/aleatoirePage/alea3.dart';
import 'package:tombola/aleatoirePage/alea5.dart';
import 'package:tombola/icon_text_row.dart';
import 'package:tombola/accueil.dart';
import 'package:tombola/scan.dart';
import 'package:tombola/service/billet.dart';
import 'dart:convert';



class AleaView extends StatefulWidget {
  const AleaView({Key? key});

  @override
  _AleaViewState createState() => _AleaViewState();
}

class _AleaViewState extends State<AleaView> with SingleTickerProviderStateMixin {
  late TabController controller;
  int selectedTab = 0;
  int totalBillets3 = 0;
  int totalBillets5 = 0;
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (controller.indexIsChanging) {
        selectedTab = controller.index;
      }
    });
    fetchData(); 
   }

 Future<void> fetchData() async {
  final responseBillet3 = await TroisService.getTroisFromServer();
  if (responseBillet3.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(responseBillet3.body);
      setState(() {
        totalBillets3 = data.length;
      });
    } catch (e) {

    }
  }

  final responseBille5 = await CinqService.getCinqFromServer();
  if (responseBille5.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(responseBille5.body);
      setState(() {
        totalBillets5 = data.length;
      });
    } catch (e) {
     
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: Center(
          child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Text(
                    "Choix aléatoire",
                    style: TextStyle(
                      color:  Color(0xFF02023B),
                      // fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                 
                ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: SizedBox(
           
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               Text(
                    "Tombola",
                    style: TextStyle(
                      color:  Color.fromRGBO(150, 205, 252, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   SizedBox(width: 5),
                  Image.asset(
                    "assets/images/celebrate.png",
                    width: 40,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
            ],
              ),
            ),
          ),
        ),
        actions: [
          Container(
            height: 56.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              
              ],
            ),
          ),
        ],
            leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: Image.asset(
          "assets/images/menu.png",
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
      ),

      ),
      drawer: Drawer(
          backgroundColor: Color(0xFFFFFFFF),
        child: SingleChildScrollView(
  child: Container(
    decoration: BoxDecoration(
      color: Color(0xFFFFFFFF),
    ),
        child: SingleChildScrollView(
          child: Column(
            children: [
            DrawerHeader(
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/images/EMIM.png",
        width: 320,
        height: 70,
        fit: BoxFit.contain,
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
                                Text(
                                  "$totalBillets3\nBillet(s) 3000 Ar",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "$totalBillets5\nBillet(s) 5000 Ar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
          ),
        ],
      ),
      // Ajoutez des espaces en bas pour ajuster la hauteur
      const SizedBox(height: 20),
    ],
  ),
),


 const SizedBox(height: 30),
              IconTextRow(
                title: "Sélection de choix",
                icon: "assets/images/sele.png",
                  onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                    );
                  },
              ),
              IconTextRow(
                title: "Choix aléatoire",
                icon: "assets/images/ale.png",
                onTap: () {
                    Navigator.pop(context);
                  },
              ),
              IconTextRow(
                title: "Scan QR code",
                icon: "assets/images/qr1.png",
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanView()),
                    );
                },
              ),
            ],
          ),
        ),
      ),
      
      ),
      ),
      
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight - 15,
            child: TabBar(
              controller: controller,
              indicatorColor: Color(0xFF02023B),
              indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 20),
              isScrollable: true,
              labelColor: Color(0xFF02023B),
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  text: "Billets de 3000 Ar",
                ),
                Tab(
                  text: "Billets de 5000 Ar",
                ),
              ],
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                Alea3Page(),
                Alea5Page(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}