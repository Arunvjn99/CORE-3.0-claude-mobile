import 'package:flutter/material.dart';

/// Transaction Type enum
enum TransactionType {
  loan,
  withdrawal,
  transfer,
  rollover,
  rebalance;

  String get displayName => switch (this) {
    loan => 'Loan Request',
    withdrawal => 'Withdrawal',
    transfer => 'Fund Transfer',
    rollover => 'Rollover',
    rebalance => 'Rebalance',
  };

  IconData get icon => switch (this) {
    loan => Icons.account_balance_wallet_outlined,
    withdrawal => Icons.payments_outlined,
    transfer => Icons.swap_horiz,
    rollover => Icons.replay,
    rebalance => Icons.tune,
  };
}

/// Draft Transaction Model
class DraftTransaction {
  final String id;
  final TransactionType type;
  final DateTime lastModified;
  final String status;
  final Map<String, dynamic> savedData;
  final double? amount;
  final int completionPercentage; // 0-100

  const DraftTransaction({
    required this.id,
    required this.type,
    required this.lastModified,
    required this.status,
    required this.savedData,
    this.amount,
    required this.completionPercentage,
  });

  factory DraftTransaction.fromJson(Map<String, dynamic> json) {
    return DraftTransaction(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.loan,
      ),
      lastModified: DateTime.parse(json['lastModified'] as String),
      status: json['status'] as String,
      savedData: json['savedData'] as Map<String, dynamic>,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      completionPercentage: json['completionPercentage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'lastModified': lastModified.toIso8601String(),
      'status': status,
      'savedData': savedData,
      'amount': amount,
      'completionPercentage': completionPercentage,
    };
  }

  // Mock data for demo
  static List<DraftTransaction> mockList() {
    return [
      DraftTransaction(
        id: 'draft-1',
        type: TransactionType.loan,
        lastModified: DateTime.now().subtract(const Duration(days: 2)),
        status: 'In Progress',
        savedData: const {'step': 'eligibility'},
        amount: 5000.0,
        completionPercentage: 35,
      ),
      DraftTransaction(
        id: 'draft-2',
        type: TransactionType.withdrawal,
        lastModified: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Awaiting Documents',
        savedData: const {'step': 'documents'},
        amount: 1500.0,
        completionPercentage: 60,
      ),
    ];
  }
}
