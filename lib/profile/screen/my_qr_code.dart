import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amin_pass/profile/controller/qr_code_controller.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final QrCodeController controller =
    Get.find<QrCodeController>();

    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// QR CONTAINER
          Container(
            width: 375,
            height: 383,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// QR IMAGE
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.qrCodeUrl.value.isEmpty
                      ? const Icon(Icons.qr_code_2,
                      size: 200)
                      : Image.network(
                    controller.qrCodeUrl.value,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Scan Me",
                  style: TextStyle(
                    color: theme.textTheme.bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// CODE
          Column(
            children: [
              Text(
                "Code:",
                style: TextStyle(
                  color: theme.textTheme.bodySmall
                      ?.color
                      ?.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.qrCode.value,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// INFO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.blueGrey.shade900
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDark
                      ? Colors.lightBlue.shade200
                      : Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Show this QR code to scan or share the code manually",
                   style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.w500,
                   ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );

    /// DESKTOP
    if (isDesktop) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Scan QR Code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(width: 600, child: content),
              ),
            ),
          ],
        ),
      );
    }

    /// MOBILE
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }
}
