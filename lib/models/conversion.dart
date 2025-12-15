class Conversion {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final DateTime date;

  Conversion({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.date,
  });

  // Convert Conversion to JSON
  Map<String, dynamic> toJson() => {
    'fromCurrency': fromCurrency,
    'toCurrency': toCurrency,
    'amount': amount,
    'result': result,
    'date': date.toIso8601String(),
  };

  // Create Conversion from JSON
  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
    fromCurrency: json['fromCurrency'],
    toCurrency: json['toCurrency'],
    amount: json['amount'],
    result: json['result'],
    date: DateTime.parse(json['date']),
  );
}
