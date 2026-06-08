import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverDocumentsPage extends StatefulWidget {
  const RolloverDocumentsPage({super.key});

  @override
  State<RolloverDocumentsPage> createState() => _RolloverDocumentsPageState();
}

class _RolloverDocumentsPageState extends State<RolloverDocumentsPage> {
  final _acknowledged = <String>{};

  static const _documents = [
    (
      id: 'dist-statement',
      title: 'Distribution Statement',
      description: 'Official statement from your previous plan administrator showing the distribution amount and type.',
      required: true,
    ),
    (
      id: 'rollover-check',
      title: 'Rollover Check (if applicable)',
      description: 'For indirect rollovers: the check issued by your previous plan made payable to the new plan.',
      required: false,
    ),
    (
      id: 'prior-plan-docs',
      title: 'Prior Plan Summary Plan Description',
      description: 'Document describing the terms and conditions of your previous retirement plan.',
      required: false,
    ),
    (
      id: 'tax-form',
      title: 'Form 1099-R',
      description: 'IRS tax form showing the distribution from your previous plan. Required for tax reporting.',
      required: true,
    ),
  ];

  bool get _canContinue {
    final requiredDocs = _documents.where((d) => d.required).map((d) => d.id);
    return requiredDocs.every((id) => _acknowledged.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Documents',
      currentStep: 4,
      totalSteps: 5,
      primaryLabel: 'Review Rollover',
      primaryEnabled: _canContinue,
      onPrimary: () => context.go(AppRoutes.rolloverReview),
      onBack: () => context.go(AppRoutes.rolloverAllocation),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Required Documents',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Acknowledge and upload the required documentation to process your rollover.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.upload_file, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Document Checklist',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text('${_acknowledged.length} of ${_documents.length} acknowledged',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ..._documents.map((doc) {
            final isAcknowledged = _acknowledged.contains(doc.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isAcknowledged ? AppColors.successBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isAcknowledged ? AppColors.success.withValues(alpha: 0.3) : AppColors.lightBorder,
                    width: isAcknowledged ? 1.5 : 1,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isAcknowledged,
                          onChanged: (v) => setState(() {
                            if (v == true) _acknowledged.add(doc.id);
                            else _acknowledged.remove(doc.id);
                          }),
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(doc.title,
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                                  ),
                                  if (doc.required)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(4)),
                                      child: const Text('Required',
                                          style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.danger)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(doc.description,
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary, height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isAcknowledged) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload, size: 14),
                        label: const Text('Upload Document', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 36),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Original documents may be required by mail. Processing typically takes 5-10 business days after document submission.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.warning, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
