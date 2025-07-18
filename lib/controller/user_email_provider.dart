import 'database_service.dart';

class UserEmailProvider {
  Future<void> insertUser(Map<String, dynamic> userData) async {
    final dbService = DatabaseService();
    try {
      await dbService.connect();
      await dbService.collection.insertOne(userData);
      print('Usuario insertado correctamente: ' + userData.toString());
    } catch (e) {
      print('Error al insertar usuario: $e');
    } finally {
      await dbService.closeConnection();
    }
  }
}
