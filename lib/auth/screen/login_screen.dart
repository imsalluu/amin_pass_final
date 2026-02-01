import 'package:amin_pass/auth/controller/login_controller.dart';
import 'package:amin_pass/auth/screen/forgot_password_email_screen.dart';
import 'package:amin_pass/auth/screen/scan_shop_screen.dart';
import 'package:amin_pass/auth/screen/sign_up_screen.dart';
import 'package:amin_pass/auth/screen/verify_otp.dart';
import 'package:amin_pass/common/controller/auth_controller.dart';
import 'package:amin_pass/common/screen/shop_name_show_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final loginController = Get.find<LoginController>();

    final success = await loginController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginController.errorMessage.value)),
      );
      return;
    }

    // ✅ email verified
    if (loginController.isEmailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShopNameShowScreen()),
      );
    }
    // ❌ email not verified → OTP
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }


  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWeb = kIsWeb || size.width >= 1024;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: isWeb ? 400 : double.infinity,
                margin: isWeb
                    ? const EdgeInsets.symmetric(vertical: 40)
                    : EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 40.0),
                decoration: isWeb
                    ? BoxDecoration(
                  color: isDark
                      ? const Color(0xFF121212) // ✅ Dark web bg
                      : Colors.white,            // ✅ Light web bg
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
                      SizedBox(height: isWeb ? 40 : 50),

                      // ✅ SVG Logo Section
                      SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/images/logo_dark.svg'
                            : 'assets/images/aminpass_logo.svg',
                        height: 140,
                      ),
                      const SizedBox(height: 40),

                      // Login title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Login Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email Address",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                hintText: "Enter your mail",
                                hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7AA3CC)),
                                ),
                                filled: true,
                                fillColor:
                                isDark ? Colors.black12 : Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7AA3CC)),
                                ),
                                filled: true,
                                fillColor:
                                isDark ? Colors.black12 : Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                      !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter your password';
                              //   }
                              //   if (value.length < 6) {
                              //     return 'Password must be at least 6 characters';
                              //   }
                              //   return null;
                              // },
                            ),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _forgotPassword,
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Log in button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF7AA3CC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: _signUp,
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Web only: Download banner
            if (isWeb)
              Padding(
                padding:
                const EdgeInsets.only(bottom: 24.0, left: 24, right: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? const Color(0xFF121212)
                        : Colors.white, // ✅ fixed banner color also
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/aminpass_logo.svg',
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Download Aminpass for App",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Access rewards, offers, and loyalty cards easily.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7AA3CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Download"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
