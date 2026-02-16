import 'package:amin_pass/card/controller/loyalty_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class WalletConfirmationDialog extends StatelessWidget {
  final String cardId;
  final String walletType; // "Apple Wallet" or "Google Wallet"

  const WalletConfirmationDialog({
    super.key,
    required this.cardId,
    required this.walletType,
  });

  Future<void> _handleYes(BuildContext context) async {
    final controller = Get.find<LoyaltyCardController>();
    
    // Close the dialog first
    Navigator.of(context).pop();
    
    // Show loading
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Saving..."),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
    
    // Call API
    final success = await controller.saveCardToWallet(cardId);
    
    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    
    // Show result
    if (success) {
      Get.snackbar(
        "Success",
        "Card saved to $walletType successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF7AA3CC),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to save card. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  void _handleNo(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7AA3CC).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wallet,
                    size: 48,
                    color: Color(0xFF7AA3CC),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  "Card Added?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  "Did you successfully add the card to your $walletType?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                
                // Buttons
                Row(
                  children: [
                    // No Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _handleNo(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Yes Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleYes(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
