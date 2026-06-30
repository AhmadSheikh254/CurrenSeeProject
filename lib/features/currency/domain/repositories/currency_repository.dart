abstract class CurrencyRepository {
  Future<List<Map<String, dynamic>>> fetchRates();
  Future<double> convertCurrency(String from, String to, double amount);
}
