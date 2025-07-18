import 'package:flutter/material.dart';
import '../model/register_data.dart';
import 'verify_page.dart';
import '../controller/user_register_provider.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  String generateCode(int length) {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10).toString()).join();
  }

  Future<void> sendCode() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final correo = emailController.text.trim();
    if (correo.isEmpty) {
      setState(() {
        errorMessage = 'Por favor ingresa tu correo.';
        isLoading = false;
      });
      return;
    }
    final provider = UserRegisterProvider();
    final userMap = await provider.findByCorreo(correo);
    if (userMap == null) {
      setState(() {
        errorMessage = 'No existe un usuario con ese correo.';
        isLoading = false;
      });
      return;
    }
    final user = RegisterData(
      id: userMap['_id'],
      nombre: userMap['nombre'],
      apellido: userMap['apellido'],
      telefono: userMap['telefono'],
      correo: userMap['correo'],
      password: userMap['password'],
      conectado: userMap['conectado'] ?? false,
      createdAt: userMap['createdAt'],
      updatedAt: userMap['updatedAt'],
    );
    final code = generateCode(6);
    // ENVÍO REAL DE CORREO CON SENDGRID VIA HTTP
    final apiKey = 'TU_API_KEY_SENDGRID'; // <-- PON AQUÍ TU API KEY
    final fromEmail = 'tucorreo@tudominio.com'; // <-- Cambia por tu correo remitente verificado en SendGrid
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final body = jsonEncode({
      'personalizations': [
        {
          'to': [ {'email': correo} ],
          'subject': 'Código de verificación'
        }
      ],
      'from': { 'email': fromEmail },
      'content': [
        {
          'type': 'text/plain',
          'value': 'Tu código de verificación es: $code'
        }
      ]
    });
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 202) {
      setState(() {
        errorMessage = 'Error al enviar el correo. Intenta más tarde.';
        isLoading = false;
      });
      return;
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPage(user: user, verificationCode: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Recuperar contraseña'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresa tu correo para recuperar tu contraseña',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : sendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar código', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 