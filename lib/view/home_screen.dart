import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/user_register_provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class HomeScreen extends StatefulWidget {
  final mongo.ObjectId userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nombreUsuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final provider = UserRegisterProvider();
    final user = await provider.findById(widget.userId);
    print('Usuario encontrado: $user');
    setState(() {
      nombreUsuario = user != null ? user['nombre'] : null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colores de referencia
    const Color fondoClaro = Color(0xFFF5F6FA);
    const Color appBarColor = Color(0xFFC7CBDC);
    const Color naranja = Color(0xFFFF9800);
    const Color textoPrincipal = Colors.black87;
    const Color textoSecundario = Colors.black54;

    // Responsive: ancho de pantalla
    final double anchoPantalla = MediaQuery.of(context).size.width;
    final double altoPantalla = MediaQuery.of(context).size.height;
    final bool esPantallaGrande = anchoPantalla > 900;
    final bool esTablet = anchoPantalla > 600 && anchoPantalla <= 900;

    // Limitar el ancho máximo del contenido
    final double maxContentWidth = esPantallaGrande ? 900 : (esTablet ? 700 : 400);

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 40),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: isLoading
                ? const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontFamily: 'Brandan',
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 1.1,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontFamily: 'Brandan',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (nombreUsuario != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          nombreUsuario!,
                          style: const TextStyle(
                            fontFamily: 'Brandan',
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: esPantallaGrande ? 32 : (esTablet ? 24 : 18),
              left: esPantallaGrande ? 32 : (esTablet ? 18 : 8),
              right: esPantallaGrande ? 32 : (esTablet ? 18 : 8),
              bottom: esPantallaGrande ? 32 : 18,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: esPantallaGrande
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Texto a la izquierda
                        Expanded(
                          flex: 2,
                          child: _TextoBienvenida(
                            naranja: naranja,
                            textoPrincipal: textoPrincipal,
                            textoSecundario: textoSecundario,
                            grande: true,
                          ),
                        ),
                        const SizedBox(width: 40),
                        // Imagen a la derecha
                        Expanded(
                          flex: 2,
                          child: _ImagenDecorativa(maxHeight: 390),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _ImagenDecorativa(maxHeight: esTablet ? 260 : 180),
                        const SizedBox(height: 32),
                        _TextoBienvenida(
                          naranja: naranja,
                          textoPrincipal: textoPrincipal,
                          textoSecundario: textoSecundario,
                          grande: esTablet,
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

class _TextoBienvenida extends StatelessWidget {
  final Color naranja;
  final Color textoPrincipal;
  final Color textoSecundario;
  final bool grande;
  const _TextoBienvenida({required this.naranja, required this.textoPrincipal, required this.textoSecundario, this.grande = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Brandan',
              fontSize: grande ? 50 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: [
              const TextSpan(text: 'El sistema flexible para optimizar\ntus procesos de '),
              TextSpan(
                text: 'supervisión y\nmantenimiento',
                style: TextStyle(color: naranja),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Transforma tus operaciones con nuestro software y facilita el cumplimiento normativo, prolonga la vida útil de tus activos y garantiza espacios seguros y confortables.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: grande ? 30: 24, 
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: grande ? 550 : 440,
          height: grande ? 50: 66,
          child: ElevatedButton(
            onPressed: () async {
              final Uri url = Uri.parse('http://www.sumapp.cloud/');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('No se pudo abrir la página web');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: naranja,
              foregroundColor: textoPrincipal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: naranja, width: 2),
              ),
              elevation: 0,
            ),
            child: Text(
              '¡Visita nuestra página web aquí!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: grande ? 24 : 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagenDecorativa extends StatelessWidget {
  final double maxHeight;
  const _ImagenDecorativa({this.maxHeight = 220});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/image.gif',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
