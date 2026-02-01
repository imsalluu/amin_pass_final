import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ResetPasswordSuccessfulScreen extends StatefulWidget {
  const ResetPasswordSuccessfulScreen({super.key});

  @override
  State<ResetPasswordSuccessfulScreen> createState() =>
      _ResetPasswordSuccessfulScreenState();
}

class _ResetPasswordSuccessfulScreenState
    extends State<ResetPasswordSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black87;
    final size = MediaQuery.of(context).size;
    final isWeb = kIsWeb || size.width >= 1024;

    Widget content = Container(
      width: isWeb ? 400 : double.infinity,
      margin: isWeb ? const EdgeInsets.symmetric(vertical: 40) : EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: isWeb
          ? BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
      )
          : null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: isWeb ? 40 : 120), // Mobile-এ ফাঁকা কমানো
            Image.asset(
              'assets/images/Check.png',
              height: 140,
            ),
            const SizedBox(height: 40),
            Text(
              'Password Changed',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your password has been changed successfully',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA3CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Back To Login",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isWeb
            ? Center(child: content) // Web-এ centered
            : content,               // Mobile-এ normal
      ),
    );
  }
}
