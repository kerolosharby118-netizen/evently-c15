import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently_c15/model/user_dm.dart';
import 'package:evently_c15/ui/providers/theme_provider.dart';
import 'package:evently_c15/ui/providers/language_provider.dart';
import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:evently_c15/ui/utils/dialog_utils.dart';
import 'package:evently_c15/ui/widgets/custom_button.dart';
import 'package:evently_c15/ui/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evently_c15/l10n/app_localizations.dart';

import '../../../data/firestore_utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AppLocalizations l10n;
  late LanguageProvider languageProvider;
  late ThemeProvider themeProvider;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                buildAppLogo(context),
                const SizedBox(height: 24),
                buildEmailTextField(),
                const SizedBox(height: 16),
                buildPasswordTextField(),
                const SizedBox(height: 16),
                buildForgetPasswordText(context),
                const SizedBox(height: 24),
                buildLoginButton(),
                const SizedBox(height: 24),
                buildSignUpText(),
                const SizedBox(height: 24),
                buildOrRow(),
                const SizedBox(height: 24),
                buildGoogleLogin(),
                const SizedBox(height: 24),
                buildLanguageToggle(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppLogo(BuildContext context) => Image.asset(
    AppAssets.appVerticalLogo,
    height: MediaQuery.of(context).size.height * 0.2,
  );

  buildEmailTextField() => CustomTextField(
    hint: l10n.emailHint,
    prefixIcon: AppAssets.icEmail,
    controller: emailController,
  );

  buildPasswordTextField() => CustomTextField(
    hint: l10n.passwordHint,
    prefixIcon: AppAssets.icPassword,
    isPassword: true,
    controller: passwordController,
  );

  buildSignUpText() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        l10n.dontHaveAccount,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const SizedBox(width: 4),
      InkWell(
        onTap: () => Navigator.push(context, AppRoutes.register),
        child: Text(
          l10n.createAccount,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
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
        decoration: TextDecoration.underline,
      ),
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

        var userData =
        await getFromUserFirestore(userCredential.user!.uid);

        Navigator.pop(context); // close loading

        if (userData != null) {
          UserDM.currentUser = userData;
          Navigator.pushReplacement(context, AppRoutes.home);
        } else {
          showMessage(context,
              content:
              "No user data found in Firestore, please register first.",
              posButtonTitle: "OK");
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        var message =
            e.message ?? "Something went wrong, Please try again later!";
        showMessage(context, content: message, posButtonTitle: "OK");
      }
    },
  );

  buildOrRow() => Row(
    children: [
      const Expanded(child: Divider(thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          l10n.orText,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      const Expanded(child: Divider(thickness: 1)),
    ],
  );

  buildGoogleLogin() => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    icon: Image.asset(AppAssets.icGoogle, height: 24, width: 24),
    label: const Text(
      'Login with Google',
      style: TextStyle(
        color: Color(0xFF4285F4),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    onPressed: () async {
      showLoading(context);
      try {
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          Navigator.pop(context);
          showMessage(context, content: "Google sign-in cancelled");
          return;
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        var userData =
        await getFromUserFirestore(userCredential.user!.uid);

        Navigator.pop(context); // close loading

        if (userData != null) {
          UserDM.currentUser = userData;
          Navigator.pushReplacement(context, AppRoutes.home);
        } else {
          showMessage(context,
              content:
              "No user data found in Firestore, please register first.",
              posButtonTitle: "OK");
        }
      } catch (e) {
        Navigator.pop(context);
        showMessage(context,
            content: "Google sign-in failed. Please try again.",
            posButtonTitle: "OK");
        print("Google Sign-In Error: $e");
      }
    },
  );

  buildLanguageToggle() => AnimatedToggleSwitch<String>.dual(
    current: languageProvider.currentLocale,
    iconBuilder: (language) =>
        Image.asset(language == "ar" ? AppAssets.icEg : AppAssets.icUsa),
    first: "ar",
    second: "en",
    onChanged: (language) => languageProvider.changeLanguage(language),
  );
}
