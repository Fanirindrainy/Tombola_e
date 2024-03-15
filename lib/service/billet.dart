import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:tombola/config.dart';

class TroisService {
  TroisService();
  static Future<http.Response> getTroisFromServer() async {
    final String apiPath = 'troismille/false';
    final String? url = await AppConfig
          .urlAdress(); // Appel de la fonction urlAdress de la classe AppConfig

    return http.get(Uri.parse('$url/$apiPath'));
  }
}

class CinqService {
  CinqService();
  static Future<http.Response> getCinqFromServer() async {
    final String apiPath = 'cinqmille/false';
 final String? url = await AppConfig
          .urlAdress();
    return http.get(Uri.parse('$url/$apiPath'));
  }
}

class TroisVenduService {
  TroisVenduService();

  static Future<http.Response> vendreBillets(
      List<int> billetsSelectionnes) async {
    final String apiPath = 'vendu3000';
    final String? url = await AppConfig
          .urlAdress(); 
    final response = await http.post(
      Uri.parse('$url/$apiPath'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'TicketTroisMille': billetsSelectionnes}),
    );

    return response;
  }
}

class CinqVenduService {
  CinqVenduService();
  static Future<http.Response> vendreBillets(
      List<int> billetsSelectionnes) async {
    final String apiPath = 'vendu5000';
     final String? url = await AppConfig
          .urlAdress();
    final response = await http.post(
      Uri.parse('$url/$apiPath'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'TicketCinqMille': billetsSelectionnes}),
    );
    return response;
  }
}
