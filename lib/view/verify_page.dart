import 'package:flutter/material.dart';
import '../model/register_data.dart';
import '../controller/user_register_provider.dart';

class VerifyPage extends StatefulWidget {
  final RegisterData user;
  final String verificationCode;
  const VerifyPage({super.key, required this.user, required this.verificationCode});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final int numbers = 6;
  late List<TextEditingController> numbersController;
  bool isVerifying = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    numbersController = List.generate(numbers, (_) => TextEditingController());
  }

  String getCodeFromInputs() {
    return numbersController.map((c) => c.text).join();
  }

  Future<void> verifyAndContinue() async {
    setState(() {
      isVerifying = true;
      errorMessage = null;
    });
    final code = getCodeFromInputs();
    if (code != widget.verificationCode) {
      setState(() {
        errorMessage = 'Código incorrecto. Intenta de nuevo.';
        isVerifying = false;
      });
      return;
    }
    // Actualizar en la base de datos que el usuario está verificado
    final provider = UserRegisterProvider();
    await provider.updateStatusLogin(widget.user.id, true); // O puedes crear un campo 'verificado' si lo prefieres
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/homescreen', arguments: widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Verificación de Cuenta',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontFamily: 'Brandan',
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'El código fue enviado a ${widget.user.correo}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Introduzca el código de verificación.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            numbers,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: numbersController[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (errorMessage != null)
                      Center(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                    child: const Text(
                      '<',
                      style: TextStyle(
                        fontFamily: 'Brandan',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isVerifying ? null : verifyAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    ),
                    child: isVerifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'ingresar',
                            style: TextStyle(
                              fontFamily: 'Brandan',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
