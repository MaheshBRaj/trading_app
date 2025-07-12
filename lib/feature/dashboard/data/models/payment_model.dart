class Payout {
  final String id;
  final String beneficiaryName;
  final String accountNumber;
  final String ifsc;
  final double amount;
  final DateTime createdAt;

  Payout({
    required this.id,
    required this.beneficiaryName,
    required this.accountNumber,
    required this.ifsc,
    required this.amount,
    required this.createdAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] ?? '',
      beneficiaryName: json['beneficiaryName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifsc: json['ifsc'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiaryName': beneficiaryName,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
