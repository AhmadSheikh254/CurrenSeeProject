class Conversion {
  final String? id;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final DateTime date;
  final bool isSaved;

  Conversion({
    this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.date,
    this.isSaved = false,
  });

  // Convert Conversion to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'fromCurrency': fromCurrency,
    'toCurrency': toCurrency,
    'amount': amount,
    'result': result,
    'date': date.toIso8601String(),
    'isSaved': isSaved,
  };

  // Create Conversion from JSON
  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
    id: json['id'],
    fromCurrency: json['fromCurrency'],
    toCurrency: json['toCurrency'],
    amount: json['amount'],
    result: json['result'],
    date: DateTime.parse(json['date']),
    isSaved: json['isSaved'] ?? false,
  );
}
