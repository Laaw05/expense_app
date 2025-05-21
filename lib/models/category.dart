class Category {
  final String id;
  final String name;
  final String type; // 'income' hoặc 'expense'
  final String icon;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
