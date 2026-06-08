import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class _Document {
  final String name;
  final String description;
  final bool required;
  bool uploaded;
  _Document({required this.name, required this.description, required this.required, this.uploaded = false});
}

class LoanDocumentsPage extends StatefulWidget {
  const LoanDocumentsPage({super.key});
  @override
  State<LoanDocumentsPage> createState() => _LoanDocumentsPageState();
}

class _LoanDocumentsPageState extends State<LoanDocumentsPage> {
  bool _docuSignCompleted = false;

  final _documents = [
    _Document(name: 'Check Leaf', description: 'Voided check or bank statement', required: true),
    _Document(name: 'Promissory Note', description: 'Legal agreement to repay the loan', required: true),
    _Document(name: 'Spousal Consent', description: 'Required if married — spouse must consent', required: true),
    _Document(name: 'Purchase Agreement', description: 'Required for residential loans', required: false),
    _Document(name: 'Employment Verification', description: 'Proof of current employment status', required: false),
  ];

  bool get _allRequiredUploaded => _documents.where((d) => d.required).every((d) => d.uploaded);
  bool get _canContinue => _docuSignCompleted || _allRequiredUploaded;

  void _handleDocuSign() {
    setState(() {
      _docuSignCompleted = true;
      for (final doc in _documents) {
        if (doc.required) doc.uploaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Documents',
      currentStep: 5,
      totalSteps: 6,
      primaryLabel: 'Continue to Review',
      primaryEnabled: _canContinue,
      onPrimary: () => context.go(AppRoutes.loanReview),
      onBack: () => context.go(AppRoutes.loanFees),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Required Documents',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Upload the necessary documents or sign electronically via DocuSign.',
            style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, height: 1.5),
          ),
          const SizedBox(height: 20),

          // DocuSign Option
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sign with DocuSign', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text(
                  'Complete all required documents electronically in minutes with DocuSign\'s secure platform.',
                  style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary, height: 1.4),
                ),
                const SizedBox(height: 12),
                if (_docuSignCompleted)
                  Row(children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    const Text('DocuSign completed successfully', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
                  ])
                else
                  GestureDetector(
                    onTap: _handleDocuSign,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Sign with DocuSign', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Divider with "or upload manually"
          Row(children: [
            Expanded(child: Divider(color: AppColors.lightBorder)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('or upload manually', style: TextStyle(fontSize: 11, color: AppColors.lightTextMuted)),
            ),
            Expanded(child: Divider(color: AppColors.lightBorder)),
          ]),
          const SizedBox(height: 16),

          // Document List
          ...List.generate(_documents.length, (i) {
            final doc = _documents[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: doc.uploaded ? AppColors.success.withValues(alpha: 0.3) : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(doc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              if (doc.required) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('Required', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.danger)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(doc.description, style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                          if (doc.uploaded) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.lightBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.description_outlined, size: 14, color: AppColors.lightTextSecondary),
                                  const SizedBox(width: 6),
                                  Text('${doc.name.toLowerCase().replaceAll(' ', '_')}.pdf', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 6),
                                  const Text('234 KB', style: TextStyle(fontSize: 10, color: AppColors.lightTextMuted)),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => setState(() => doc.uploaded = false),
                                    child: const Icon(Icons.close, size: 14, color: AppColors.lightTextMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (doc.uploaded)
                      const Icon(Icons.check_circle, color: AppColors.success, size: 24)
                    else
                      GestureDetector(
                        onTap: () => setState(() => doc.uploaded = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.lightBorder),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.upload_outlined, size: 14, color: AppColors.lightTextPrimary),
                              SizedBox(width: 4),
                              Text('Upload', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
