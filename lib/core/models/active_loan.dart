/// Active Loan Model
class ActiveLoan {
  final String loanId;
  final String title;
  final DateTime originatedDate;
  final double remainingBalance;
  final double nextPaymentAmount;
  final DateTime nextPaymentDate;
  final double paidPercentage; // 0-100
  final int paymentsRemaining;
  final double originalAmount;

  const ActiveLoan({
    required this.loanId,
    required this.title,
    required this.originatedDate,
    required this.remainingBalance,
    required this.nextPaymentAmount,
    required this.nextPaymentDate,
    required this.paidPercentage,
    required this.paymentsRemaining,
    required this.originalAmount,
  });

  factory ActiveLoan.fromJson(Map<String, dynamic> json) {
    return ActiveLoan(
      loanId: json['loanId'] as String,
      title: json['title'] as String,
      originatedDate: DateTime.parse(json['originatedDate'] as String),
      remainingBalance: (json['remainingBalance'] as num).toDouble(),
      nextPaymentAmount: (json['nextPaymentAmount'] as num).toDouble(),
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] as String),
      paidPercentage: (json['paidPercentage'] as num).toDouble(),
      paymentsRemaining: json['paymentsRemaining'] as int,
      originalAmount: (json['originalAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loanId': loanId,
      'title': title,
      'originatedDate': originatedDate.toIso8601String(),
      'remainingBalance': remainingBalance,
      'nextPaymentAmount': nextPaymentAmount,
      'nextPaymentDate': nextPaymentDate.toIso8601String(),
      'paidPercentage': paidPercentage,
      'paymentsRemaining': paymentsRemaining,
      'originalAmount': originalAmount,
    };
  }

  // Mock data for demo
  factory ActiveLoan.mock() {
    return ActiveLoan(
      loanId: 'LOAN-2024-001',
      title: 'General Purpose Loan',
      originatedDate: DateTime(2024, 1, 15),
      remainingBalance: 2450.0,
      nextPaymentAmount: 148.0,
      nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
      paidPercentage: 60.0,
      paymentsRemaining: 8,
      originalAmount: 6125.0,
    );
  }
}
