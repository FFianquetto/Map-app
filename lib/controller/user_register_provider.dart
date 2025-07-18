import 'database_service.dart';
import '../model/register_data.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class UserRegisterProvider {
  Future<void> insertRegisterData(RegisterData registerData) async {
    final dbService = DatabaseService();
    try {
      await dbService.connect();
      await dbService.registerCollection.insertOne({
        '_id': registerData.id,
        ...registerData.toMap(),
      });
      print('Usuario registrado correctamente: ${registerData.toMap()}');
    } catch (e) {
      print('Error al registrar usuario: $e');
    } finally {
      await dbService.closeConnection();
    }
  }

  Future<Map<String, dynamic>?> findByCorreo(String correo) async {
    final dbService = DatabaseService();
    try {
      await dbService.connect();
      final user = await dbService.registerCollection.findOne({'correo': correo});
      return user;
    } catch (e) {
      print('Error al buscar usuario por correo: $e');
      return null;
    } finally {
      await dbService.closeConnection();
    }
  }

  Future<Map<String, dynamic>?> findById(dynamic id) async {
    final dbService = DatabaseService();
    try {
      await dbService.connect();
      final mongo.ObjectId objectId = id is mongo.ObjectId ? id : mongo.ObjectId.parse(id.toString());
      final user = await dbService.registerCollection.findOne({'_id': objectId});
      return user;
    } catch (e) {
      print('Error al buscar usuario por id: $e');
      return null;
    } finally {
      await dbService.closeConnection();
    }
  }

  Future<void> updateStatusLogin(dynamic id, bool conectado) async {
    final dbService = DatabaseService();
    try {
      await dbService.connect();
      final mongo.ObjectId objectId = id is mongo.ObjectId ? id : mongo.ObjectId.parse(id.toString());
      await dbService.registerCollection.updateOne(
        {'_id': objectId},
        {
          ' 24set': {
            'conectado': conectado,
          }
        },
      );
    } catch (e) {
      print('Error al actualizar status login: $e');
    } finally {
      await dbService.closeConnection();
    }
  }

  Future<void> closeSession(dynamic id) async {
    await updateStatusLogin(id, false);
  }
} 