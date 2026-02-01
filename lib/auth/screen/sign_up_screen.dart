import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/auth/screen/otp_forgot_password_screen.dart';
import 'package:amin_pass/auth/screen/scan_shop_screen.dart';
import 'package:amin_pass/auth/screen/verify_otp.dart';
import 'package:amin_pass/common/controller/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  Future<void> _scanQRCode() async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(),
      ),
    );
    //
    // if (scannedData != null && scannedData is String) {
    //   setState(() {
    //     _shopNameController.text = scannedData;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final borderColor = const Color(0xFF7AA3CC);

    final size = MediaQuery.of(context).size;
    final isWeb = kIsWeb || size.width >= 1024;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            width: isWeb ? 400 : double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: isWeb
                ? BoxDecoration(
              color: isDarkMode ? const Color(0xFF121212) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 2),
            )
                : null,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Shop Name Field with Scan Button
                  // Text('Shop Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextFormField(
                  //         controller: _shopNameController,
                  //         readOnly: true,
                  //         decoration: InputDecoration(
                  //           hintText: 'Pizza Burg',
                  //           hintStyle: TextStyle(color: secondaryTextColor),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //             borderSide: BorderSide(color: secondaryTextColor!),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //             borderSide: BorderSide(color: borderColor),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),

                  // Customer Name Field
                  Text('Customer Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: secondaryTextColor!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  Text('Email Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: secondaryTextColor!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  Text('Create a password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: secondaryTextColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: secondaryTextColor),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Text('Confirm password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureRepeatPassword,
                    decoration: InputDecoration(
                      hintText: "Repeat password",
                      hintStyle: TextStyle(color: secondaryTextColor),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureRepeatPassword ? Icons.visibility_off : Icons.visibility, color: secondaryTextColor),
                        onPressed: () => setState(() => _obscureRepeatPassword = !_obscureRepeatPassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        final authController = Get.find<AuthController>();

                        final success = await authController.register(
                          name: _customerNameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );

                        if (!mounted) return;

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerifyOtpScreen(
                                email: _emailController.text.trim(),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signup failed")),
                          );
                        }
                      },


                      style: ElevatedButton.styleFrom(
                        backgroundColor: borderColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Sign up', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: TextStyle(color: secondaryTextColor)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: Text(
                            'Log in',
                            style: TextStyle(color: borderColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
