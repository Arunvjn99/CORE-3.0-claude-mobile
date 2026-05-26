// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Participant Portal';

  @override
  String get platformName => 'Retirement Intelligence Platform';

  @override
  String get platformBy => 'by Congruent Solutions';

  @override
  String get copyright => '© Congruent Solutions, Inc. All Rights Reserved';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navEnrollment => 'Enroll';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navInvestments => 'Investments';

  @override
  String get navProfile => 'Profile';

  @override
  String get authLogin => 'Sign In';

  @override
  String get authSignup => 'Sign Up';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authEnterEmail => 'Enter your email';

  @override
  String get authEnterPassword => 'Enter your password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSigningIn => 'Signing in...';

  @override
  String get authCreatingAccount => 'Creating account...';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authForgotTitle => 'Forgot Password';

  @override
  String get authForgotSubtitle => 'Enter your email and we\'ll send you a reset link.';

  @override
  String get authSendReset => 'Send reset link';

  @override
  String get authSending => 'Sending...';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authVerifyTitle => 'Verification Code';

  @override
  String get authVerifySubtitle => 'We\'ve sent a 6-digit code to your email.';

  @override
  String get authVerifyButton => 'Verify & Continue';

  @override
  String get authVerifying => 'Verifying...';

  @override
  String get authResendCode => 'Resend code';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonActive => 'Active';

  @override
  String get commonCompleted => 'Completed';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonOnTrack => 'On Track';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonDarkMode => 'Dark Mode';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get dashboardOverview => 'Overview';

  @override
  String get dashboardTotalBalance => 'Total Balance';

  @override
  String get dashboardQuickActions => 'Quick Actions';

  @override
  String get dashboardPortfolioAllocation => 'Portfolio Allocation';

  @override
  String get dashboardMonthlyContributions => 'Monthly Contributions';

  @override
  String get dashboardReadinessScore => 'Readiness Score';

  @override
  String get dashboardRecentActivity => 'Recent Activity';

  @override
  String get dashboardNextBestActions => 'Next Best Actions';

  @override
  String get dashboardYourAdvisor => 'Your Advisor';

  @override
  String get dashboardTakeLoan => 'Take a Loan';

  @override
  String get dashboardWithdraw => 'Withdraw';

  @override
  String get dashboardTransfer => 'Transfer';

  @override
  String get dashboardRollover => 'Roll Over';

  @override
  String get dashboardLearningHub => 'Learning Hub';

  @override
  String get dashboardActiveLoan => 'Active Loan';

  @override
  String get dashboardMessage => 'Message';

  @override
  String get dashboardScheduleCall => 'Schedule Call';

  @override
  String get dashboardLaunchSimulator => 'Launch Simulator';

  @override
  String get enrollmentTitle => 'Enrollment';

  @override
  String enrollmentStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get enrollmentPlanTitle => 'Choose Your Plan';

  @override
  String get enrollmentPlanTraditional => 'Traditional 401(k)';

  @override
  String get enrollmentPlanRoth => 'Roth 401(k)';

  @override
  String get enrollmentContributionTitle => 'Set Your Contribution';

  @override
  String get enrollmentContributionLabel => 'Contribution Rate';

  @override
  String get enrollmentSourceTitle => 'Contribution Source';

  @override
  String get enrollmentAutoIncreaseTitle => 'Auto Increase';

  @override
  String get enrollmentAutoIncreaseSubtitle => 'Automatically increase your contribution each year';

  @override
  String get enrollmentInvestmentTitle => 'Investment Strategy';

  @override
  String get enrollmentReadinessTitle => 'Retirement Readiness';

  @override
  String get enrollmentReviewTitle => 'Review & Confirm';

  @override
  String get enrollmentSuccessTitle => 'You\'re Enrolled!';

  @override
  String get enrollmentSuccessSubtitle => 'Your retirement plan is now active.';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get transactionsLoan => 'Take a Loan';

  @override
  String get transactionsWithdrawal => 'Withdrawal';

  @override
  String get transactionsTransfer => 'Fund Transfer';

  @override
  String get transactionsRebalance => 'Rebalance';

  @override
  String get transactionsRollover => 'Roll Over';

  @override
  String get transactionsLoanSub => 'Borrow from your balance';

  @override
  String get transactionsWithdrawalSub => 'Access your funds';

  @override
  String get transactionsTransferSub => 'Move funds between plans';

  @override
  String get transactionsRebalanceSub => 'Adjust your allocation';

  @override
  String get transactionsRolloverSub => 'Roll in outside funds';

  @override
  String get loanEligibilityTitle => 'Loan Eligibility';

  @override
  String get loanSimulatorTitle => 'Loan Simulator';

  @override
  String get loanConfigurationTitle => 'Loan Details';

  @override
  String get loanFeesTitle => 'Fees & Charges';

  @override
  String get loanDocumentsTitle => 'Documents';

  @override
  String get loanReviewTitle => 'Review & Submit';

  @override
  String get withdrawalEligibilityTitle => 'Withdrawal Eligibility';

  @override
  String get withdrawalTypeTitle => 'Withdrawal Type';

  @override
  String get withdrawalSourceTitle => 'Source of Funds';

  @override
  String get withdrawalFeesTitle => 'Fees & Taxes';

  @override
  String get withdrawalPaymentTitle => 'Payment Method';

  @override
  String get withdrawalReviewTitle => 'Review & Submit';

  @override
  String get transferTypeTitle => 'Transfer Type';

  @override
  String get transferSourceTitle => 'Source Funds';

  @override
  String get transferDestinationTitle => 'Destination';

  @override
  String get transferAmountTitle => 'Transfer Amount';

  @override
  String get transferImpactTitle => 'Impact Summary';

  @override
  String get transferReviewTitle => 'Review & Submit';

  @override
  String get rebalanceCurrentTitle => 'Current Allocation';

  @override
  String get rebalanceAdjustTitle => 'Adjust Allocation';

  @override
  String get rebalanceTradesTitle => 'Trade Preview';

  @override
  String get rebalanceReviewTitle => 'Review & Confirm';

  @override
  String get rolloverPlanTitle => 'Plan Details';

  @override
  String get rolloverValidationTitle => 'Validation';

  @override
  String get rolloverAllocationTitle => 'Allocation';

  @override
  String get rolloverDocumentsTitle => 'Documents';

  @override
  String get rolloverReviewTitle => 'Review & Submit';

  @override
  String get investmentsTitle => 'Investments';

  @override
  String get investmentsPortfolio => 'Portfolio';

  @override
  String get investmentsFunds => 'Funds';

  @override
  String get investmentsPerformance => 'Performance';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePersonalInfo => 'Personal Information';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profileHelp => 'Help Center';

  @override
  String get profileAbout => 'About';

  @override
  String get aiAssistantTitle => 'AI Assistant';

  @override
  String get aiAskQuestion => 'Ask a question...';

  @override
  String get aiGreeting => 'Hi! I\'m your retirement planning assistant. How can I help you today?';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';
}
