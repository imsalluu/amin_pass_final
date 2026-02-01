import 'package:amin_pass/app/token_service.dart';
import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/common/controller/auth_controller.dart';
import 'package:amin_pass/common/screen/shop_name_show_screen.dart';
import 'package:amin_pass/onBoarding/on_boarding_screen_1.dart';
import 'package:amin_pass/onBoarding/onboarding_service.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), _decideRoute);
  }

  Future<void> _decideRoute() async {
    await TokenService.loadTokens();

    final hasSeenOnboarding = await OnboardingService.hasSeen();
    final authController = Get.find<AuthController>();

    // ✅ access token আছে
    if (TokenService.accessToken != null) {
      Get.find<ProfileController>().fetchProfile(); // ✅ Fetch profile for points
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ShopNameShowScreen()),
      );
      return;
    }

    // 🔄 try refresh token
    if (TokenService.refreshToken != null) {
      final refreshed = await authController.tryRefreshToken();
      if (refreshed) {
        Get.find<ProfileController>().fetchProfile(); // ✅ Fetch profile for points
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ShopNameShowScreen()),
        );
        return;
      }
    }

    // 🆕 First time user
    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreenOne()),
      );
    }
    // ❌ Not logged in
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: SvgPicture.asset(
            isDark
                ? 'assets/images/logo_dark.svg'
                : 'assets/images/aminpass_logo.svg',
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
