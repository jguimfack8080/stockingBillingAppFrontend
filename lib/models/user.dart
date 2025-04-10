class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String role;
  final String? idCardNumber;
  final DateTime birthDate;
  final bool isActive;
  final DateTime createdAt;
  final String? deactivationReason;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.role,
    this.idCardNumber,
    required this.birthDate,
    required this.isActive,
    required this.createdAt,
    this.deactivationReason,
  });

factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    firstName: json['first_name'] ?? '', // Valeur par défaut si null
    lastName: json['last_name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'user',
    idCardNumber: json['id_card_number'], // Peut être null
    birthDate: DateTime.parse(json['birth_date']),
    isActive: json['is_active'] ?? true,
    createdAt: DateTime.parse(json['created_at']),
    deactivationReason: json['deactivation_reason'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'role': role,
    'id_card_number': idCardNumber,
    'birth_date': birthDate.toIso8601String().split('T')[0], // Format YYYY-MM-DD
    'is_active': isActive,
  };
}

  String get fullName => '$firstName $lastName';
  
  String get status => isActive ? 'Actif' : 'Inactif';

  String get formattedBirthDate {
    return '${birthDate.day}/${birthDate.month}/${birthDate.year}';
  }

  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}