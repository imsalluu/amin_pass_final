import 'package:amin_pass/onBoarding/on_boarding_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect current theme
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    // Size adjustments for desktop
    final logoWidth = isDesktop ? 200.0 : 138.0;
    final logoHeight = isDesktop ? 180.0 : 120.0;
    final qrHeight = isDesktop ? 350.0 : 274.0;
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
                  'assets/images/on_boarding_one.png',
                  height: qrHeight,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: spacing2),

                // Description Text
                Text(
                  "Quickly scan the store's QR code to earn\nor redeem your loyalty points",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: descFontSize,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingScreenTwo(),
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
