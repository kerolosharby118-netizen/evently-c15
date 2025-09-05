import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_assets.dart';
import '../login/login.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = "OnboardingScreen";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OnboardingSettingsPage(), // أول صفحة فيها الـ toggles
      const OnboardingPage(
        image: AppAssets.onBoard2,
        title: "Find Events That Inspire You",
        description:
        "Dive into a world of events crafted to fit your unique interests.",
      ),
      const OnboardingPage(
        image: AppAssets.onBoard3,
        title: "Effortless Event Planning",
        description:
        "Take the hassle out of organizing events with our all-in-one planning tools.",
      ),
      const OnboardingPage(
        image: AppAssets.onBoard4,
        title: "Connect with Friends & Share Moments",
        description:
        "Make every event memorable by sharing the experience with others.",
      ),
    ];
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // --- صفحات الأونبورد ---
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) => _pages[index],
          ),

          // --- Indicators (الدواير) ---
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 14 : 10,
                  height: _currentPage == index ? 14 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.disabledColor,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          // --- زرار السهم لليسار (رجوع) ---
          if (_currentPage > 0)
            Positioned(
              bottom: 20,
              left: 20,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: theme.colorScheme.primary, size: 28),
                  onPressed: _previousPage,
                ),
              ),
            ),

          // --- زرار السهم لليمين (التالي) ---
          Positioned(
            bottom: 20,
            right: 20,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_forward,
                    color: theme.colorScheme.primary, size: 28),
                onPressed: _nextPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image, title, description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300), // ✅ كبرت الصورة
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 22, // ✅ كبرت الخط
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16, // ✅ كبرت الخط شوية
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSettingsPage extends StatelessWidget {
  const OnboardingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.onBoard1, height: 280), // ✅ كبرت الصورة
          const SizedBox(height: 40),
          ToggleOption(
            label: "Language",
            firstIconPath: AppAssets.icUsa,
            secondIconPath: AppAssets.icEg,
            isFirstSelected: languageProvider.currentLocale == "en",
            onChanged: (isFirst) {
              languageProvider.changeLanguage(isFirst ? "en" : "ar");
            },
          ),
          const SizedBox(height: 30),
          ToggleOption(
            label: "Theme",
            firstIcon: Icons.wb_sunny,
            secondIcon: Icons.nightlight_round,
            isFirstSelected: themeProvider.mode == ThemeMode.light,
            onChanged: (isFirst) {
              themeProvider
                  .changeMode(isFirst ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}

class ToggleOption extends StatefulWidget {
  final String label;
  final IconData? firstIcon;
  final IconData? secondIcon;
  final String? firstIconPath;
  final String? secondIconPath;
  final bool isFirstSelected;
  final ValueChanged<bool> onChanged;

  const ToggleOption({
    super.key,
    required this.label,
    this.firstIcon,
    this.secondIcon,
    this.firstIconPath,
    this.secondIconPath,
    required this.isFirstSelected,
    required this.onChanged,
  });

  @override
  State<ToggleOption> createState() => _ToggleOptionState();
}

class _ToggleOptionState extends State<ToggleOption> {
  late bool isFirstSelected;

  @override
  void initState() {
    super.initState();
    isFirstSelected = widget.isFirstSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 18, // ✅ كبرت العنوان
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isFirstSelected = !isFirstSelected;
            });
            widget.onChanged(isFirstSelected);
          },
          child: Container(
            width: 100,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white, // الخلفية كلها بيضا
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIcon(
                  isSelected: isFirstSelected,
                  icon: widget.firstIcon,
                  iconPath: widget.firstIconPath,
                ),
                _buildIcon(
                  isSelected: !isFirstSelected,
                  icon: widget.secondIcon,
                  iconPath: widget.secondIconPath,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon({
    required bool isSelected,
    IconData? icon,
    String? iconPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: iconPath != null
          ? Image.asset(iconPath, width: 26, height: 26) // ✅ كبرت الايكون
          : Icon(
        icon,
        size: 26,
        color: Colors.blue,
      ),
    );
  }
}
