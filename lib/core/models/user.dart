class User {
  final String id;
  String name;
  int avatarIndex;
  bool isDarkTheme;
  DateTime createdAt;
  DateTime? lastSeen;

  User({
    required this.id,
    required this.name,
    this.avatarIndex = 0,
    required this.createdAt,
    this.isDarkTheme = false,
    this.lastSeen,
  });

  // Конвертация в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarIndex': avatarIndex,
      'isDarkTheme': isDarkTheme,
      'createdAt': createdAt.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  // Создание из Map
  factory User.fromMap(Map<String, dynamic> map) {
  return User(
    id: (map['id'] as String?) ?? '',  // ← безопасное приведение
    name: (map['name'] as String?) ?? 'Гость',
    avatarIndex: (map['avatarIndex'] as int?) ?? 0,
    isDarkTheme: (map['isDarkTheme'] as bool?) ?? false,
    createdAt: DateTime.parse((map['createdAt'] as String?) ?? DateTime.now().toIso8601String()),
    lastSeen: map['lastSeen'] != null 
        ? DateTime.parse(map['lastSeen'] as String) 
        : null,
  );
}

  // Копирование с изменениями
  User copyWith({
    String? id,
    String? name,
    int? avatarIndex,
    bool? isDarkTheme,
    DateTime? createdAt,
    DateTime? lastSeen,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
