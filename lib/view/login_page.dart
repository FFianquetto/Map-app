
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../model/user_data.dart';
import '../controller/database_service.dart';
import '../controller/user_email_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 15, 47),
      body: Stack(
        children: [
          // Imagen decorativa arriba del formulario
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SizedBox(
                height: 600,
                child: Image.asset(
                  'assets/images/worker.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 50, 50, 50),
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Inicio de Sesión',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: 'Brandan',
                          fontSize: 28,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        // Campo de correo con icono
                        TextField(
                          controller: emailController,
                          style: const TextStyle(fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                            hintText: 'Ingresa tu correo electrónico',
                            hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campo de contraseña con icono
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        final correo = emailController.text.trim();
                        final password = passwordController.text.trim();
                        if (correo.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor ingresa correo y contraseña.')),
                          );
                          return;
                        }
                        if (password.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres.')),
                          );
                          return;
                        }
                        final user = UserData(
                          id: ObjectId().toHexString(),
                          correo: correo,
                          password: password,
                          status: {
                            'conectado': false,
                            'personalizado': false,
                            'lastLogin': null,
                          },
                        );
                        final userProvider = UserEmailProvider();
                        await userProvider.insertUser({
                          '_id': ObjectId.fromHexString(user.id),
                          'correo': user.correo,
                          'password': user.password,
                          'status': user.status,
                          'createdAt': user.createdAt,
                          'updatedAt': user.updatedAt,
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: null, // Sin funcionalidad
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: null, // Sin funcionalidad
                      child: const Text(
                        '¿Nuevo en SuMapp? Crea tu perfil',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
