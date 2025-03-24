class BankInfo {
  final int id;
  final String bankName;
  final String bankNumber;

  BankInfo({
    required this.id,
    required this.bankName,
    required this.bankNumber,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      id: json["id"] ?? 0,
      bankName: json["bank_name"] ?? "N/A",
      bankNumber: json["bank_account_number"] ?? "N/A",
    );
  }
}
