import 'dart:convert';
import 'dart:io';

class L10nHelper {
  static Future<void> checkDuplicateKeys() async {
    final enFile = File('lib/l10n/app_en.arb');
    final zhFile = File('lib/l10n/app_zh.arb');
    
    final enJson = jsonDecode(await enFile.readAsString());
    final zhJson = jsonDecode(await zhFile.readAsString());
    
    final enKeys = enJson.keys.where((k) => !k.startsWith('@')).toSet();
    final zhKeys = zhJson.keys.where((k) => !k.startsWith('@')).toSet();
    
    final missingInZh = enKeys.difference(zhKeys);
    final missingInEn = zhKeys.difference(enKeys);
    
    if (missingInZh.isNotEmpty) {
      print('Missing in zh.arb: $missingInZh');
    }
    
    if (missingInEn.isNotEmpty) {
      print('Missing in en.arb: $missingInEn');
    }
  }
} 