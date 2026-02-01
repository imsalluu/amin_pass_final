import 'package:amin_pass/settings/screen/notification_screen.dart';
import 'package:amin_pass/settings/screen/password_change_screen.dart';
import 'package:amin_pass/settings/screen/privacy_policy_screen.dart';
import 'package:amin_pass/settings/screen/terms_and_condition.dart';
import 'package:amin_pass/theme/app_color.dart';
import 'package:amin_pass/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          ProfileOption(
            icon: Icons.lock,
            title: "Password Change",
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordChangeScreen()),
              );
            },
            isDesktop: isDesktop,
          ),
          ProfileOption(
            icon: Icons.notifications,
            title: "Notification",
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PushNotificationsScreen()),
              );
            },
            isDesktop: isDesktop,
          ),
          ProfileOption(
            icon: isDark ? Icons.light_mode : Icons.dark_mode,
            title: "App Theme",
            iconColor: AppColors.primary,
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeColor: AppColors.primary,
            ),
            onTap: () {},
            isDesktop: isDesktop,
          ),
          ProfileOption(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacySafetyScreen()),
              );
            },
            isDesktop: isDesktop,
          ),
          ProfileOption(
            icon: Icons.help_rounded,
            title: "Terms of Condition",
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsAndCondition()),
              );
            },
            isDesktop: isDesktop,
          ),
        ],
      ),
    );

    // Desktop layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      'Settings',
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 900,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80), // <-- Adjust this value
                    child: content,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(child: content),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Widget? trailing;
  final bool isDesktop;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconColor,
    this.trailing,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final cardWidth = isDesktop ? 800.0 : double.infinity;
    final fontSize = isDesktop ? 18.0 : 18.0;
    final iconSize = isDesktop ? 26.0 : 24.0;
    final arrowSize = isDesktop ? 18.0 : 16.0;

    final card = Card(
      color: isDark ? AppColors.darkBackground : Colors.white,
      shadowColor: isDark ? Colors.transparent : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: iconSize),
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios,
                size: arrowSize,
                color: isDark ? Colors.white70 : Colors.black54),
        onTap: onTap,
      ),
    );

    if (isDesktop) {
      return Center(child: SizedBox(width: cardWidth, child: card));
    }

    return card;
  }
}
