import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RegisterData {
  mongo.ObjectId id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;
  String password;
  bool conectado;
  final DateTime createdAt;
  final DateTime updatedAt;

  RegisterData({
    mongo.ObjectId? id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    required this.password,
    this.conectado = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? mongo.ObjectId(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'password': password,
      'conectado': conectado,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
} 