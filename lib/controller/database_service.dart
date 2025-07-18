import 'package:mongo_dart/mongo_dart.dart';
import 'package:logger/logger.dart';
import 'dart:math'; // Para generar el token

// Recupera
class DatabaseService {
  static const String mongoUri =
      'mongodb://fernandocancino2004:Adolfo2004@FerCluster-shard-00-00.mbwqv.mongodb.net:27017,FerCluster-shard-00-01.mbwqv.mongodb.net:27017,FerCluster-shard-00-02.mbwqv.mongodb.net:27017/SuMappDb?ssl=true&replicaSet=atlas-xxxxx-shard-0&authSource=admin&retryWrites=true&w=majority';

  static const String dbName = 'SuMappDb';
  static const String loginCollectionName = 'Login';
  static const String sessionCollectionName = 'Login';

  late Db db;
  late DbCollection collection;
  late DbCollection sessionCollection;
  late DbCollection coursesCollection;
  late DbCollection enrollmentsCollection;
  final logger = Logger();

  Future<void> connect() async {
    try {
      db = Db(mongoUri);
      await db.open();
      collection = db.collection(loginCollectionName); // Usar Login
      sessionCollection = db.collection(sessionCollectionName);
      logger.i(
          'Conexión establecida a MongoDB Atlas en la base de datos $dbName');
    } catch (e) {
      logger.e('Error al conectar con MongoDB Atlas: $e');
    }
  }

  // Método para registrar sesión en la colección de sesiones
  Future<void> logSession({
    required ObjectId userId,
    required String ip,
    required String userAgent,
  }) async {
    try {
      await connect();

      final token = _generateToken();
      final createdAt = DateTime.now();
      final expiresAt = createdAt.add(const Duration(days: 7));

      final sessionData = {
        'userId': userId,
        'token': token,
        'device': {
          'ip': ip,
          'userAgent': userAgent,
        },
        'createdAt': createdAt,
        'expiresAt': expiresAt,
      };

      await sessionCollection.insertOne(sessionData);

      logger.i('Sesión registrada exitosamente: $sessionData');
      closeConnection();
    } catch (e) {
      logger.e('Error al registrar sesión: $e');
      closeConnection();
    }
  }

  // Método para generar un token aleatorio
  String _generateToken() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(32, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  // Cerrar la conexión
  Future<void> closeConnection() async {
    try {
      await db.close();
      logger.i('Conexión cerrada');
    } catch (e) {
      logger.e('Error al cerrar la conexión: $e');
    }
  }
}
