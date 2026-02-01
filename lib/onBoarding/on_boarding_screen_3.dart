import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/onBoarding/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    // Desktop size adjustments
    final logoWidth = isDesktop ? 200.0 : 138.0;
    final logoHeight = isDesktop ? 180.0 : 120.0;
    final qrHeight = isDesktop ? 400.0 : 326.0;
    final descFontSize = isDesktop ? 20.0 : 16.0;
    final spacing1 = isDesktop ? 80.0 : 60.0;
    final spacing2 = isDesktop ? 24.0 : 16.0;
    final spacing3 = isDesktop ? 60.0 : 40.0;
    final buttonWidth = isDesktop ? 200.0 : 152.0;
    final buttonHeight = isDesktop ? 50.0 : 39.0;
    final buttonFontSize = isDesktop ? 18.0 : 16.0;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section
                SizedBox(
                  width: logoWidth,
                  height: logoHeight,
                  child: SvgPicture.asset(
                    isDarkMode
                        ? 'assets/images/logo_dark.svg'
                        : 'assets/images/aminpass_logo.svg',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: spacing1),

                // QR Illustration Section
                Image.asset(
                  'assets/images/on_boarding_three.png',
                  height: qrHeight,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: spacing2),

                // Description Text
                Text(
                  "View your points balance and available rewards\n right from your digital loyalty wallet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: descFontSize,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),

                SizedBox(height: spacing3),

                // Button aligned to the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7AA3CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await OnboardingService.markSeen();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
