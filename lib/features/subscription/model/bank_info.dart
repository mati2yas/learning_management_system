class BankInfo {
  final int id;
  final String bankName;
  final String accountNumber;
  final String accountName;

  BankInfo({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      id: json["id"] ?? 0,
      bankName: json["bank_name"] ?? "N/A",
      accountName: json["acount_name"] ?? "N/A",
      accountNumber: json["bank_account_number"] ?? "N/A",
    );
  }
}
