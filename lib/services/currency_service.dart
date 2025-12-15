import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'YOUR_API_KEY'; // Replace with your actual API key
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6/$_apiKey/latest/USD';
  
  // Fallback to free API if no key is provided or for testing
  static const String _freeUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  final Map<String, String> _currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'INR': 'Indian Rupee',
    'MXN': 'Mexican Peso',
    'PKR': 'Pakistani Rupee',
    // Add more as needed
  };

  Future<List<Map<String, dynamic>>> fetchRates() async {
    try {
      // Use free URL by default for demo purposes, switch to _baseUrl if you have a key
      final response = await http.get(Uri.parse(_freeUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        List<Map<String, dynamic>> currencyList = [];
        
        rates.forEach((code, rate) {
          currencyList.add({
            'code': code,
            'name': _currencyNames[code] ?? code, // Use code if name is unknown
            'rate': rate.toDouble(),
            'change': '0.0%', // API doesn't provide change in this endpoint
          });
        });

        return currencyList;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Failed to load exchange rates: $e');
    }
  }
  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$from'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        if (rates.containsKey(to)) {
          final rate = rates[to];
          return amount * rate;
        } else {
          throw Exception('Target currency not found');
        }
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }
}
