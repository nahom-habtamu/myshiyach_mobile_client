import 'package:intl/intl.dart';

class PriceFormatterUtil {
  static String formatToPrice(double price) {
    var formatter = NumberFormat('#,###,###,###,000');
    if (price < 1000) {
      return price.toString();
    }
    return formatter.format(price);
  }

  static String deformatToPureNumber(String priceString) {
    return priceString.replaceAll(",", "");
  }
}
