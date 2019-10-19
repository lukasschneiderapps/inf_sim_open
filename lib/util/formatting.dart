import 'package:intl/intl.dart';
import "dart:ui" as ui;

///
/// Commonly used formatters
///

NumberFormat simpleCurrencyFormat = NumberFormat.simpleCurrency(locale: "en", decimalDigits: 0);

NumberFormat currencyFormat =
NumberFormat.compactSimpleCurrency(locale: "en", decimalDigits: 0);

NumberFormat compactFormat = NumberFormat.compact(locale: "en");