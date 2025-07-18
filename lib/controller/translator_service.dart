import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslatorService {
  final String googleApiKey = 'AIzaSyDWssNaPVFLiQUxjQ_sA6OkLaJBCRrjkfE';

  /// Traducción usando la API oficial de Google Cloud Translate (requiere API Key)
  Future<String> translate(String text, {String to = 'en'}) async {
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$googleApiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'target': to,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'] ?? '';
    } else {
      throw Exception('Error al traducir con Google API: \n${response.body}');
    }
  }
} 