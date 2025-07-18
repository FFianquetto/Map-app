import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslatorService {
  // Reemplaza estos valores con tu clave y región de Azure
  final String apiKey = 'TU_API_KEY_AQUI';
  final String region = 'TU_REGION_AQUI';

  Future<String> translateToEnglish(String text) async {
    final url = Uri.parse('https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=en');
    final response = await http.post(
      url,
      headers: {
        'Ocp-Apim-Subscription-Key': apiKey,
        'Ocp-Apim-Subscription-Region': region,
        'Content-Type': 'application/json',
      },
      body: jsonEncode([
        {'Text': text}
      ]),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]['translations'][0]['text'] ?? '';
    } else {
      throw Exception('Error al traducir: ${response.body}');
    }
  }
} 