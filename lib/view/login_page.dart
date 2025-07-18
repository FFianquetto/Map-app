
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../controller/user_email_provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'register_page.dart';
import '../controller/user_register_provider.dart';
import 'forgot_password_page.dart';

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
                        // Validar que el correo exista en Register
                        final registerProvider = UserRegisterProvider();
                        final userInRegister = await registerProvider.findByCorreo(correo);
                        if (userInRegister == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'El correo no está registrado como usuario de la aplicación.',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red[700],
                              duration: Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          );
                          return;
                        }
                        // Validar que la contraseña coincida
                        if (userInRegister['password'] != password) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'La contraseña es incorrecta.',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: Colors.red[700],
                              duration: Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          );
                          return;
                        }
                        // userInRegister['_id'] es el id real del usuario (ObjectId)
                        await registerProvider.updateStatusLogin(userInRegister['_id'] as mongo.ObjectId, true);
                        final loginProvider = UserEmailProvider();
                        await loginProvider.insertUser({
                          'correo': correo,
                          'loginAt': DateTime.now(),
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen(userId: userInRegister['_id'] as mongo.ObjectId)),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18, fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        '¿Nuevo en SuMapp? Crea tu perfil',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontFamily: 'Poppins'),
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
