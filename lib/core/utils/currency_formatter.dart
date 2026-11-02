/// Minimal currency formatter (avoids pulling in `intl` for one use).
abstract final class CurrencyFormatter {
  static String format(double value, {bool showSign = false, String symbol = r'$'}) {
    final abs = value.abs();
    final parts = abs.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
    );
    final sign = value < 0 ? '-' : (showSign ? '+' : '');
    return '$sign$symbol$whole.${parts[1]}';
  }
}