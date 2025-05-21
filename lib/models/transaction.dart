class Transaction {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String note;
  final String type; // 'income' hoặc 'expense'
  final DateTime date;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.note,
    required this.type,
    required this.date,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] ?? '',
      type: json['type'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'note': note,
      'type': type,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
