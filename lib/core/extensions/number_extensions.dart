import 'package:intl/intl.dart';

extension NumberExtensions on num {
  String toCurrency([String symbol = '₹']) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: this % 1 == 0 ? 0 : 2,
    );
    return format.format(this);
  }

  String toCompactCurrency([String symbol = '₹']) {
    final format = NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: 1,
    );
    return format.format(this);
  }

  String toPercentage() {
    return '${toStringAsFixed(1)}%';
  }
}
