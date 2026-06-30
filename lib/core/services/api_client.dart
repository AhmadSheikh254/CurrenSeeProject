import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${AppConstants.baseApiUrl}$endpoint');
    try {
      final response = await _client.get(uri);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Network error or server is unreachable: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized access');
      case 403:
        throw Exception('Forbidden access');
      case 500:
      default:
        throw Exception('Server error: ${response.statusCode}');
    }
  }
}
