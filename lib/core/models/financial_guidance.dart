/// Financial Guidance Category
enum GuidanceCategory {
  retirement,
  investment,
  contribution,
  tax,
  general;

  String get displayName => switch (this) {
    retirement => 'Retirement Planning',
    investment => 'Investment Strategy',
    contribution => 'Contribution',
    tax => 'Tax Strategy',
    general => 'General Guidance',
  };
}

/// Financial Guidance Model
class FinancialGuidance {
  final String id;
  final String title;
  final String description;
  final GuidanceCategory category;
  final String actionText;
  final String? route;
  final bool isAiGenerated;

  const FinancialGuidance({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.actionText,
    this.route,
    this.isAiGenerated = false,
  });

  factory FinancialGuidance.fromJson(Map<String, dynamic> json) {
    return FinancialGuidance(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: GuidanceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => GuidanceCategory.general,
      ),
      actionText: json['actionText'] as String,
      route: json['route'] as String?,
      isAiGenerated: json['isAiGenerated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'actionText': actionText,
      'route': route,
      'isAiGenerated': isAiGenerated,
    };
  }

  // Mock data for demo
  static List<FinancialGuidance> mockList() {
    return [
      const FinancialGuidance(
        id: 'guide-1',
        title: 'Maximize Your Employer Match',
        description:
            'You\'re currently contributing 6%. Consider increasing to 8% to capture the full employer match.',
        category: GuidanceCategory.contribution,
        actionText: 'Adjust Contribution',
        route: '/enrollment/contribution',
        isAiGenerated: true,
      ),
      const FinancialGuidance(
        id: 'guide-2',
        title: 'Review Your Investment Mix',
        description:
            'Based on your age and risk profile, consider rebalancing your portfolio for better diversification.',
        category: GuidanceCategory.investment,
        actionText: 'View Recommendations',
        route: '/investments',
        isAiGenerated: true,
      ),
      const FinancialGuidance(
        id: 'guide-3',
        title: 'Catch-Up Contributions Available',
        description:
            'You\'re eligible for catch-up contributions. Consider adding \$7,500 annually to accelerate retirement savings.',
        category: GuidanceCategory.retirement,
        actionText: 'Learn More',
        route: '/enrollment/contribution',
        isAiGenerated: false,
      ),
    ];
  }
}
