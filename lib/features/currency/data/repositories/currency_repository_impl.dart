import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final http.Client _client = http.Client();
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
  };

  @override
  Future<List<Map<String, dynamic>>> fetchRates() async {
    try {
      final response = await _client.get(Uri.parse(_freeUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        List<Map<String, dynamic>> currencyList = [];
        rates.forEach((code, rate) {
          currencyList.add({
            'code': code,
            'name': _currencyNames[code] ?? code,
            'rate': rate.toDouble(),
            'change': '0.0%',
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

  @override
  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final response = await _client.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$from'));
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
