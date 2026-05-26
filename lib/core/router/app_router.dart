import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/walkthrough_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/signup_page.dart';
import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/verify_otp_page.dart';
import '../../features/dashboard/pages/pre_enrollment_dashboard.dart';
import '../../features/dashboard/pages/post_enrollment_dashboard.dart';
import '../../features/enrollment/pages/plan_selection_page.dart';
import '../../features/enrollment/pages/contribution_page.dart';
import '../../features/enrollment/pages/contribution_source_page.dart';
import '../../features/enrollment/pages/auto_increase_page.dart';
import '../../features/enrollment/pages/investment_strategy_page.dart';
import '../../features/enrollment/pages/retirement_readiness_page.dart';
import '../../features/enrollment/pages/review_enrollment_page.dart';
import '../../features/enrollment/pages/enrollment_success_page.dart';
import '../../features/transactions/pages/transaction_center_page.dart';
import '../../features/transactions/flows/loan/loan_eligibility_page.dart';
import '../../features/transactions/flows/loan/loan_simulator_page.dart';
import '../../features/transactions/flows/loan/loan_configuration_page.dart';
import '../../features/transactions/flows/loan/loan_fees_page.dart';
import '../../features/transactions/flows/loan/loan_documents_page.dart';
import '../../features/transactions/flows/loan/loan_review_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_eligibility_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_type_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_source_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_fees_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_payment_page.dart';
import '../../features/transactions/flows/withdrawal/withdrawal_review_page.dart';
import '../../features/transactions/flows/transfer/transfer_type_page.dart';
import '../../features/transactions/flows/transfer/transfer_source_page.dart';
import '../../features/transactions/flows/transfer/transfer_destination_page.dart';
import '../../features/transactions/flows/transfer/transfer_amount_page.dart';
import '../../features/transactions/flows/transfer/transfer_impact_page.dart';
import '../../features/transactions/flows/transfer/transfer_review_page.dart';
import '../../features/transactions/flows/rebalance/rebalance_current_page.dart';
import '../../features/transactions/flows/rebalance/rebalance_adjust_page.dart';
import '../../features/transactions/flows/rebalance/rebalance_trades_page.dart';
import '../../features/transactions/flows/rebalance/rebalance_review_page.dart';
import '../../features/transactions/flows/rollover/rollover_plan_page.dart';
import '../../features/transactions/flows/rollover/rollover_validation_page.dart';
import '../../features/transactions/flows/rollover/rollover_allocation_page.dart';
import '../../features/transactions/flows/rollover/rollover_documents_page.dart';
import '../../features/transactions/flows/rollover/rollover_review_page.dart';
import '../../features/investments/pages/investments_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/ai/pages/ai_assistant_page.dart';
import '../providers/auth_provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/enrollment_model.dart';
import '../widgets/app_shell.dart';

class AppRoutes {
  static const splash = '/';
  static const walkthrough = '/walkthrough';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const verifyOtp = '/verify';
  static const dashboard = '/dashboard';
  static const preEnrollmentDashboard = '/pre-enrollment';
  static const postEnrollmentDashboard = '/post-enrollment';

  static const enrollment = '/enrollment';
  static const enrollmentPlan = '/enrollment/plan';
  static const enrollmentContribution = '/enrollment/contribution';
  static const enrollmentSource = '/enrollment/source';
  static const enrollmentAutoIncrease = '/enrollment/auto-increase';
  static const enrollmentInvestment = '/enrollment/investment';
  static const enrollmentReadiness = '/enrollment/readiness';
  static const enrollmentReview = '/enrollment/review';
  static const enrollmentSuccess = '/enrollment/success';

  static const transactions = '/transactions';
  static const loan = '/transactions/loan';
  static const loanSimulator = '/transactions/loan/simulator';
  static const loanConfiguration = '/transactions/loan/configuration';
  static const loanFees = '/transactions/loan/fees';
  static const loanDocuments = '/transactions/loan/documents';
  static const loanReview = '/transactions/loan/review';

