import 'package:amin_pass/card/controller/loyalty_card_controller.dart';
import 'package:amin_pass/card/model/loyalty_card_model.dart';
import 'package:amin_pass/common/screen/bottom_nav_bar.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/wallets/screen/add_to_apple_wallet_screen.dart';
import 'package:amin_pass/wallets/screen/add_to_google_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddToWalletScreen extends StatelessWidget {
  final String shopName;

  AddToWalletScreen({super.key, required this.shopName});

  final LoyaltyCardController cardController = Get.find<LoyaltyCardController>();
  final ProfileController profileController = Get.find<ProfileController>();

  Color _parseColor(String hex, Color fallback) {
    try {
      if (hex.isEmpty) return fallback;
      String cleanHex = hex.replaceAll('#', '');
      
      // Handle potential invalid hex characters gracefully by checking length and content
      if (cleanHex.length != 6 && cleanHex.length != 8) {
         // Try to fix common issues or just return fallback
         return fallback;
      }
      
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

    final walletTextColor = isDark ? Colors.white : Colors.black;

    // Ensure fresh data
    cardController.fetchLoyaltyCards();

    final content = Obx(() {
      if (cardController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (cardController.cards.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wallet_giftcard, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "No cards found for $shopName",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }



      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Text(
              "Select a Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // 🔹 Horizontal selection of cards
            SizedBox(
              height: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cardController.cards.length,
                itemBuilder: (context, index) {
                  final card = cardController.cards[index];
                  final isSelected = cardController.selectedCard.value?.id == card.id;
                  final textColor = _parseColor(card.textColor, Colors.black);

                  return GestureDetector(
                    onTap: () => cardController.selectedCard.value = card,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 320,
                      margin: const EdgeInsets.only(right: 16, bottom: 10),
                      decoration: BoxDecoration(
                        color: _parseColor(card.cardBackground, const Color(0xFF7AA3CC)),
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected 
                            ? Border.all(color: isDark ? Colors.white : Colors.blue, width: 4)
                            : Border.all(color: Colors.transparent, width: 4),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ] : null,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top info
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
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Points ${profileController.rewardPoints.value}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Banner
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              card.stampBackground.isNotEmpty ? card.stampBackground : 'https://img.freepik.com/free-vector/loyalty-program-illustration_335657-3389.jpg',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Desc
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
                          const Spacer(),
                          // QR
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: QrImageView(
                              data: card.id,
                              version: QrVersions.auto,
                              size: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (cardController.selectedCard.value != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToAppleWalletScreen(card: cardController.selectedCard.value!),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.apple, color: Colors.black),
                    label: const Text("Add to Apple Wallet", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7AA3CC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (cardController.selectedCard.value != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToGoogleWalletScreen(card: cardController.selectedCard.value!),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.account_balance_wallet_outlined, color: walletTextColor),
                    label: Text("Add to Google Wallet", style: TextStyle(color: walletTextColor, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: walletTextColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
      appBar: AppBar(
        title: Text("Cards", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavController())),
              child: Text("Skip", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}


