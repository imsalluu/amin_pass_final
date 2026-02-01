import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Message alert!',
      'body': "You've received a new message from Sarah.",
      'timestamp': '2025-11-03 10:00:00',
    },
    {
      'title': 'New Customer',
      'body': '"New customer, Sarah K., joined the loyalty program."',
      'timestamp': '2025-11-02 14:30:00',
    },
    {
      'title': 'Reward alert!',
      'body': 'Customer ID #123 redeemed a \$100 gift card reward.',
      'timestamp': '2025-11-01 20:00:00',
    },
    {
      'title': 'Success Alert!',
      'body': 'Your active loyalty customer count increased by 10%.',
      'timestamp': '2025-10-29 18:45:00',
    },
    {
      'title': 'Data Sync Alert!',
      'body': 'There was an issue syncing sales data. Please retry.',
      'timestamp': '2025-10-27 09:15:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    const desktopBreakpoint = 900;
    final isDesktop = sw >= desktopBreakpoint;

    // Convert timestamps to DateTime and sort descending
    notifications = notifications.map((n) {
      return {
        ...n,
        'timestamp': DateTime.parse(n['timestamp']),
      };
    }).toList()
      ..sort((a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    // 🟦 Notification item container
    final listView = ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final data = notifications[index];
        final title = data['title'] as String;
        final body = data['body'] as String;
        final timestamp = data['timestamp'] as DateTime;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(
              color: cs.outline.withOpacity(0.08),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.75),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Time
              Text(
                DateFormat('hh:mm a').format(timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      },
    );

    // 🖥️ WEB / DESKTOP Layout (EditProfile-style)
    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark ? cs.background : Colors.white,
        body: Column(
          children: [
            // Top Header Bar (same as EditProfile)
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  // Center Title
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Notifications",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Back Button
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

            // Main Content
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 600,
                  child: listView,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 📱 MOBILE Layout (unchanged)
    return Scaffold(
      backgroundColor: isDark ? cs.background : Colors.white,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: theme.textTheme.bodyMedium?.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: listView,
    );
  }
}