  static const withdrawal = '/transactions/withdrawal';
  static const withdrawalType = '/transactions/withdrawal/type';
  static const withdrawalSource = '/transactions/withdrawal/source';
  static const withdrawalFees = '/transactions/withdrawal/fees';
  static const withdrawalPayment = '/transactions/withdrawal/payment';
  static const withdrawalReview = '/transactions/withdrawal/review';

  static const transfer = '/transactions/transfer';
  static const transferSource = '/transactions/transfer/source';
  static const transferDestination = '/transactions/transfer/destination';
  static const transferAmount = '/transactions/transfer/amount';
  static const transferImpact = '/transactions/transfer/impact';
  static const transferReview = '/transactions/transfer/review';

  static const rebalance = '/transactions/rebalance';
  static const rebalanceAdjust = '/transactions/rebalance/adjust';
  static const rebalanceTrades = '/transactions/rebalance/trades';
  static const rebalanceReview = '/transactions/rebalance/review';

  static const rollover = '/transactions/rollover';
  static const rolloverValidation = '/transactions/rollover/validation';
  static const rolloverAllocation = '/transactions/rollover/allocation';
  static const rolloverDocuments = '/transactions/rollover/documents';
  static const rolloverReview = '/transactions/rollover/review';

  static const investments = '/investments';
  static const profile = '/profile';
  static const aiAssistant = '/ai';
}

