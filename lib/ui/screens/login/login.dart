 import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently_c15/data/firestore_utils.dart';
import 'package:evently_c15/l10n/app_localizations.dart';
import 'package:evently_c15/model/user_dm.dart';
import 'package:evently_c15/ui/providers/theme_provider.dart';
import 'package:evently_c15/ui/providers/language_provider.dart';
import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_colors.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:evently_c15/ui/utils/dialog_utils.dart';
import 'package:evently_c15/ui/widgets/custom_button.dart';
import 'package:evently_c15/ui/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AppLocalizations l10n;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of(context);
    themeProvider = Provider.of(context);
    l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 24,
              ),
              buildAppLogo(context),
              SizedBox(
                height: 24,
              ),
              buildEmailTextField(),
              SizedBox(
                height: 16,
              ),
              buildPasswordTextField(),
              SizedBox(
                height: 16,
              ),
              buildForgetPasswordText(context),
              SizedBox(
                height: 24,
              ),
              buildLoginButton(),
              SizedBox(
                height: 24,
              ),
              buildSignUpText(),
              SizedBox(
                height: 24,
              ),
              buildOrRow(),
              SizedBox(
                height: 24,
              ),
              //buildGoogleLogin(),
              SizedBox(
                height: 24,
              ),
              buildLanguageToggle(),
              SizedBox(
                height: 24,
              ),
              buildThemeToggle()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppLogo(BuildContext context) => Image.asset(
        AppAssets.appVerticalLogo,
        height: MediaQuery.of(context).size.height * 0.2,
      );

  buildEmailTextField() => Container(
        child: CustomTextField(
          hint: l10n.emailHint,
          prefixIcon: AppSvg.icEmail,
          controller: emailController,
        ),
      );

  buildPasswordTextField() => Container(
        child: CustomTextField(
          hint: l10n.passwordHint,
          prefixIcon: AppSvg.icPassword,
          isPassword: true,
          controller: passwordController,
        ),
      );

  buildSignUpText() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.dontHaveAccount,
              style: Theme.of(context).textTheme.labelSmall),
          InkWell(
            onTap: () {
              Navigator.push(context, AppRoutes.register);
            },
            child: Text(l10n.createAccount,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
          ),
        ],
      );

  buildForgetPasswordText(BuildContext context) => Container(
        width: double.infinity,
        child: Text(
          l10n.forgetPassword,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline),
        ),
      );

  buildLoginButton() => CustomButton(
      text: l10n.loginButton,
      onClick: () async {
        showLoading(context);
        try {
          var userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
          UserDM.currentUser =
              await getFromUserFirestore(userCredential.user!.uid);
          Navigator.pop(context);

          ///Hide loadingx
          Navigator.pushReplacement(context, AppRoutes.home);
        } on FirebaseAuthException catch (e) {
          var message =
              e.message ?? "Something went wrong, Please try again later!";
          Navigator.pop(context);

          ///Hide loading
          showMessage(context, content: message, posButtonTitle: "ok");
        }
      });

  buildOrRow() => Row(
        children: [
          Expanded(
              child: Divider(
            indent: 24,
            endIndent: 24,
          )),
          Text(l10n.orText, style: Theme.of(context).textTheme.labelMedium),
          Expanded(
              child: Divider(
            indent: 24,
            endIndent: 24,
          ))
        ],
      );

  buildGoogleLogin() => ElevatedButton(
        child: Text(l10n.loginWithGoogle),
        onPressed: () {},
        // text: ,
        // icon: Icon(Icons.social_distance_outlined),
        // onClick: () {},
        // backgroundColor: AppColors.white,
        // textColor: AppColors.blue,
      );

  late LanguageProvider languageProvider;

  late ThemeProvider themeProvider;

  buildLanguageToggle() => AnimatedToggleSwitch<String>.dual(
        current: languageProvider.currentLocale,
        iconBuilder: (language) =>
            Image.asset(language == "ar" ? AppAssets.icEg : AppAssets.icUsa),
        first: "ar",
        second: "en",
        onChanged: (language) {
          languageProvider.changeLanguage(language);
        },
      );

  buildThemeToggle() => AnimatedToggleSwitch<ThemeMode>.dual(
        current: themeProvider.mode,
        iconBuilder: (mode) =>
            Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
        first: ThemeMode.light,
        second: ThemeMode.dark,
        onChanged: (mode) {
          themeProvider.changeMode(mode);
        },
      );
}
