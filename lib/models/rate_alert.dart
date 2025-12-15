class RateAlert {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double targetRate;
  final bool isAbove; // true if alert when rate > target, false if rate < target
  bool isActive;

  RateAlert({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.targetRate,
    required this.isAbove,
    this.isActive = true,
  });
}
