import 'package:flutter/material.dart';
import 'package:tombola/accueil.dart';
import 'package:tombola/login.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:tombola/login.dart';

void main() => runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade800),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'My App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/EMIM.png',
              width: 200.0,
              height: 120.0,
            ),
            FractionallySizedBox(
              widthFactor: 0.2,
              child: LinearProgressIndicator(
                color: Color.fromARGB(255, 134, 200, 253),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(150, 205, 252, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Délai de 3 secondes avant la navigation vers ScanPage
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Connexion(),
        ),
      );
    });
  }
}
