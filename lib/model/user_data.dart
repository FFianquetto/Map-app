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
