import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Fruits',
      'error_connection': 'Im sorry, Please check Your internet connection',
      'show_quantity': 'Show Quantity',
      'total_is': '%s quantity is %s',
      'cancel': 'Cancel',
      'total': 'Total %s',
      'currency_format': 'Rp #,###',
    },
    'id': {
      'title': 'Daftar Buah',
      'error_connection': 'Maaf, Mohon periksa koneksi internet Anda',
      'show_quantity': 'Tampilkan Jumlah',
      'total_is': '%s berjumlah %s',
      'cancel': 'Keluar',
      'price_format': 'Keluar',
      'total': 'total %s',
      'currency_format': 'Rp. #,###',
    },
  };

  static List<String> languages ()=> _localizedValues.keys.toList();

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }

  String get errorConnection {
    return _localizedValues[locale.languageCode]!['error_connection']!;
  }

  String get showQuantity {
    return _localizedValues[locale.languageCode]!['show_quantity']!;
  }

  String get cancel {
    return _localizedValues[locale.languageCode]!['cancel']!;
  }

  String get currencyFormat {
    return _localizedValues[locale.languageCode]!['currency_format']!;
  }

  String total(String text1) {
    return _localizedValues[locale.languageCode]!['total']!
    .replaceFirst('%s', text1);
  }

  String totalIs(String text1, String text2) {
    return _localizedValues[locale.languageCode]!['total_is']!
    .replaceFirst('%s', text1)
    .replaceFirst('%s', text2);
  }
}