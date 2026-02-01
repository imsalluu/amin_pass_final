import 'dart:convert';
import 'package:amin_pass/common/controller/register_branch_controller.dart';
import 'package:amin_pass/common/controller/shop_branch_controller.dart';
import 'package:amin_pass/common/screen/shop_name_show_screen.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();
  late AnimationController _animationController;

  final RegisterBranchController registerController =
  Get.find<RegisterBranchController>();
  final ProfileController profileController =
  Get.find<ProfileController>();

  String? scannedCode;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String code) async {
    if (isProcessing) return;
    isProcessing = true;

    debugPrint('🔍 QR Code scanned: $code');

    String? businessId;
    String? branchId;

    try {
      // 1. Try parsing as JSON first
      if (code.trim().startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(code);
        businessId = data['businessId']?.toString();
        branchId = data['branchId']?.toString();
      }

      // 2. Try pipe separator
      if (businessId == null || branchId == null) {
        final parts = code.split('|');
        if (parts.length >= 2) {
          businessId = parts[0].trim();
          branchId = parts[1].trim();
        }
      }

      // 3. Try colon separator
      if (businessId == null || branchId == null) {
        final parts = code.split(':');
        if (parts.length >= 2) {
          businessId = parts[0].trim();
          branchId = parts[1].trim();
        }
      }
    } catch (e) {
      debugPrint('❌ Error parsing QR code: $e');
    }

    if (businessId == null || branchId == null || businessId.isEmpty || branchId.isEmpty) {
      Get.snackbar(
        'Invalid QR',
        'This QR code is not a valid shop registration code.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isProcessing = false;
      return;
    }
    final customerId = profileController.id.value;

    if (customerId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please try again.');
      isProcessing = false;
      return;
    }

    final success = await registerController.registerBranch(
      customerId: customerId,
      businessId: businessId,
      branchId: branchId,
    );

    if (success) {
      cameraController.stop();
      
      Get.snackbar(
        'Success',
        'Registered to branch successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      if (Get.isRegistered<ShopBranchController>()) {
        await Get.find<ShopBranchController>().fetchAllBranches();
      }
      Get.offAll(() => const ShopNameShowScreen());
    }

    isProcessing = false;
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue;
      if (code != null && scannedCode != code) {
        scannedCode = code;
        _handleScan(code);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWeb = kIsWeb || size.width >= 1024;
    final scanBoxSize = isWeb ? 300.0 : 250.0;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),

            // scan box
            Container(
              height: scanBoxSize,
              width: scanBoxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                Border.all(color: const Color(0xFF7AA3CC), width: 3),
              ),
            ),

            // animated line
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return Positioned(
                  top: size.height * 0.5 -
                      (scanBoxSize / 2) +
                      (scanBoxSize * _animationController.value),
                  child: Container(
                    height: 2,
                    width: scanBoxSize - 20,
                    color: const Color(0xFF7AA3CC),
                  ),
                );
              },
            ),

            // header
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Scan Shop QR Code',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // loading
            Obx(() => registerController.isLoading.value
                ? const Positioned(
              bottom: 80,
              child: CircularProgressIndicator(),
            )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
