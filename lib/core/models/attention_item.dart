import 'package:flutter/material.dart';

/// Attention Item Priority
enum AttentionPriority {
  high,
  medium,
  low;

  Color get color => switch (this) {
    high => const Color(0xFFEF4444), // Red
    medium => const Color(0xFFF59E0B), // Amber
    low => const Color(0xFF6B7280), // Gray
  };

  Color get backgroundColor => switch (this) {
    high => const Color(0xFFFEF2F2),
    medium => const Color(0xFFFFFBEB),
    low => const Color(0xFFF3F4F6),
  };
}

/// Attention Item Model
class AttentionItem {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final AttentionPriority priority;
  final IconData icon;
  final String? route;

  const AttentionItem({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.priority,
    required this.icon,
    this.route,
  });

  factory AttentionItem.fromJson(Map<String, dynamic> json) {
    return AttentionItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: AttentionPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => AttentionPriority.medium,
      ),
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'iconCode': icon.codePoint,
      'route': route,
    };
  }

  // Mock data for demo
  static List<AttentionItem> mockList() {
    return [
      AttentionItem(
        id: 'att-1',
        title: 'Loan Documents Required',
        description: 'Upload signed loan agreement to proceed.',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        priority: AttentionPriority.high,
        icon: Icons.description_outlined,
        route: '/transactions/loan/documents',
      ),
      AttentionItem(
        id: 'att-2',
        title: 'Contribution Election Update',
        description: 'Annual review of your contribution percentage.',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        priority: AttentionPriority.medium,
        icon: Icons.edit_outlined,
        route: '/enrollment/contribution',
      ),
    ];
  }
}
