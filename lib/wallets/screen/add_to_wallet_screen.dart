import 'package:amin_pass/common/screen/bottom_nav_bar.dart';
import 'package:amin_pass/wallets/screen/add_to_apple_wallet_screen.dart';
import 'package:amin_pass/wallets/screen/add_to_google_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddToWalletScreen extends StatelessWidget {
  final String shopName;

  const AddToWalletScreen({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    const desktopBreakpoint = 900;
    final isDesktop = sw >= desktopBreakpoint;

    final walletTextColor = isDark ? Colors.white : Colors.black;

    // 🔹 Main content (card + buttons)
    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Loyalty Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7AA3CC),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "☕ $shopName",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: List.generate(
                    7,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.coffee, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "6th ☕ on us",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Stamps\n2",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Available Rewards\n0 rewards",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                QrImageView(
                  data: "https://example.com/coffee",
                  version: QrVersions.auto,
                  size: 120,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🔹 Apple Wallet Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddToAppleWalletScreen(shopName: shopName),
                  ),
                );
              },
              icon: const Icon(Icons.apple, color: Colors.black, size: 20),
              label: const Text(
                "Add to Apple Wallet",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7AA3CC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Google Wallet Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddToGoogleWalletScreen(shopName: shopName),
                  ),
                );
              },
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                color: walletTextColor,
                size: 20,
              ),
              label: Text(
                "Add to Google Wallet",
                style: TextStyle(
                  color: walletTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: walletTextColor.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    // 💻 Desktop / Web Layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark
            ? theme.colorScheme.background
            : const Color(0xFFF5F7FA),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  color: const Color(0xFF7AA3CC),
                  alignment: Alignment.center,
                  child: const Text(
                    "Cards",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
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

            // 🟣 Skip button (top-right corner)
            Positioned(
              top: 25,
              right: 25,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Skip",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 📱 Mobile Layout
    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
        elevation: 0.4,
        centerTitle: true,
        title: Text(
          "Cards",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavController(),
                  ),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
