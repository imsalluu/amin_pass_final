import 'package:amin_pass/card/model/loyalty_card_model.dart';
import 'package:amin_pass/common/screen/bottom_nav_bar.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddToAppleWalletScreen extends StatelessWidget {
  final LoyaltyCardModel card;

  AddToAppleWalletScreen({super.key, required this.card});

  final ProfileController profileController = Get.find<ProfileController>();

  Color _parseColor(String hex, Color fallback) {
    try {
      if (hex.isEmpty) return fallback;
      String cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) cleanHex = 'FF$cleanHex';
      return Color(int.parse('0x$cleanHex'));
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    const desktopBreakpoint = 900;
    final isDesktop = sw >= desktopBreakpoint;

    final buttonTextColor = isDark ? Colors.white : Colors.black;

    // Main content
    final textColor = _parseColor(card.textColor, Colors.black);
    final cardBg = _parseColor(card.cardBackground, const Color(0xFF7AA3CC));

    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Loyalty Card
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(card.logo),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          card.companyName,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
                        ),
                      ],
                    ),
                    Text(
                      "Points ${profileController.rewardPoints.value}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    card.stampBackground.isNotEmpty ? card.stampBackground : 'https://img.freepik.com/free-vector/loyalty-program-illustration_335657-3389.jpg',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 120, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        card.cardDesc,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      card.rewardProgram.toUpperCase(),
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: QrImageView(data: card.id, version: QrVersions.auto, size: 80),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavController())),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7AA3CC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonTextColor.withOpacity(0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Cancel", style: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );



    // 💻 Desktop/Web layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor:
        isDark ? theme.colorScheme.background : const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // Header Bar
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              alignment: Alignment.center,
              child: const Text(
                "Add To Apple Wallet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Center-aligned content (no card container)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 📱 Mobile layout (unchanged)
    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
        elevation: 0.4,
        centerTitle: true,
        title: Text(
          "Add To Apple Wallet",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: content,
    );
  }
}
