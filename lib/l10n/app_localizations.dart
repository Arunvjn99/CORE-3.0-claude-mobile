import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Participant Portal'**
  String get appName;

  /// No description provided for @platformName.
  ///
  /// In en, this message translates to:
  /// **'Retirement Intelligence Platform'**
  String get platformName;

  /// No description provided for @platformBy.
  ///
  /// In en, this message translates to:
  /// **'by Congruent Solutions'**
  String get platformBy;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© Congruent Solutions, Inc. All Rights Reserved'**
  String get copyright;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get navEnrollment;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navInvestments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get navInvestments;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authLogin;

  /// No description provided for @authSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignup;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterEmail;

  /// No description provided for @authEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authSigningIn;

  /// No description provided for @authCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get authCreatingAccount;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotTitle;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link.'**
  String get authForgotSubtitle;

  /// No description provided for @authSendReset.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendReset;

  /// No description provided for @authSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get authSending;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToLogin;

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get authVerifyTitle;

  /// No description provided for @authVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to your email.'**
  String get authVerifySubtitle;

  /// No description provided for @authVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get authVerifyButton;

  /// No description provided for @authVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get authVerifying;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get commonCompleted;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @commonOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get commonOnTrack;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get commonDarkMode;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverview;

  /// No description provided for @dashboardTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get dashboardTotalBalance;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardPortfolioAllocation.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Allocation'**
  String get dashboardPortfolioAllocation;

  /// No description provided for @dashboardMonthlyContributions.
  ///
  /// In en, this message translates to:
  /// **'Monthly Contributions'**
  String get dashboardMonthlyContributions;

  /// No description provided for @dashboardReadinessScore.
  ///
  /// In en, this message translates to:
  /// **'Readiness Score'**
  String get dashboardReadinessScore;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardNextBestActions.
  ///
  /// In en, this message translates to:
  /// **'Next Best Actions'**
  String get dashboardNextBestActions;

  /// No description provided for @dashboardYourAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Your Advisor'**
  String get dashboardYourAdvisor;

  /// No description provided for @dashboardTakeLoan.
  ///
  /// In en, this message translates to:
  /// **'Take a Loan'**
  String get dashboardTakeLoan;

  /// No description provided for @dashboardWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get dashboardWithdraw;

  /// No description provided for @dashboardTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get dashboardTransfer;

  /// No description provided for @dashboardRollover.
  ///
  /// In en, this message translates to:
  /// **'Roll Over'**
  String get dashboardRollover;

  /// No description provided for @dashboardLearningHub.
  ///
  /// In en, this message translates to:
  /// **'Learning Hub'**
  String get dashboardLearningHub;

  /// No description provided for @dashboardActiveLoan.
  ///
  /// In en, this message translates to:
  /// **'Active Loan'**
  String get dashboardActiveLoan;

  /// No description provided for @dashboardMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get dashboardMessage;

  /// No description provided for @dashboardScheduleCall.
  ///
  /// In en, this message translates to:
  /// **'Schedule Call'**
  String get dashboardScheduleCall;

  /// No description provided for @dashboardLaunchSimulator.
  ///
  /// In en, this message translates to:
  /// **'Launch Simulator'**
  String get dashboardLaunchSimulator;

  /// No description provided for @enrollmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Enrollment'**
  String get enrollmentTitle;

  /// No description provided for @enrollmentStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String enrollmentStep(int current, int total);

  /// No description provided for @enrollmentPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get enrollmentPlanTitle;

  /// No description provided for @enrollmentPlanTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional 401(k)'**
  String get enrollmentPlanTraditional;

  /// No description provided for @enrollmentPlanRoth.
  ///
  /// In en, this message translates to:
  /// **'Roth 401(k)'**
  String get enrollmentPlanRoth;

  /// No description provided for @enrollmentContributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Your Contribution'**
  String get enrollmentContributionTitle;

  /// No description provided for @enrollmentContributionLabel.
  ///
  /// In en, this message translates to:
  /// **'Contribution Rate'**
  String get enrollmentContributionLabel;

  /// No description provided for @enrollmentSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Contribution Source'**
  String get enrollmentSourceTitle;

  /// No description provided for @enrollmentAutoIncreaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Increase'**
  String get enrollmentAutoIncreaseTitle;

  /// No description provided for @enrollmentAutoIncreaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically increase your contribution each year'**
  String get enrollmentAutoIncreaseSubtitle;

  /// No description provided for @enrollmentInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Strategy'**
  String get enrollmentInvestmentTitle;

  /// No description provided for @enrollmentReadinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Retirement Readiness'**
  String get enrollmentReadinessTitle;

  /// No description provided for @enrollmentReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get enrollmentReviewTitle;

  /// No description provided for @enrollmentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Enrolled!'**
  String get enrollmentSuccessTitle;

  /// No description provided for @enrollmentSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your retirement plan is now active.'**
  String get enrollmentSuccessSubtitle;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @transactionsLoan.
  ///
  /// In en, this message translates to:
  /// **'Take a Loan'**
  String get transactionsLoan;

  /// No description provided for @transactionsWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get transactionsWithdrawal;

  /// No description provided for @transactionsTransfer.
  ///
  /// In en, this message translates to:
  /// **'Fund Transfer'**
  String get transactionsTransfer;

  /// No description provided for @transactionsRebalance.
  ///
  /// In en, this message translates to:
  /// **'Rebalance'**
  String get transactionsRebalance;

  /// No description provided for @transactionsRollover.
  ///
  /// In en, this message translates to:
  /// **'Roll Over'**
  String get transactionsRollover;

  /// No description provided for @transactionsLoanSub.
  ///
  /// In en, this message translates to:
  /// **'Borrow from your balance'**
  String get transactionsLoanSub;

  /// No description provided for @transactionsWithdrawalSub.
  ///
  /// In en, this message translates to:
  /// **'Access your funds'**
  String get transactionsWithdrawalSub;

  /// No description provided for @transactionsTransferSub.
  ///
  /// In en, this message translates to:
  /// **'Move funds between plans'**
  String get transactionsTransferSub;

  /// No description provided for @transactionsRebalanceSub.
  ///
  /// In en, this message translates to:
  /// **'Adjust your allocation'**
  String get transactionsRebalanceSub;

  /// No description provided for @transactionsRolloverSub.
  ///
  /// In en, this message translates to:
  /// **'Roll in outside funds'**
  String get transactionsRolloverSub;

  /// No description provided for @loanEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Eligibility'**
  String get loanEligibilityTitle;

  /// No description provided for @loanSimulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Simulator'**
  String get loanSimulatorTitle;

  /// No description provided for @loanConfigurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Loan Details'**
  String get loanConfigurationTitle;

  /// No description provided for @loanFeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees & Charges'**
  String get loanFeesTitle;

  /// No description provided for @loanDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get loanDocumentsTitle;

  /// No description provided for @loanReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get loanReviewTitle;

  /// No description provided for @withdrawalEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Eligibility'**
  String get withdrawalEligibilityTitle;

  /// No description provided for @withdrawalTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Type'**
  String get withdrawalTypeTitle;

  /// No description provided for @withdrawalSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Source of Funds'**
  String get withdrawalSourceTitle;

  /// No description provided for @withdrawalFeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees & Taxes'**
  String get withdrawalFeesTitle;

  /// No description provided for @withdrawalPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get withdrawalPaymentTitle;

  /// No description provided for @withdrawalReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get withdrawalReviewTitle;

  /// No description provided for @transferTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer Type'**
  String get transferTypeTitle;

  /// No description provided for @transferSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Source Funds'**
  String get transferSourceTitle;

  /// No description provided for @transferDestinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get transferDestinationTitle;

  /// No description provided for @transferAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer Amount'**
  String get transferAmountTitle;

  /// No description provided for @transferImpactTitle.
  ///
  /// In en, this message translates to:
  /// **'Impact Summary'**
  String get transferImpactTitle;

  /// No description provided for @transferReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get transferReviewTitle;

  /// No description provided for @rebalanceCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Allocation'**
  String get rebalanceCurrentTitle;

  /// No description provided for @rebalanceAdjustTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust Allocation'**
  String get rebalanceAdjustTitle;

  /// No description provided for @rebalanceTradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Trade Preview'**
  String get rebalanceTradesTitle;

  /// No description provided for @rebalanceReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get rebalanceReviewTitle;

  /// No description provided for @rolloverPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
  String get rolloverPlanTitle;

  /// No description provided for @rolloverValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation'**
  String get rolloverValidationTitle;

  /// No description provided for @rolloverAllocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocation'**
  String get rolloverAllocationTitle;

  /// No description provided for @rolloverDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get rolloverDocumentsTitle;

  /// No description provided for @rolloverReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get rolloverReviewTitle;

  /// No description provided for @investmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get investmentsTitle;

  /// No description provided for @investmentsPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get investmentsPortfolio;

  /// No description provided for @investmentsFunds.
  ///
  /// In en, this message translates to:
  /// **'Funds'**
  String get investmentsFunds;

  /// No description provided for @investmentsPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get investmentsPerformance;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInfo;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profileHelp;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAbout;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiAskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get aiAskQuestion;

  /// No description provided for @aiGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m your retirement planning assistant. How can I help you today?'**
  String get aiGreeting;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
