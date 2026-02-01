import 'package:amin_pass/auth/screen/login_screen.dart';
import 'package:amin_pass/auth/screen/scan_shop_screen.dart';
import 'package:amin_pass/common/controller/auth_controller.dart';
import 'package:amin_pass/common/screen/shop_name_show_screen.dart';
import 'package:amin_pass/home/screen/notification_screen.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/profile/screen/edit_profile_screen.dart';
import 'package:amin_pass/profile/screen/my_qr_code.dart';
import 'package:amin_pass/profile/screen/transaction_history.dart';
import 'package:amin_pass/settings/screen/setting_screen.dart';
import 'package:amin_pass/theme/app_color.dart';
import 'package:amin_pass/theme/theme_provider.dart';
import 'package:amin_pass/wallets/screen/add_to_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ProfileController profileController =
  Get.find<ProfileController>();


  void _showLogoutBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(45),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: textColor,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close sheet
                      Get.find<AuthController>().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Yes, Logout",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final bgColor = theme.scaffoldBackgroundColor;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final mainContent = Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Row(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.1),
                  border: Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    final avatar = profileController.avatarUrl.value;

                    if (avatar.isNotEmpty) {
                      return Image.network(
                        avatar,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.person, size: 40, color: textColor),
                      );
                    }

                    return Icon(Icons.person,
                        size: 40, color: textColor?.withOpacity(0.7));
                  }),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      "Hi, ${profileController.name.value}!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    )),

                    Obx(() => Text(
                      profileController.email.value,
                      style: TextStyle(
                        color: textColor?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    )),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );

                        profileController.fetchProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7AA3CC),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Profile options
          ProfileOption(
            icon: Icons.history,
            title: "Transaction History",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TransactionHistoryScreen()),
            ),
            iconColor: const Color(0xff7AA3CC),
          ),
          ProfileOption(
            icon: Icons.settings,
            title: "Settings",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            ),
            iconColor: const Color(0xff7AA3CC),
          ),
          ProfileOption(
            icon: Icons.qr_code,
            title: "My QR",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrCodeScreen()),
            ),
            iconColor: const Color(0xff7AA3CC),
          ),
          ProfileOption(
            icon: Icons.wallet,
            title: "Add to Wallet",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddToWalletScreen(shopName: "Starbucks")),
            ),
            iconColor: const Color(0xff7AA3CC),
          ),
          ProfileOption(
            icon: Icons.app_registration,
            title: "Add new shop",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScannerScreen()),
            ),
            iconColor: const Color(0xff7AA3CC),
          ),

          // Logout option
          Card(
            color: isDark ? AppColors.darkBackground : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade300),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Log Out",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
              onTap: _showLogoutBottomSheet,
            ),
          )
        ],
      ),
    );

    if (isDesktop) {
      // Desktop layout with top container (notification)
      return Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const SizedBox(width: 48, height: 48),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none,
                        size: 28, color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(width: 1000, child: mainContent),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: mainContent,
      ),
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

    final cardWidth = isDesktop ? 200.0 : double.infinity;
    final fontSize = isDesktop ? 16.0 : 18.0;
    final iconSize = isDesktop ? 20.0 : 24.0;
    final arrowSize = isDesktop ? 14.0 : 16.0;

    final card = Card(
      color: isDark ? AppColors.darkBackground : Colors.white,
      shadowColor: isDark ? Colors.transparent : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 6),
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
