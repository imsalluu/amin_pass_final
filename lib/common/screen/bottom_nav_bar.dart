// bottom_nav_controller.dart
import 'package:amin_pass/card/screen/loyalty_card_screen.dart';
import 'package:amin_pass/profile/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:amin_pass/home/screen/home_screen.dart';
import 'package:amin_pass/rewards/rewards_screen.dart';

// Reusable container
class AppContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final Color? color;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppContainer({
    required this.child,
    this.height = 110, // 🔹 Increased significantly to prevent overflow
    this.color,
    this.borderRadius,
    this.boxShadow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black87);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: borderRadius ?? BorderRadius.circular(25),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(25),
        child: child,
      ),
    );
  }
}

class BottomNavController extends StatefulWidget {
  final int initialIndex;
  const BottomNavController({super.key, this.initialIndex = 0});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  late bool startWithEarnPoints;

  // drawer expanded/collapsed state for desktop
  bool _drawerExpanded = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // ✅ Set initial index
    startWithEarnPoints = true;
    _drawerExpanded = true;
  }

  @override
  bool get wantKeepAlive => true;

  void _setIndex(int idx) {
    if (_currentIndex == idx) return;
    setState(() {
      _currentIndex = idx;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _drawerExpanded = !_drawerExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    const desktopBreakpoint = 900;
    final isDesktop = sw >= desktopBreakpoint;

    final List<Widget> _screens = [
      HomeScreen(onRewardButtonTap: (isEarnPoints) {
        setState(() {
          _currentIndex = 1; // Rewards tab index
          startWithEarnPoints = isEarnPoints;
        });
      }),
      RewardRedeemModal(
        key: ValueKey(startWithEarnPoints),
        startWithEarnPoints: startWithEarnPoints,
      ),
      LoyaltyCardScreen(),
      ProfileScreen(),
    ];

    // Desktop layout
    if (isDesktop) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Row(
          children: [
            _buildDesktopDrawer(isDark),
            const SizedBox(width: 0),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
        child: AppContainer(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xFF80BFFF),
            unselectedItemColor: isDark ? Colors.black87 : Colors.white70,
            onTap: (index) {
              if (_currentIndex != index) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            items: [
              _buildBarItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', isActive: _currentIndex == 0, isDark: isDark),
              _buildBarItem(icon: Icons.card_giftcard_outlined, activeIcon: Icons.card_giftcard, label: 'Rewards', isActive: _currentIndex == 1, isDark: isDark),
              _buildBarItem(icon: Icons.credit_card_outlined, activeIcon: Icons.credit_card, label: 'Card', isActive: _currentIndex == 2, isDark: isDark),
              _buildBarItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', isActive: _currentIndex == 3, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopDrawer(bool isDark) {
    const double expandedWidth = 220;
    const double collapsedWidth = 72;
    final Color activeColor = const Color(0xFF80BFFF);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _drawerExpanded ? expandedWidth : collapsedWidth,
      margin: const EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            // Header with hamburger
            AppContainer(
              height: 80,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              color: const Color(0xFF7AA3CC),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black87),
                    onPressed: _toggleDrawer,
                    tooltip: _drawerExpanded ? 'Collapse' : 'Expand',
                  ),
                  if (_drawerExpanded)
                    const Expanded(
                      child: Text('', textAlign: TextAlign.center),
                    ),
                ],
              ),
            ),

            // Menu items panel
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 4), // right side shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _desktopMenuTile(icon: Icons.home_outlined, label: 'Home', index: 0, active: _currentIndex == 0, onTap: () => _setIndex(0), expanded: _drawerExpanded, activeColor: activeColor),
                      _desktopMenuTile(icon: Icons.card_giftcard_outlined, label: 'Rewards', index: 1, active: _currentIndex == 1, onTap: () => _setIndex(1), expanded: _drawerExpanded, activeColor: activeColor),
                      _desktopMenuTile(icon: Icons.credit_card_outlined, label: 'Cards', index: 2, active: _currentIndex == 2, onTap: () => _setIndex(2), expanded: _drawerExpanded, activeColor: activeColor),
                      _desktopMenuTile(icon: Icons.person_outline, label: 'Profile', index: 3, active: _currentIndex == 3, onTap: () => _setIndex(3), expanded: _drawerExpanded, activeColor: activeColor),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopMenuTile({required IconData icon, required String label, required int index, required bool active, required VoidCallback onTap, required bool expanded, required Color activeColor}) {
    final inactiveColor = Colors.black;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: expanded ? 12 : 8, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: active ? activeColor.withOpacity(0.18) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: active ? activeColor : inactiveColor),
            ),
            if (expanded) const SizedBox(width: 12),
            if (expanded)
              Expanded(
                child: Text(label, style: TextStyle(color: active ? activeColor : Colors.black, fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
              ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem({required IconData icon, required IconData activeIcon, required String label, required bool isActive, required bool isDark}) {
    return BottomNavigationBarItem(
      icon: _NavIcon(icon: icon, activeIcon: activeIcon, active: isActive, label: label, isDark: isDark),
      label: '',
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool active;
  final String label;
  final bool isDark;

  const _NavIcon({required this.icon, required this.activeIcon, required this.active, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF80BFFF);
    final Color inactiveColor = isDark ? Colors.black : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // 🔹 Center vertically
      children: [
        Container(
          padding: const EdgeInsets.all(8), // 🔹 Compact square padding
          decoration: BoxDecoration(
            color: active ? activeColor.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            active ? activeIcon : icon,
            color: active ? activeColor : inactiveColor,
            size: 22, // 🔹 Slightly smaller icon
          ),
        ),
        if (active)
          Padding(
            padding: const EdgeInsets.only(top: 2), // 🔹 Tighter spacing
            child: Text(
              label,
              style: TextStyle(
                color: activeColor,
                fontSize: 10, // 🔹 Compact font
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
