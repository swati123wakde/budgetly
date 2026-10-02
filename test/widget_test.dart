import 'package:budgetly/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CurrencyFormatter formats with separators and sign', () {
    expect(CurrencyFormatter.format(4820.5), r'$4,820.50');
    expect(CurrencyFormatter.format(-86.4), r'-$86.40');
    expect(CurrencyFormatter.format(3200, showSign: true), r'+$3,200.00');
  });
}