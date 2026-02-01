import 'package:amin_pass/card/controller/loyalty_card_controller.dart';
import 'package:amin_pass/card/model/loyalty_card_model.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoyaltyCardScreen extends StatelessWidget {
  LoyaltyCardScreen({super.key});

  final LoyaltyCardController controller = Get.find<LoyaltyCardController>();
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

    // 🔹 Build a single card item
    Widget _buildCard(LoyaltyCardModel card) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _parseColor(card.cardBackground, const Color(0xFF7AA3CC)),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Top Row (Shop info + points)
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
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _parseColor(card.textColor, Colors.black),
                      ),
                    ),
                  ],
                ),
                Obx(() => Text(
                  "Points ${profileController.rewardPoints.value}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _parseColor(card.textColor, Colors.black),
                  ),
                )),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Card Banner Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                card.stampBackground.isNotEmpty ? card.stampBackground : 'https://img.freepik.com/free-vector/loyalty-program-illustration_335657-3389.jpg',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 30),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Card Desc + Reward Program
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    card.cardDesc,
                    style: TextStyle(
                      color: _parseColor(card.textColor, Colors.black),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  card.rewardProgram.toUpperCase(),
                  style: TextStyle(
                    color: _parseColor(card.textColor, Colors.black),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 QR Code (centered)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: card.id,
                version: QrVersions.auto,
                size: 90,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final mainWidget = Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.cards.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card_off_outlined, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "No cards available for this branch",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.only(top: 30, bottom: 40),
        itemCount: controller.cards.length,
        itemBuilder: (context, index) => _buildCard(controller.cards[index]),
      );
    });

    // 💻 Desktop/Web Layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor:
        isDark ? theme.colorScheme.background : const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // 🔸 Top Blue Header
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              alignment: Alignment.center,
              child: const Text(
                "Loyalty Card",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // 🔸 Centered card (no background container)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: mainWidget,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 📱 Mobile Layout (unchanged)
    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
      appBar: AppBar(
        title: Text(
          "Loyalty Card",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: mainWidget,
    );
  }
}