// ── Router created ONCE — never recreated on auth change ──────────────────
// Auth/demo changes call router.refresh() instead of recreating the GoRouter.
// This prevents navigation state being wiped and the null-check crash.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuth = ref.read(isAuthenticatedProvider);
      final path = state.matchedLocation;

      // Splash and walkthrough always handle their own routing
      if (path == AppRoutes.splash || path == AppRoutes.walkthrough) {
        return null;
      }

      // Auth-only paths (exact or prefix, but NOT '/' which is splash)
      final isAuthPage = path == AppRoutes.login ||
          path == AppRoutes.signup ||
          path == AppRoutes.forgotPassword ||
          path.startsWith(AppRoutes.verifyOtp);

      final isEnrollment = path.startsWith('/enrollment');

      // Not logged in → send to login (except auth pages and enrollment)
      if (!isAuth && !isAuthPage && !isEnrollment) {
        return AppRoutes.login;
      }

      // Logged in and on an auth page → go to dashboard
      if (isAuth && isAuthPage) {
        final enrollment = ref.read(enrollmentProvider);
        return enrollment.status == EnrollmentStatus.complete
            ? AppRoutes.postEnrollmentDashboard
            : AppRoutes.preEnrollmentDashboard;
      }

      return null;
    },
    routes: [
      // ── Splash & Onboarding ──
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.walkthrough, builder: (_, __) => const WalkthroughPage()),

      // ── Auth ──
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupPage()),
      GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(
          path: AppRoutes.verifyOtp,
          builder: (_, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return VerifyOtpPage(email: email);
          }),

      // ── Enrollment (public) ──
      GoRoute(
          path: AppRoutes.enrollmentPlan,
          builder: (_, __) => const PlanSelectionPage()),
      GoRoute(
          path: AppRoutes.enrollmentContribution,
          builder: (_, __) => const ContributionPage()),
      GoRoute(
          path: AppRoutes.enrollmentSource,
          builder: (_, __) => const ContributionSourcePage()),
      GoRoute(
          path: AppRoutes.enrollmentAutoIncrease,
          builder: (_, __) => const AutoIncreasePage()),
      GoRoute(
          path: AppRoutes.enrollmentInvestment,
          builder: (_, __) => const InvestmentStrategyPage()),
      GoRoute(
          path: AppRoutes.enrollmentReadiness,
          builder: (_, __) => const RetirementReadinessPage()),
      GoRoute(
          path: AppRoutes.enrollmentReview,
          builder: (_, __) => const ReviewEnrollmentPage()),
      GoRoute(
          path: AppRoutes.enrollmentSuccess,
          builder: (_, __) => const EnrollmentSuccessPage()),

      // ── Protected Shell (bottom tab nav) ──
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
              path: AppRoutes.preEnrollmentDashboard,
              builder: (_, __) => const PreEnrollmentDashboard()),
          GoRoute(
              path: AppRoutes.postEnrollmentDashboard,
              builder: (_, __) => const PostEnrollmentDashboard()),
          GoRoute(
              path: AppRoutes.transactions,
              builder: (_, __) => TransactionCenterPage()),
          GoRoute(
              path: AppRoutes.investments,
              builder: (_, __) => const InvestmentsPage()),
          GoRoute(
              path: AppRoutes.aiAssistant,
              builder: (_, __) => const AiAssistantPage()),
          GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const ProfilePage()),
        ],
      ),

      // ── Transaction Flows ──
      GoRoute(
          path: AppRoutes.loan,
          builder: (_, __) => const LoanEligibilityPage()),
      GoRoute(
          path: AppRoutes.loanSimulator,
          builder: (_, __) => const LoanSimulatorPage()),
      GoRoute(
          path: AppRoutes.loanConfiguration,
          builder: (_, __) => const LoanConfigurationPage()),
      GoRoute(
          path: AppRoutes.loanFees, builder: (_, __) => const LoanFeesPage()),
      GoRoute(
          path: AppRoutes.loanDocuments,
          builder: (_, __) => const LoanDocumentsPage()),
      GoRoute(
          path: AppRoutes.loanReview,
          builder: (_, __) => const LoanReviewPage()),

      GoRoute(
          path: AppRoutes.withdrawal,
          builder: (_, __) => const WithdrawalEligibilityPage()),
      GoRoute(
          path: AppRoutes.withdrawalType,
          builder: (_, __) => const WithdrawalTypePage()),
      GoRoute(
          path: AppRoutes.withdrawalSource,
          builder: (_, __) => const WithdrawalSourcePage()),
      GoRoute(
          path: AppRoutes.withdrawalFees,
          builder: (_, __) => const WithdrawalFeesPage()),
      GoRoute(
          path: AppRoutes.withdrawalPayment,
          builder: (_, __) => const WithdrawalPaymentPage()),
      GoRoute(
          path: AppRoutes.withdrawalReview,
          builder: (_, __) => const WithdrawalReviewPage()),

      GoRoute(
          path: AppRoutes.transfer,
          builder: (_, __) => const TransferTypePage()),
      GoRoute(
          path: AppRoutes.transferSource,
          builder: (_, __) => const TransferSourcePage()),
      GoRoute(
          path: AppRoutes.transferDestination,
          builder: (_, __) => const TransferDestinationPage()),
      GoRoute(
          path: AppRoutes.transferAmount,
          builder: (_, __) => const TransferAmountPage()),
      GoRoute(
          path: AppRoutes.transferImpact,
          builder: (_, __) => const TransferImpactPage()),
      GoRoute(
          path: AppRoutes.transferReview,
          builder: (_, __) => const TransferReviewPage()),

      GoRoute(
          path: AppRoutes.rebalance,
          builder: (_, __) => const RebalanceCurrentPage()),
      GoRoute(
          path: AppRoutes.rebalanceAdjust,
          builder: (_, __) => const RebalanceAdjustPage()),
      GoRoute(
          path: AppRoutes.rebalanceTrades,
          builder: (_, __) => const RebalanceTradesPage()),
      GoRoute(
          path: AppRoutes.rebalanceReview,
          builder: (_, __) => const RebalanceReviewPage()),

      GoRoute(
          path: AppRoutes.rollover,
          builder: (_, __) => const RolloverPlanPage()),
      GoRoute(
          path: AppRoutes.rolloverValidation,
          builder: (_, __) => const RolloverValidationPage()),
      GoRoute(
          path: AppRoutes.rolloverAllocation,
          builder: (_, __) => const RolloverAllocationPage()),
      GoRoute(
          path: AppRoutes.rolloverDocuments,
          builder: (_, __) => const RolloverDocumentsPage()),
      GoRoute(
          path: AppRoutes.rolloverReview,
          builder: (_, __) => const RolloverReviewPage()),
    ],
  );

  // Refresh router when auth state OR demo mode changes
  // (does NOT recreate the router — avoids null crash)
  ref.listen(authStateProvider, (_, __) => router.refresh());
  ref.listen(demoModeProvider, (_, __) => router.refresh());

  ref.onDispose(router.dispose);
  return router;
});
