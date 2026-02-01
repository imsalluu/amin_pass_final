import 'package:amin_pass/auth/screen/reset_password_successful_screen.dart';
import 'package:amin_pass/theme/app_color.dart';
import 'package:amin_pass/theme/theme_provider.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/app/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _oldPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController =
  TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _isLoading = false;

  late NetworkClient _client;

  @override
  void initState() {
    super.initState();
    _client = Get.find<NetworkClient>();
  }

  /// 🔵 CHANGE PASSWORD API
  Future<void> _changePassword() async {
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await _client.postRequest(
      ApiUrls.changePassword,
      body: {
        "oldPassword": oldPass,
        "newPassword": newPass,
      },
    );

    setState(() => _isLoading = false);

    if (res.isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ResetPasswordSuccessfulScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(res.errorMassage ?? 'Password change failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final backgroundColor =
    isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.black12 : Colors.white;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    final formContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// OLD PASSWORD
          Text(
            'Old Password',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            _oldPasswordController,
            _obscureOldPassword,
                (val) =>
                setState(() => _obscureOldPassword = val),
            "Enter old password",
            cardColor,
            iconColor,
          ),

          const SizedBox(height: 20),

          /// NEW PASSWORD
          Text(
            'New Password',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            _newPasswordController,
            _obscureNewPassword,
                (val) =>
                setState(() => _obscureNewPassword = val),
            "Enter new password",
            cardColor,
            iconColor,
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.black,
              )
                  : Text(
                'Save Changes',
                style: TextStyle(
                  color: isDark ? Colors.black : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    /// DESKTOP
    if (isDesktop) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: AppColors.primary,
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Password Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 600,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 30),
                    child: formContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// MOBILE
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Password Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(child: formContent),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      bool obscure,
      ValueChanged<bool> toggle,
      String hint,
      Color fillColor,
      Color iconColor,
      ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: iconColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        TextStyle(color: iconColor.withOpacity(0.5)),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        focusedBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(6),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: iconColor,
          ),
          onPressed: () => toggle(!obscure),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
