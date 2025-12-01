// lib/services/receipt_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReceiptApiService {
  //сделать ближе к финалу авторизацию с личным токеном
  static const String _token = '28798.ODZphxrICyX7JhZq5';

  static Future<Map<String, dynamic>?> fetchFromQrString(String qr) async {
    final params = Uri.splitQueryString(qr);

    if (!params.containsKey('t') ||
        !params.containsKey('fn') ||
        !params.containsKey('i') ||
        !params.containsKey('fp')) {
      return null;
    }

    final body = {
      'fn': params['fn']!,
      'fd': params['i']!,
      'fp': params['fp']!,
      't': params['t']!.replaceAll('T', ''),
      's': (params['s'] ?? '').replaceAll('.', ''),
      'n': params['n'] ?? '1',
      'qr': '0',
      'token': _token,
    };

    try {
      final response = await http
          .post(Uri.parse('https://proverkacheka.com/api/v1/check/get'), body: body)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body);
      if (json['code'] != 1 || json['data']?['json'] == null) return null;

      final data = json['data']['json'];

      final dateStr = data['dateTime'] as String?;
      final totalSum = (data['totalSum'] as num?)?.toInt() ?? 0;
      final store = (data['user'] ?? data['retailPlace'] ?? 'Магазин').toString();
      final items = (data['items'] as List?) ?? [];

      String title = 'Покупка';
      if (items.isNotEmpty) {
        final name = items[0]['name']?.toString().trim();
        if (name != null && name.isNotEmpty) {
          title = items.length == 1 ? name : '$name и ещё ${items.length - 1}';
        }
      }

      return {
        'purchaseDate': dateStr != null ? DateTime.tryParse(dateStr) : null,
        'amount': (totalSum / 100).toStringAsFixed(2),
        'store': store,
        'title': title,
      };
    } catch (e) {
      print('Ошибка API ФНС: $e');
      return null;
    }
  }
}