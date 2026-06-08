import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/plan_overview.dart';
import '../../../core/models/draft_transaction.dart';
import '../../../core/models/attention_item.dart';
import '../../../core/models/financial_guidance.dart';

class TransactionCenterPage extends StatelessWidget {
  TransactionCenterPage({super.key});

  // Mock data - in production would come from providers
  final _planOverview = PlanOverview.mock();
  final _drafts = DraftTransaction.mockList();
  final _attentionItems = AttentionItem.mockList();
  final _guidance = FinancialGuidance.mockList();

  final _transactions = [
    (
      Icons.account_balance_outlined,
      'Take a Loan',
      'Borrow from your balance',
      null,
      AppColors.primary,
      AppColors.iconBgBlue,
      AppRoutes.loan,
    ),
    (
      Icons.payments_outlined,
      'Withdraw Money',
      'Access your funds early',
      'Eligibility Check',
      AppColors.success,
      AppColors.iconBgGreen,
      AppRoutes.withdrawal,
    ),
    (
      Icons.swap_horiz,
      'Transfer Funds',
      'Move funds between plans',
      null,
      AppColors.chartPurple,
      AppColors.iconBgPurple,
      AppRoutes.transfer,
    ),
    (
      Icons.tune,
      'Rebalance',
      'Adjust your investment mix',
      null,
      AppColors.chartOrange,
      AppColors.iconBgAmber,
      AppRoutes.rebalance,
    ),
    (
      Icons.replay,
      'Roll Over',
      'Transfer from external plan',
      null,
      AppColors.info,
      AppColors.iconBgBlue,
      AppRoutes.rollover,
    ),
  ];

  final _recentTx = [
    (
      'Monthly Contribution',
      Icons.arrow_downward,
      AppColors.success,
      AppColors.iconBgGreen,
      'Payroll deduction',
      '+\$450.00',
      AppColors.success,
      'Oct 31',
    ),
    (
      'Employer Match',
      Icons.business,
      AppColors.primary,
      AppColors.iconBgBlue,
      'Safe Harbor match',
      '+\$225.00',
      AppColors.success,
      'Oct 31',
    ),
    (
      'Portfolio Rebalance',
      Icons.refresh,
      AppColors.chartGray,
      AppColors.lightShell,
      'Auto quarterly',
      'Completed',
      AppColors.lightTextSecondary,
      'Oct 1',
    ),
    (
      'Loan Payment',
      Icons.credit_card,
      AppColors.danger,
      AppColors.iconBgRed,
      'LOAN-2024-001',
      '-\$148.00',
      AppColors.danger,
      'Oct 15',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.lightShell,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Modern Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Transaction Center',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.lightTextPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Manage your retirement account',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Plan Overview Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _PlanOverviewCard(plan: _planOverview),
                ),
              ),

              // Draft Transactions & Attention Required
              if (_drafts.isNotEmpty || _attentionItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        if (_drafts.isNotEmpty) ...[
                          _SectionHeader(
                            'Draft Transactions',
                            trailing: '${_drafts.length} Drafts',
                          ),
                          const SizedBox(height: 12),
                          ..._drafts.map(
                            (draft) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DraftCard(draft: draft),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (_attentionItems.isNotEmpty) ...[
                          _SectionHeader(
                            'Attention Required',
                            trailing: '${_attentionItems.length} Items',
                          ),
                          const SizedBox(height: 12),
                          ..._attentionItems.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _AttentionCard(item: item),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _SectionHeader('Quick Actions'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tx = _transactions[index];
                    return _QuickActionCard(
                      icon: tx.$1,
                      title: tx.$2,
                      subtitle: tx.$3,
                      badge: tx.$4,
                      iconColor: tx.$5,
                      iconBg: tx.$6,
                      route: tx.$7,
                    );
                  }, childCount: _transactions.length),
                ),
              ),

              // Financial Guidance / AI Insights
              if (_guidance.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        _SectionHeader(
                          'AI Insights',
                          trailing: 'Powered by AI',
                        ),
                        const SizedBox(height: 12),
                        ..._guidance.map(
                          (guide) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _GuidanceCard(guidance: guide),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Recent Transactions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: _SectionHeader(
                    'Recent Activity',
                    trailing: 'Last 90 days',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _recentTx.asMap().entries.map((e) {
                        final i = e.key;
                        final tx = e.value;
                        return Column(
                          children: [
                            if (i > 0)
                              const Divider(
                                height: 1,
                                color: AppColors.lightBorder,
                                indent: 20,
                                endIndent: 20,
                              ),
                            _RecentTxTile(
                              title: tx.$1,
                              icon: tx.$2,
                              iconColor: tx.$3,
                              iconBg: tx.$4,
                              subtitle: tx.$5,
                              amount: tx.$6,
                              amountColor: tx.$7,
                              date: tx.$8,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ══════════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionHeader(this.title, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.lightTextPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (trailing != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.lightShell,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Text(
              trailing!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PLAN OVERVIEW CARD
// ══════════════════════════════════════════════════════════════════════════════
class _PlanOverviewCard extends StatelessWidget {
  final PlanOverview plan;

  const _PlanOverviewCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR PLAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '401(k) Retirement Savings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${plan.totalBalance.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.primary.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vested Balance',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${plan.vestedBalance.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${plan.vestingPercentage.toStringAsFixed(1)}% vested',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: plan.vestingPercentage / 100,
              backgroundColor: AppColors.lightShell,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DRAFT TRANSACTION CARD
// ══════════════════════════════════════════════════════════════════════════════
class _DraftCard extends StatelessWidget {
  final DraftTransaction draft;

  const _DraftCard({required this.draft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(draft.type.icon, color: AppColors.warning, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        draft.type.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${draft.completionPercentage}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Last modified ${_formatDate(draft.lastModified)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.push(
              draft.type == TransactionType.loan
                  ? AppRoutes.loan
                  : AppRoutes.withdrawal,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Resume',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d').format(date);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ATTENTION CARD
// ══════════════════════════════════════════════════════════════════════════════
class _AttentionCard extends StatelessWidget {
  final AttentionItem item;

  const _AttentionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.priority.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.priority.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.priority.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.priority.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    if (item.dueDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: item.priority.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item.dueDate!.difference(DateTime.now()).inDays}d',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: item.priority.color,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: item.priority.color, size: 20),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// QUICK ACTION CARD
// ══════════════════════════════════════════════════════════════════════════════
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final Color iconColor;
  final Color iconBg;
  final String route;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.iconColor,
    required this.iconBg,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const Spacer(),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FINANCIAL GUIDANCE CARD
// ══════════════════════════════════════════════════════════════════════════════
class _GuidanceCard extends StatelessWidget {
  final FinancialGuidance guidance;

  const _GuidanceCard({required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B5CF6).withValues(alpha: 0.08),
            const Color(0xFF8B5CF6).withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (guidance.isAiGenerated)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF8B5CF6),
                    size: 18,
                  ),
                ),
              if (guidance.isAiGenerated) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  guidance.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  guidance.category.displayName,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            guidance.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () =>
                guidance.route != null ? context.push(guidance.route!) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  guidance.actionText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF8B5CF6),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// RECENT TRANSACTION TILE
// ══════════════════════════════════════════════════════════════════════════════
class _RecentTxTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final String date;

  const _RecentTxTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
