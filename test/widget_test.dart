
import 'package:flutter_test/flutter_test.dart';

import 'package:fun_app/main.dart';

void main() {
  testWidgets('La pantalla de login se muestra correctamente', (WidgetTester tester) async {
    // Construye la app y muestra el widget
    await tester.pumpWidget(const MainApp());

    // Verifica que el texto 'Inicio de Sesión' esté presente
    expect(find.text('Inicio de Sesión'), findsOneWidget);
    // Verifica que los campos de correo y contraseña existan
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    // Verifica que el botón 'Ingresar' esté presente
    expect(find.text('Ingresar'), findsOneWidget);
  });
}
