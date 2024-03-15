import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  //static const String apiUrl = 'http://192.168.0.153:8000/api/v1';

 static Future<String?> urlAdress() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? storedIpAddress = prefs.getString('ipAddress');

  if (storedIpAddress != null && storedIpAddress.isNotEmpty) {
    return 'http://$storedIpAddress:8000/api/v1';
  } else {
    // Handle the case where ipAddress is not available or empty.
    // You might want to use a default value or show an error message.
    return null; // or return a default URL
  }
}
}
// Example usage in another part of your code:
void someFunction() async {
  String? apiUrl = await AppConfig.urlAdress();
  
}
