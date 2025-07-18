import 'package:flutter/material.dart';
import '../controller/user_register_provider.dart';
import '../model/register_data.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Colores y estilos de HomeScreen
    const Color fondoClaro = Color(0xFFF5F6FA);
    const Color appBarColor = Color(0xFFC7CBDC);
    const Color naranja = Color(0xFFFF9800);
    const Color textoPrincipal = Colors.black87;
    //const Color textoSecundario = Colors.black54;

    final double anchoPantalla = MediaQuery.of(context).size.width;
    final bool esPantallaGrande = anchoPantalla > 900;
    final bool esTablet = anchoPantalla > 600 && anchoPantalla <= 900;
    final double maxContentWidth = esPantallaGrande
        ? 900
        : (esTablet ? 700 : 400);

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(
            fontFamily: 'Brandan',
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: esPantallaGrande ? 32 : (esTablet ? 24 : 18),
              horizontal: esPantallaGrande ? 32 : (esTablet ? 18 : 8),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen decorativa
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      maxHeight: 180,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/worker.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nombreController,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Ingresa tu nombre',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: apellidoController,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Ingresa tu apellido',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: telefonoController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Ingresa tu número de teléfono',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Ingresa tu correo electrónico',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Crea una contraseña',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      hintText: 'Repite tu contraseña',
                      hintStyle: const TextStyle(fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final nombre = nombreController.text.trim();
                              final apellido = apellidoController.text.trim();
                              final telefono = telefonoController.text.trim();
                              final correo = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirmPassword = confirmPasswordController
                                  .text
                                  .trim();
                              if (nombre.isEmpty ||
                                  apellido.isEmpty ||
                                  telefono.isEmpty ||
                                  correo.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Por favor completa todos los campos.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (password.length < 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'La contraseña debe tener al menos 6 caracteres.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Las contraseñas no coinciden.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              final registerData = RegisterData(
                                id: mongo.ObjectId(),
                                nombre: nombre,
                                apellido: apellido,
                                telefono: telefono,
                                correo: correo,
                                password: password,
                              );
                              final userProvider = UserRegisterProvider();
                              await userProvider.insertRegisterData(
                                registerData,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              if (!mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '¡Registro exitoso! Ahora puedes iniciar sesión.',
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: naranja,
                        foregroundColor: textoPrincipal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: naranja, width: 2),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Registrarse',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
