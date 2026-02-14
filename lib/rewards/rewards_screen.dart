import 'package:amin_pass/home/screen/notification_screen.dart';
import 'package:amin_pass/profile/controller/profile_controller.dart';
import 'package:amin_pass/rewards/controller/earn_reward_controller.dart';
import 'package:amin_pass/rewards/model/earn_reward_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardRedeemModal extends StatefulWidget {
  final bool startWithEarnPoints;

  const RewardRedeemModal({super.key, this.startWithEarnPoints = true});

  @override
  State<RewardRedeemModal> createState() => _RewardRedeemModalState();
}

class _RewardRedeemModalState extends State<RewardRedeemModal> {
  late bool showEarnPoints;
  final controller = Get.find<EarnRewardController>();

  @override
  void initState() {
    super.initState();
    showEarnPoints = widget.startWithEarnPoints;
    // 🔹 Fetch fresh data
    Get.find<ProfileController>().fetchProfile(); // ✅ Fetch fresh points
    controller.getEarnRewards();
    controller.getClaimRewards();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final isDesktop = sw >= 900;

    final mainContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabButton(
                'Earn Points',
                showEarnPoints,
                    () => setState(() => showEarnPoints = true),
                isDark,
                isDesktop,
              ),
              SizedBox(width: isDesktop ? 12 : 20),
              _tabButton(
                'View All Rewards',
                !showEarnPoints,
                    () => setState(() => showEarnPoints = false),
                isDark,
                isDesktop,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              // 🔹 Show loader
              if (controller.isLoadingEarn.value ||
                  controller.isLoadingClaim.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // 🔹 Show error if any
              if (controller.errorMessage.value.isNotEmpty &&
                  controller.earnRewards.isEmpty &&
                  controller.claimRewards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87)),
                      TextButton(
                        onPressed: () {
                          controller.getEarnRewards();
                          controller.getClaimRewards();
                        },
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              if (showEarnPoints) {
                if (controller.earnRewards.isEmpty) {
                  return _emptyState('No earnable rewards available.', isDark);
                }
                return EarnPointsTab(
                  earnPoints: controller.earnRewards,
                  isDark: isDark,
                  isDesktop: isDesktop,
                );
              } else {
                if (controller.claimRewards.isEmpty) {
                  return _emptyState('No claimable rewards available.', isDark);
                }
                return ViewAllRewardsTab(
                  userPoints: Get.find<ProfileController>().rewardPoints.value,
                  rewards: controller.claimRewards,
                  isDark: isDark,
                  isDesktop: isDesktop,
                  onClaim: (item) {
                    controller.claimReward(item.id);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );

    // Desktop layout
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
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Reward Redeem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_none,
                          size: 28, color: Colors.black),
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

    // Mobile layout
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Reward Redeem',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: mainContent,
    );
  }

  Widget _tabButton(
      String text, bool active, VoidCallback onTap, bool isDark, bool isDesktop) {
    return Expanded(
      flex: isDesktop ? 0 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isDesktop ? 160 : double.infinity,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
            color: active ? const Color(0xFF7AA3CC) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active
                  ? Colors.black
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(String message, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard,
              size: 64, color: isDark ? Colors.white24 : Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- Earn Points Tab -------------------
class EarnPointsTab extends StatelessWidget {
  final List<RewardModel> earnPoints;
  final bool isDark;
  final bool isDesktop;

  const EarnPointsTab({
    super.key,
    required this.earnPoints,
    required this.isDark,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isDesktop ? 2 : 1;

    return Center(
      child: SizedBox(
        width: isDesktop ? 1000 : double.infinity,
        child: isDesktop
            ? GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.2,
          ),
          itemCount: earnPoints.length,
          itemBuilder: (context, index) => _buildCard(earnPoints[index]),
        )
            : ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: earnPoints.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _buildCard(earnPoints[index]),
        ),
      ),
    );
  }

  Widget _buildCard(RewardModel item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.rewardName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Earn ${item.points} pts',
                    style: const TextStyle(
                      color: Color(0xFF357ABD),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
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

/// ------------------- View All Rewards Tab -------------------
class ViewAllRewardsTab extends StatefulWidget {
  final int userPoints;
  final List<RewardModel> rewards;
  final Function(RewardModel) onClaim;
  final bool isDark;
  final bool isDesktop;

  const ViewAllRewardsTab({
    super.key,
    required this.userPoints,
    required this.rewards,
    required this.onClaim,
    required this.isDark,
    required this.isDesktop,
  });

  @override
  State<ViewAllRewardsTab> createState() => _ViewAllRewardsTabState();
}

class _ViewAllRewardsTabState extends State<ViewAllRewardsTab> {
  late int userPoints;

  @override
  void initState() {
    super.initState();
    userPoints = widget.userPoints;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isDesktop = widget.isDesktop;
    final controller = Get.find<EarnRewardController>();

    return Center(
      child: SizedBox(
        width: isDesktop ? 1000 : double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text('Your Points',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(width: 6),
                Obx(() => Text('${controller.branchPoints.value}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black))),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isDesktop
                  ? GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.2,
                ),
                itemCount: widget.rewards.length,
                itemBuilder: (context, index) => _buildCard(widget.rewards[index], controller),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: widget.rewards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) => _buildCard(widget.rewards[index], controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(RewardModel item, EarnRewardController controller) {
    return Obx(() {
      int currentPoints = controller.branchPoints.value;
      bool canClaim = currentPoints >= item.points;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.black12 : Colors.white,
          border: Border.all(color: widget.isDark ? Colors.white24 : Colors.black12),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    item.image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.rewardName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${item.points} pts',
                        style: const TextStyle(
                          color: Color(0xFF357ABD),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expire: ${item.expiryDays} days',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: item.isClaimed
                      ? null
                      : () {
                          if (canClaim) {
                            widget.onClaim(item);
                          } else {
                            Get.snackbar(
                              'Insufficient Points',
                              'You need ${item.points - currentPoints} more points to claim this reward.',
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: item.isClaimed
                          ? Colors.grey
                          : const Color(0xFF7AA3CC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.isClaimed ? 'Claimed' : 'Claim',
                      style: TextStyle(
                        color: item.isClaimed ? Colors.black54 : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
