import 'package:amin_pass/settings/controller/notification_settings_controller.dart';
import 'package:amin_pass/theme/app_color.dart';
import 'package:amin_pass/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  final controller = Get.find<NotificationSettingsController>();

  @override
  void initState() {
    super.initState();
    controller.fetchSettings();
  }

  Widget _sectionTitle(String t, Color textColor) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    ),
  );

  Widget _tile({
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    required Color textColor,
    required Color subTextColor,
    required Color cardColor,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
            subtitle,
            style: TextStyle(color: subTextColor, fontSize: 12.5),
          ),
          trailing: trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          visualDensity: const VisualDensity(vertical: -1),
        ),
      ),
    );
  }

  Widget _card(List<Widget> children, Color cardColor, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? Colors.black12 : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    final content = Padding(
      padding: const EdgeInsets.all(8),
      child: Obx(() {
        if (controller.isLoading.value && controller.settings.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final s = controller.settings.value;
        if (s == null) {
          return Center(
            child: Text(
              "Could not load settings",
              style: TextStyle(color: textColor),
            ),
          );
        }

        return Column(
          children: [
            _card([
              _tile(
                title: 'SMS Updates',
                trailing: Switch(
                  value: s.smsUpdates,
                  onChanged: (v) => controller.toggleSms(v),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                ),
                textColor: textColor,
                subTextColor: subTextColor,
                cardColor: cardColor,
              ),
            ], cardColor, borderColor),
            const SizedBox(height: 18),
            _card([
              _tile(
                title: 'Push Notification',
                trailing: Switch(
                  value: s.pushNotification,
                  onChanged: (v) => controller.togglePush(v),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                ),
                textColor: textColor,
                subTextColor: subTextColor,
                cardColor: cardColor,
              ),
            ], cardColor, borderColor),
            const SizedBox(height: 18),
            _card([
              _tile(
                title: 'Birthday Rewards',
                trailing: Switch(
                  value: s.birthdayRewards,
                  onChanged: (v) => controller.toggleBirthday(v),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                ),
                textColor: textColor,
                subTextColor: subTextColor,
                cardColor: cardColor,
              ),
            ], cardColor, borderColor),
            const SizedBox(height: 18),
            _card([
              _tile(
                title: 'Allow Location',
                trailing: Switch(
                  value: s.allowLocation,
                  onChanged: (v) => controller.toggleLocation(v),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                ),
                textColor: textColor,
                subTextColor: subTextColor,
                cardColor: cardColor,
              ),
            ], cardColor, borderColor),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: controller.isLoading.value ? null : () => controller.saveSettings(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.black : Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
              child: SizedBox(
                width: 800,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
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
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          content,
        ],
      ),
    );
  }
}
