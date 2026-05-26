// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Portal de Participantes';

  @override
  String get platformName => 'Plataforma de Inteligencia para la Jubilación';

  @override
  String get platformBy => 'por Congruent Solutions';

  @override
  String get copyright => '© Congruent Solutions, Inc. Todos los derechos reservados';

  @override
  String get navDashboard => 'Inicio';

  @override
  String get navEnrollment => 'Inscripción';

  @override
  String get navTransactions => 'Transacciones';

  @override
  String get navInvestments => 'Inversiones';

  @override
  String get navProfile => 'Perfil';

  @override
  String get authLogin => 'Iniciar sesión';

  @override
  String get authSignup => 'Registrarse';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authFullName => 'Nombre completo';

  @override
  String get authEnterEmail => 'Ingresa tu correo';

  @override
  String get authEnterPassword => 'Ingresa tu contraseña';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authNoAccount => '¿No tienes una cuenta?';

  @override
  String get authHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get authSigningIn => 'Iniciando sesión...';

  @override
  String get authCreatingAccount => 'Creando cuenta...';

  @override
  String get authShowPassword => 'Mostrar contraseña';

  @override
  String get authHidePassword => 'Ocultar contraseña';

  @override
  String get authForgotTitle => 'Olvidé mi contraseña';

  @override
  String get authForgotSubtitle => 'Ingresa tu correo y te enviaremos un enlace de restablecimiento.';

  @override
  String get authSendReset => 'Enviar enlace';

  @override
  String get authSending => 'Enviando...';

  @override
  String get authBackToLogin => 'Volver al inicio de sesión';

  @override
  String get authVerifyTitle => 'Código de verificación';

  @override
  String get authVerifySubtitle => 'Te hemos enviado un código de 6 dígitos.';

  @override
  String get authVerifyButton => 'Verificar y continuar';

  @override
  String get authVerifying => 'Verificando...';

  @override
  String get authResendCode => 'Reenviar código';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonActive => 'Activo';

  @override
  String get commonCompleted => 'Completado';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonSubmit => 'Enviar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonViewAll => 'Ver todo';

  @override
  String get commonOnTrack => 'En camino';

  @override
  String get commonError => 'Algo salió mal';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonSignOut => 'Cerrar sesión';

  @override
  String get commonSettings => 'Configuración';

  @override
  String get commonDarkMode => 'Modo oscuro';

  @override
  String get commonLanguage => 'Idioma';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get dashboardOverview => 'Resumen';

  @override
  String get dashboardTotalBalance => 'Balance total';

  @override
  String get dashboardQuickActions => 'Acciones rápidas';

  @override
  String get dashboardPortfolioAllocation => 'Asignación de cartera';

  @override
  String get dashboardMonthlyContributions => 'Aportaciones mensuales';

  @override
  String get dashboardReadinessScore => 'Puntuación de preparación';

  @override
  String get dashboardRecentActivity => 'Actividad reciente';

  @override
  String get dashboardNextBestActions => 'Próximas acciones';

  @override
  String get dashboardYourAdvisor => 'Tu asesor';

  @override
  String get dashboardTakeLoan => 'Solicitar préstamo';

  @override
  String get dashboardWithdraw => 'Retirar';

  @override
  String get dashboardTransfer => 'Transferir';

  @override
  String get dashboardRollover => 'Transferencia';

  @override
  String get dashboardLearningHub => 'Centro de aprendizaje';

  @override
  String get dashboardActiveLoan => 'Préstamo activo';

  @override
  String get dashboardMessage => 'Mensaje';

  @override
  String get dashboardScheduleCall => 'Programar llamada';

  @override
  String get dashboardLaunchSimulator => 'Iniciar simulador';

  @override
  String get enrollmentTitle => 'Inscripción';

  @override
  String enrollmentStep(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get enrollmentPlanTitle => 'Elige tu plan';

  @override
  String get enrollmentPlanTraditional => '401(k) Tradicional';

  @override
  String get enrollmentPlanRoth => '401(k) Roth';

  @override
  String get enrollmentContributionTitle => 'Establece tu aportación';

  @override
  String get enrollmentContributionLabel => 'Tasa de aportación';

  @override
  String get enrollmentSourceTitle => 'Fuente de aportación';

  @override
  String get enrollmentAutoIncreaseTitle => 'Incremento automático';

  @override
  String get enrollmentAutoIncreaseSubtitle => 'Aumenta automáticamente tu aportación cada año';

  @override
  String get enrollmentInvestmentTitle => 'Estrategia de inversión';

  @override
  String get enrollmentReadinessTitle => 'Preparación para la jubilación';

  @override
  String get enrollmentReviewTitle => 'Revisar y confirmar';

  @override
  String get enrollmentSuccessTitle => '¡Estás inscrito!';

  @override
  String get enrollmentSuccessSubtitle => 'Tu plan de jubilación ya está activo.';

  @override
  String get transactionsTitle => 'Transacciones';

  @override
  String get transactionsLoan => 'Solicitar préstamo';

  @override
  String get transactionsWithdrawal => 'Retiro';

  @override
  String get transactionsTransfer => 'Transferencia de fondos';

  @override
  String get transactionsRebalance => 'Rebalancear';

  @override
  String get transactionsRollover => 'Transferencia';

  @override
  String get transactionsLoanSub => 'Pedir prestado de tu saldo';

  @override
  String get transactionsWithdrawalSub => 'Accede a tus fondos';

  @override
  String get transactionsTransferSub => 'Mover fondos entre planes';

  @override
  String get transactionsRebalanceSub => 'Ajustar tu asignación';

  @override
  String get transactionsRolloverSub => 'Incorporar fondos externos';

  @override
  String get loanEligibilityTitle => 'Elegibilidad para préstamo';

  @override
  String get loanSimulatorTitle => 'Simulador de préstamo';

  @override
  String get loanConfigurationTitle => 'Detalles del préstamo';

  @override
  String get loanFeesTitle => 'Cargos y tarifas';

  @override
  String get loanDocumentsTitle => 'Documentos';

  @override
  String get loanReviewTitle => 'Revisar y enviar';

  @override
  String get withdrawalEligibilityTitle => 'Elegibilidad de retiro';

  @override
  String get withdrawalTypeTitle => 'Tipo de retiro';

  @override
  String get withdrawalSourceTitle => 'Fuente de fondos';

  @override
  String get withdrawalFeesTitle => 'Tarifas e impuestos';

  @override
  String get withdrawalPaymentTitle => 'Método de pago';

  @override
  String get withdrawalReviewTitle => 'Revisar y enviar';

  @override
  String get transferTypeTitle => 'Tipo de transferencia';

  @override
  String get transferSourceTitle => 'Fondos de origen';

  @override
  String get transferDestinationTitle => 'Destino';

  @override
  String get transferAmountTitle => 'Monto de transferencia';

  @override
  String get transferImpactTitle => 'Resumen de impacto';

  @override
  String get transferReviewTitle => 'Revisar y enviar';

  @override
  String get rebalanceCurrentTitle => 'Asignación actual';

  @override
  String get rebalanceAdjustTitle => 'Ajustar asignación';

  @override
  String get rebalanceTradesTitle => 'Vista previa de operaciones';

  @override
  String get rebalanceReviewTitle => 'Revisar y confirmar';

  @override
  String get rolloverPlanTitle => 'Detalles del plan';

  @override
  String get rolloverValidationTitle => 'Validación';

  @override
  String get rolloverAllocationTitle => 'Asignación';

  @override
  String get rolloverDocumentsTitle => 'Documentos';

  @override
  String get rolloverReviewTitle => 'Revisar y enviar';

  @override
  String get investmentsTitle => 'Inversiones';

  @override
  String get investmentsPortfolio => 'Cartera';

  @override
  String get investmentsFunds => 'Fondos';

  @override
  String get investmentsPerformance => 'Rendimiento';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profilePersonalInfo => 'Información personal';

  @override
  String get profileSecurity => 'Seguridad';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profilePrivacy => 'Privacidad';

  @override
  String get profileHelp => 'Centro de ayuda';

  @override
  String get profileAbout => 'Acerca de';

  @override
  String get aiAssistantTitle => 'Asistente IA';

  @override
  String get aiAskQuestion => 'Haz una pregunta...';

  @override
  String get aiGreeting => '¡Hola! Soy tu asistente de planificación para la jubilación. ¿En qué puedo ayudarte?';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';
}
