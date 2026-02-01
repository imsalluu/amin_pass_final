import 'package:amin_pass/home/controller/home_controller.dart';
import 'package:amin_pass/home/screen/notification_screen.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onRewardButtonTap;

  const HomeScreen({super.key, required this.onRewardButtonTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final HomeController homeController = Get.find<HomeController>();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    const desktopBreakpoint = 900;
    final isDesktop = sw >= desktopBreakpoint;

    // 👇 profile section (mobile shows notification icon beside "Hi, Jane!")
    final profileWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() {
          final avatar = profileController.avatarUrl.value;

          return CircleAvatar(
            radius: 32,
            backgroundColor:
            isDark ? Colors.grey.shade800 : Colors.blueGrey.shade100,
            backgroundImage:
            avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? Icon(
              Icons.person,
              size: 32,
              color: isDark ? Colors.white70 : Colors.black54,
            )
                : null,
          );
        }),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    'Hi, ${profileController.name.value.isNotEmpty ? profileController.name.value : 'User'}!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  )),
                  Text(
                    "What's up",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
              if (!isDesktop) ...[
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    size: 28,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final pointsCard = Obx(() {
      final summary = homeController.summary.value;
      final points = summary?.totalAvailablePoints ?? 0;
      final percent = summary?.progressPercentage != null ? (summary!.progressPercentage / 100) : 0.0;
      final pointsNeeded = summary?.pointsNeeded ?? 0;

      return Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF8DBAE9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Points',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$points',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 180,
                  child: Text(
                    pointsNeeded > 0 
                        ? 'You need $pointsNeeded more points to get your next reward'
                        : 'You can claim your reward now!',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 72,
              width: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 72,
                    width: 72,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 8,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    '${(percent * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });

    final buttonsRow = SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onRewardButtonTap(true);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: const Color(0xff7AA3CC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Earn Points',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                widget.onRewardButtonTap(false);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
                side: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'View All Rewards',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final upcomingReward = Obx(() {
      final summary = homeController.summary.value;
      if (summary == null) return const SizedBox.shrink();

      final percent = (summary.progressPercentage / 100);

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.branchName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Next Reward: ${summary.nextReward ?? "Loading..."}',
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              summary.pointsNeeded > 0 
                  ? 'Just ${summary.pointsNeeded} points away!'
                  : 'Reward ready to claim!',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 16,
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(Color(0xff7AA3CC)),
              ),
            ),
          ],
        ),
      );
    });

    final recentActivity = Obx(() {
      final activities = homeController.activities;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (homeController.isLoading.value)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else if (activities.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'No recent activities',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              )
            else
              ...activities.take(10).map((e) {
                IconData icon;
                if (e.type.contains('CLAIM')) {
                  icon = Icons.card_giftcard;
                } else if (e.type.contains('EARN')) {
                  icon = Icons.add_circle;
                } else {
                  icon = Icons.history;
                }

                return ActivityItem(
                  icon: icon,
                  text: e.activityName,
                  date: e.date,
                );
              }).toList(),
          ],
        ),
      );
    });

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profileWidget,
        const SizedBox(height: 16),
        pointsCard,
        const SizedBox(height: 12),
        buttonsRow,
        const SizedBox(height: 12),
      ],
    );

    final mainContent = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: isDesktop
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [leftColumn, upcomingReward],
              ),
            ),
            const SizedBox(width: 30),
            Expanded(flex: 1, child: recentActivity),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftColumn,
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [upcomingReward, recentActivity]),
              ),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: const Color(0xFF7AA3CC),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const SizedBox(width: 48, height: 48),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: mainContent),
          ],
        ),
      );
    }

    // 📱 Mobile layout
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(children: [Expanded(child: mainContent)]),
    );
  }
}

// 🔹 ActivityItem with full dark/light mode support (icon + text + date)
class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String date;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic icon color based on theme and type of icon
    Color getIconColor() {
      if (icon == Icons.add_circle) return isDark ? Colors.green.shade500 : Colors.green.shade500;
      if (icon == Icons.card_giftcard) return isDark ? Colors.white : Colors.black;
      return isDark ? Colors.white : Colors.black;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: getIconColor(), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
