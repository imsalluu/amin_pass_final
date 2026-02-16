import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:amin_pass/card/controller/loyalty_card_controller.dart';
import 'package:amin_pass/card/model/loyalty_card_model.dart';
import 'package:amin_pass/core/services/network/network_client.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/wallets/widgets/wallet_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AddToAppleWalletScreen extends StatelessWidget {
  final LoyaltyCardModel card;

  AddToAppleWalletScreen({super.key, required this.card});

  final ProfileController profileController = Get.find<ProfileController>();
  final LoyaltyCardController cardController = Get.find<LoyaltyCardController>();

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

  void _showConfirmationDialogAfterDelay(BuildContext context) {
    debugPrint("⏱️ Starting 5-second confirmation timer");
    Future.delayed(const Duration(seconds: 5), () {
      if (context.mounted) {
        debugPrint("✅ Showing confirmation dialog");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WalletConfirmationDialog(
            cardId: card.id,
            walletType: "Apple Wallet",
          ),
        );
      }
    });
  }

  Future<void> _addToAppleWallet(BuildContext context) async {
    final link = await cardController.getAppleWalletLink(card.id);
    debugPrint("🍎 Apple Wallet Link: $link");

    if (!context.mounted) return;

    if (link != null && link.isNotEmpty) {
      await _downloadAndOpenPass(context, link);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to generate Apple Wallet link"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadAndOpenPass(BuildContext context, String url) async {
    // Show loading dialog
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Downloading pass..."),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      debugPrint("📥 Downloading pass from: $url");
      
      // Create HTTP client that follows redirects
      final client = http.Client();
      final headers = Get.find<NetworkClient>().commonHeaders();
      
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Download timeout');
        },
      );

      debugPrint("📥 Download status: ${response.statusCode}");
      debugPrint("📥 Content-Type: ${response.headers['content-type']}");
      debugPrint("📥 Content-Length: ${response.bodyBytes.length} bytes");

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (response.statusCode == 200) {
        // Verify we got a pkpass file
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/vnd.apple.pkpass') && 
            response.bodyBytes.length < 100) {
          throw Exception('Invalid pass file received');
        }

        final dir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${dir.path}/loyaltycard_$timestamp.pkpass');
        await file.writeAsBytes(response.bodyBytes);

        debugPrint("✅ Saved to: ${file.path}");
        debugPrint("✅ File size: ${await file.length()} bytes");

        if (!context.mounted) return;

        // Check platform - Wallet app only works on iOS/iPadOS
        if (Platform.isIOS) {
          // iOS: Use file:// URI to open in Wallet app
          final fileUri = Uri.file(file.path);
          debugPrint("📂 Opening file URI on iOS: $fileUri");
          
          try {
            // Launch the file with system default handler (Wallet app for .pkpass)
            final launched = await launchUrl(
              fileUri,
              mode: LaunchMode.externalApplication,
            );
            
            if (!context.mounted) return;
            
            if (launched) {
              debugPrint("✅ Successfully opened in Wallet app");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Opening in Wallet... Tap 'Add' to add the card"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4),
                ),
              );
              
              // Show confirmation dialog after 5 seconds
              _showConfirmationDialogAfterDelay(context);
            } else {
              // Fallback: try opening with OpenFile
              debugPrint("⚠️ launchUrl failed, trying OpenFile...");
              final result = await OpenFile.open(file.path);
              debugPrint("📂 OpenFile result: ${result.type} - ${result.message}");
              
              if (result.type != ResultType.done) {
                throw Exception('Could not open pass file');
              }
            }
          } catch (fileError) {
            debugPrint("⚠️ File launch failed: $fileError, trying backend URL...");
            // Last resort: try the original backend URL
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw Exception('Could not open pass file or URL');
            }
          }
        } else {
          // macOS/Android/Other platforms
          debugPrint("⚠️ Platform is not iOS, trying direct URL launch...");
          
          // Try to open the backend URL directly
          // This might work on macOS if the URL redirects properly
          try {
            final Uri uri = Uri.parse(url);
            final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
            
            if (!context.mounted) return;
            
            if (launched) {
              if (Platform.isMacOS) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Opening pass... You may need to AirDrop this to your iPhone"),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Apple Wallet is only available on iOS devices"),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            } else {
              throw Exception('Could not launch URL');
            }
          } catch (e) {
            debugPrint("❌ URL launch failed: $e");
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    Platform.isMacOS 
                      ? "Please use an iOS device to add to Apple Wallet"
                      : "Apple Wallet is only available on iOS devices"
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        }
      } else if (response.statusCode >= 300 && response.statusCode < 400) {
        // Handle redirect manually if needed
        final location = response.headers['location'];
        if (location != null) {
          debugPrint("🔄 Following redirect to: $location");
          if (context.mounted) {
            await _downloadAndOpenPass(context, location);
          }
        } else {
          throw Exception('Redirect without location header');
        }
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
      
      client.close();
    } catch (e) {
      debugPrint("❌ Error downloading pass: $e");
      
      if (!context.mounted) return;
      
      // Close loading dialog if still open
      Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst || !route.willHandlePopInternally);
      
      // Show error and try URL fallback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download failed: ${e.toString()}"),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Try opening URL directly as last resort
      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (urlError) {
        debugPrint("❌ URL launch also failed: $urlError");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not add to Apple Wallet. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
            child: Obx(() {
              return ElevatedButton(
                onPressed: cardController.isLoading.value ? null : () => _addToAppleWallet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA3CC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: const Color(0xFF7AA3CC).withOpacity(0.6),
                ),
                child: cardController.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              );
            }),
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
