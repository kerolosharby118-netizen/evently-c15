import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = "OnboardingScreen";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": AppAssets.onBoard1,
      "title": "Personalize Your Experience",
      "description":
      "Choose your preferred theme and language to get started with a tailored experience.",
    },
    {
      "image": AppAssets.onBoard2,
      "title": "Find Events That Inspire You",
      "description": "Dive into a world of events crafted to fit your unique interests.",
    },
    {
      "image": AppAssets.onBoard3,
      "title": "Effortless Event Planning",
      "description":
      "Take the hassle out of organizing events with our all-in-one planning tools.",
    },
    {
      "image": AppAssets.onBoard4,
      "title": "Connect with Friends & Share Moments",
      "description": "Make every event memorable by sharing the experience with others.",
    },
  ];

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
            itemBuilder: (context, index) {
              final page = _pages[index];
              return OnboardingPage(
                image: page["image"]!,
                title: page["title"]!,
                description: page["description"]!,
              );
            },
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
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
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
                radius: 28,
                backgroundColor: theme.colorScheme.primary,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _previousPage,
                ),
              ),
            ),

          // --- زرار السهم لليمين (التالي) ---
          Positioned(
            bottom: 20,
            right: 20,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
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
          Image.asset(image, height: 250),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
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
