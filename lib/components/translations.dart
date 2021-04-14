import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'id': {
          'confirmed': 'Terkonfirmasi',
          'Deaths': 'Meninggal',
          'Recovered': 'Sembuh',
          'Active': 'Aktif'
        },
        'en': {
          'Confirmed': 'Confirmed',
          'Deaths': 'Deaths',
          'Recovered': 'Recovered',
          'Active': 'Active'
        }
      };
}
