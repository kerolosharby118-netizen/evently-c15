import 'package:evently_c15/model/user_dm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../../providers/language_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../login/login.dart';


class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserDM.currentUser!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== AppBar الأزرق =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Color(0xFF4A63FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
            ),
            child: Row(
              children: [
                // صورة البروفايل
                GestureDetector(
                  onTap: () {
                    // TODO: ممكن تركب ImagePicker هنا
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/route_logo.png",
                        fit: BoxFit.contain,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // الاسم + الإيميل
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===== Language Section =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Language",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: languageProvider.currentLocale,
                    items: const [
                      DropdownMenuItem(
                        value: "ar",
                        child: Text("Arabic"),
                      ),
                      DropdownMenuItem(
                        value: "en",
                        child: Text("English"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        languageProvider.changeLanguage(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== Theme Section =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Theme",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.blueAccent, width: 3),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: themeProvider.mode == ThemeMode.dark ? "dark" : "light",
                    items: const [
                      DropdownMenuItem(
                        value: "light",
                        child: Text("Light"),
                      ),
                      DropdownMenuItem(
                        value: "dark",
                        child: Text("Dark"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.changeMode(
                          value == "dark" ? ThemeMode.dark : ThemeMode.light,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ===== Logout Button =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                UserDM.currentUser = null;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
