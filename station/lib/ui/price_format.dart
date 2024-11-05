
import 'package:station/model/currency_model.dart';

class PriceFormat {

  // static String formatPrice(PriceModel price, bool withCurrencySymbol) {
  //   return formatValue(price.price, price.currency, withCurrencySymbol);
  // }

  // static String formatMarkerPrice(MarkerPrice price, bool withCurrencySymbol) {
  //   return formatValue(price.price, price.currency, withCurrencySymbol);
  // }

  static String format(double price, CurrencyModel currency, bool withCurrencySymbol) {
    if (currency.currency == CurrencyType.eur) {
      return _formatThreeDecimal(price, withCurrencySymbol ? currency.symbol : null);
    }

      return _formatOneDecimal(price, withCurrencySymbol ? currency.symbol : null);
  }

  static String _formatThreeDecimal(double price, String? currencySymbol) {
    String priceText;
    if (price == 0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = price.toStringAsFixed(3).replaceAll('.', ',');
    }

    if (priceText.length == 5) {
      priceText = priceText
          .replaceFirst('0', '\u{2070}', 4)
          .replaceFirst('1', '\u{00B9}', 4)
          .replaceFirst('2', '\u{00B2}', 4)
          .replaceFirst('3', '\u{00B3}', 4)
          .replaceFirst('4', '\u{2074}', 4)
          .replaceFirst('5', '\u{2075}', 4)
          .replaceFirst('6', '\u{2076}', 4)
          .replaceFirst('7', '\u{2077}', 4)
          .replaceFirst('8', '\u{2078}', 4)
          .replaceFirst('9', '\u{2079}', 4);
    }

    if (currencySymbol != null) {
      return "$priceText $currencySymbol";
    } else {
      return priceText;
    }
  }

  static String _formatOneDecimal(double price, String? currencySymbol) {
    String priceText;
    if (price == 0) {
      priceText = "---,-\u{207B}";
    } else {
      priceText = price.toStringAsFixed(1).replaceAll('.', ',');
    }

    if (currencySymbol != null) {
      return "$priceText $currencySymbol";
    } else {
      return priceText;
    }
  }
}
