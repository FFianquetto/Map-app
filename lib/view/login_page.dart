
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../controller/user_email_provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'register_page.dart';
import '../controller/user_register_provider.dart';
import 'forgot_password_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/translator_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String titulo = 'Inicio de Sesión';
  String correoLabel = 'Correo';
  String correoHint = 'Ingresa tu correo electrónico';
  String passLabel = 'Contraseña';
  String passHint = 'Ingresa tu contraseña';
  String ingresar = 'Ingresar';
  String olvidaste = '¿Olvidaste tu contraseña?';
  String nuevo = '¿Nuevo en SuMapp? Crea tu perfil';

  Future<void> traducirAlIngles() async {
    final translator = TranslatorService();
    setState(() { titulo = 'Translating...'; });
    final t1 = await translator.translate('Inicio de Sesión', to: 'en');
    final t2 = await translator.translate('Correo', to: 'en');
    final t3 = await translator.translate('Ingresa tu correo electrónico', to: 'en');
    final t4 = await translator.translate('Contraseña', to: 'en');
    final t5 = await translator.translate('Ingresa tu contraseña', to: 'en');
    final t6 = await translator.translate('Ingresar', to: 'en');
    final t7 = await translator.translate('¿Olvidaste tu contraseña?', to: 'en');
    final t8 = await translator.translate('¿Nuevo en SuMapp? Crea tu perfil', to: 'en');
    setState(() {
      titulo = t1;
      correoLabel = t2;
      correoHint = t3;
      passLabel = t4;
      passHint = t5;
      ingresar = t6;
      olvidaste = t7;
      nuevo = t8;
    });
  }

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
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                height: 440,
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
                        titulo,
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
                            labelText: correoLabel,
                            labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                            hintText: correoHint,
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
                            labelText: passLabel,
                            labelStyle: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
                            hintText: passHint,
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
                        final correo = emailController.text.trim().toLowerCase();
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
                      child: Text(
                        ingresar,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const SizedBox(
                            height: 400,
                            child: _MapaMonterrey(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Ver Mapa MTY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF9800),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                      child: Text(
                        olvidaste,
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
                      child: Text(
                        nuevo,
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: traducirAlIngles,
                      icon: const Icon(Icons.language),
                      label: const Text('Traducir a Inglés'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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

class _MapaMonterrey extends StatelessWidget {
  const _MapaMonterrey();

  static const LatLng mtyCenter = LatLng(25.6866, -100.3161);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: mtyCenter,
        zoom: 13,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('mty_center'),
          position: mtyCenter,
          infoWindow: InfoWindow(title: 'Monterrey Centro'),
        ),
      },
      zoomControlsEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}
