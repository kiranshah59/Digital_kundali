class GuruQuotaModel {
  final String plan; // "free" | "paid"
  final int used;
  final int limit;
  final String resets; // "never" | "monthly"

  GuruQuotaModel({
    required this.plan,
    required this.used,
    required this.limit,
    required this.resets,
  });

  factory GuruQuotaModel.fromJson(Map<String, dynamic> json) {
    return GuruQuotaModel(
      plan: json['plan'] ?? 'free',
      used: int.tryParse(json['used']?.toString() ?? '0') ?? 0,
      limit: json['limit'] != null 
          ? (int.tryParse(json['limit'].toString()) ?? 0) 
          : (json['plan'] == 'paid' ? 99999 : 3),
      resets: json['resets'] ?? 'never',
    );
  }

  bool get isLimitReached => used >= limit;
}
