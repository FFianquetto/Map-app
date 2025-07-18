
import 'package:flutter/material.dart';
import 'home_screen.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
                        minimumSize: Size.zero,
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
