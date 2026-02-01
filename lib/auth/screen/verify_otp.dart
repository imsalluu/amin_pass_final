import 'package:amin_pass/auth/controller/opt_controller.dart';
import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email; // ✅ dynamic email

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final otpController = Get.find<OtpController>();

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
        border: Border.all(color: Colors.grey.shade400, width: 2),
      )
          : null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isWeb ? 40 : 120),
            Text(
              'Please check your email',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'We’ve sent a code to ${widget.email}',
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 40),

            PinCodeTextField(
              controller: _otpTEController,
              length: 6,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              appContext: context,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldWidth: 50,
                fieldHeight: 50,
                selectedColor: const Color(0xFF7AA3CC),
                inactiveColor: Colors.grey,
                activeFillColor: backgroundColor,
              ),
              textStyle: TextStyle(color: textColor),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: otpController.isLoading.value
                    ? null
                    : () async {
                  final success =
                  await otpController.verifyEmailOtp(
                    email: widget.email,
                    otp: _otpTEController.text,
                  );

                  if (!mounted) return;

                  if (success) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                          (_) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Invalid OTP")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA3CC),
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                ),
                child: otpController.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.black,
                )
                    : const Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isWeb ? Center(child: content) : content,
      ),
    );
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
