import 'package:flutter/material.dart';

/// Priority levels for Next Best Actions
enum ActionPriority {
  required,
  suggested;

  Color get color => switch (this) {
    required => const Color(0xFFEF4444), // Red
    suggested => const Color(0xFF6B7280), // Gray
  };

  Color get backgroundColor => switch (this) {
    required => const Color(0xFFFEF2F2),
    suggested => const Color(0xFFF3F4F6),
  };

  String get badgeText => switch (this) {
    required => 'REQUIRED',
    suggested => 'SUGGESTED',
  };
}

/// Next Best Action Model
class NextBestAction {
  final String id;
  final String title;
  final String description;
  final ActionPriority priority;
  final IconData icon;
  final String route;

  const NextBestAction({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.icon,
    required this.route,
  });

  factory NextBestAction.fromJson(Map<String, dynamic> json) {
    return NextBestAction(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: ActionPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => ActionPriority.suggested,
      ),
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      route: json['route'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'iconCode': icon.codePoint,
      'route': route,
    };
  }

  // Mock data for demo
  static List<NextBestAction> mockList() {
    return [
      const NextBestAction(
        id: 'action-1',
        title: 'Add Beneficiaries',
        description: 'Ensure your retirement savings go to the right people.',
        priority: ActionPriority.required,
        icon: Icons.person_outline,
        route: '/profile',
      ),
      const NextBestAction(
        id: 'action-2',
        title: 'Review Risk Profile',
        description: 'Make sure your investment strategy matches your goals.',
        priority: ActionPriority.suggested,
        icon: Icons.shield_outlined,
        route: '/investments',
      ),
    ];
  }
}
