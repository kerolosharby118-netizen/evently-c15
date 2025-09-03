// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get emailHint => 'البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟  ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get forgetPassword => 'نسيت كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get orText => 'أو';

  @override
  String get loginWithGoogle => 'تسجيل الدخول باستخدام جوجل';
}
