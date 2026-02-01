import 'package:amin_pass/auth/controller/forgot_password_otp_controller.dart';
import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/auth/screen/reset_password_screen.dart';
import 'package:amin_pass/auth/screen/scan_shop_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpForgotPasswordScreen extends StatefulWidget {
  final String email;

  const OtpForgotPasswordScreen({super.key, required this.email});

  @override
  State<OtpForgotPasswordScreen> createState() => _OtpForgotPasswordScreenState();
}

class _OtpForgotPasswordScreenState extends State<OtpForgotPasswordScreen> {
  final TextEditingController _otpTEController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isWeb ? 40 : 120), // Mobile এ ফাঁকা কমানো
            Text(
              'Please Check your email',
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
                fontWeight: FontWeight.w400,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 40),
            PinCodeTextField(
              controller: _otpTEController,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldWidth: 50,
                fieldHeight: 50,
                activeFillColor: backgroundColor,
                selectedColor: const Color(0xFF7AA3CC),
                inactiveColor: Colors.grey,
                inactiveFillColor: backgroundColor,
                selectedFillColor: Colors.transparent,
              ),
              animationDuration: const Duration(milliseconds: 300),
              appContext: context,
              validator: (String? value) {
                if (value == null || value.length < 4) {
                  return 'Enter your OTP';
                }
                return null;
              },
              textStyle: TextStyle(color: textColor),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final controller = Get.find<ForgotPasswordOtpController>();

                  final otp = _otpTEController.text.trim();

                  if (otp.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid OTP")),
                    );
                    return;
                  }

                  final success = await controller.verifyForgotOtp(
                    email: widget.email, // ✅ real email
                    otp: otp,
                  );

                  if (!mounted) return;

                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(controller.errorMessage.value)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA3CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Send Code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
            ? Center(child: content) // Web: Centered
            : content,               // Mobile: Not centered
      ),
    );
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
