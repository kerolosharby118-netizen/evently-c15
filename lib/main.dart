import 'dart:async';

import 'package:evently_c15/ui/providers/theme_provider.dart';
import 'package:evently_c15/ui/providers/language_provider.dart';
import 'package:evently_c15/ui/screens/add_event/add_event.dart';
import 'package:evently_c15/ui/screens/home/home.dart';
import 'package:evently_c15/ui/screens/login/login.dart';
import 'package:evently_c15/ui/screens/register/register.dart';
import 'package:evently_c15/ui/screens/splash/splash.dart';
import 'package:evently_c15/ui/utils/app_routes.dart';
import 'package:evently_c15/ui/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBir_qd6FDZPLZnOQi6tN1C0TNadr3VbgY",
        appId: "1:132585537654:android:3df09b57eec8e74a5e9f57",
        messagingSenderId: "",
        projectId: "evently-c15-online"),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late LanguageProvider languageProvider;
  late ThemeProvider themeProvider;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of(context);
    themeProvider = Provider.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Splash.routeName,
      routes: {
        Splash.routeName: (_) => const Splash(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.mode,
      locale: Locale(languageProvider.currentLocale),
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      // home: Login(),
    );
  }
}
