class UserData {
  String id; // Ahora es opcional
  final String correo;
  String password;
  
  Object? status; // Opcional
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    // Registro
    this.id = '', // Se establece un valor por defecto vacío para el id
    required this.correo,
    required this.password,
    this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'status': {
        'conectado': false,
        'personalizado': false,
        'lastLogin': null,
      },
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class UserRegister {
  String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String correo;
  String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserRegister({
    this.id = '',
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.correo,
    required this.password,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
