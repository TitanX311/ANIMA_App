// lib/screens/main_shell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'home_screen.dart';
import 'rd_screen.dart';
import 'treasury_screen.dart';
import 'projects_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _idx = 0;

  final _screens = const [
    HomeScreen(),
    RDScreen(),
    TreasuryScreen(),
    ProjectsScreen(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  final _navItems = const [
    (Icons.home_outlined,              Icons.home_rounded,                   'Home'),
    (Icons.science_outlined,           Icons.science_rounded,                'R&D'),
    (Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Treasury'),
    (Icons.flight_outlined,            Icons.flight_rounded,                 'Aircraft'),
    (Icons.photo_library_outlined,     Icons.photo_library_rounded,          'Gallery'),
    (Icons.person_outline,             Icons.person_rounded,                 'Profile'),
  ];

  void _onNav(int i) {
    if (_idx == i) return;
    setState(() => _idx = i);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);

    return Scaffold(
      drawer: _buildDrawer(context, auth, isDark, acc),
      body: AnimatedBackground(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.025, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: KeyedSubtree(key: ValueKey(_idx), child: _screens[_idx]),
        ),
      ),
      bottomNavigationBar: _buildNavBar(isDark, acc),
    );
  }

  Widget _buildNavBar(bool isDark, Color acc) {
    final bg = isDark
        ? const Color(0xFF0D1628).withOpacity(0.97)
        : Colors.white.withOpacity(0.97);
    final border = isDark
        ? AppColors.cyan.withOpacity(0.12)
        : const Color(0xFF0066CC).withOpacity(0.12);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF0066CC))
                .withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (i) => _NavItem(
                icon: _navItems[i].$1,
                activeIcon: _navItems[i].$2,
                label: _navItems[i].$3,
                isActive: _idx == i,
                accent: acc,
                onTap: () => _onNav(i),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(
      BuildContext context, AuthProvider auth, bool isDark, Color acc) {
    final theme = context.read<ThemeProvider>();
    final user = auth.currentUser!;
    final bg = isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF0F7FF);

    return Drawer(
      backgroundColor: bg,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [acc.withOpacity(0.2), acc.withOpacity(0.04)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                    bottom: BorderSide(color: acc.withOpacity(0.2), width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.cyanGlow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
                  Text(user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      )),
                  const SizedBox(height: 8),
                  RoleBadge(role: user.role.name),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Nav items
            ..._navItems.asMap().entries.map((e) => ListTile(
                  leading: Icon(
                    _idx == e.key ? e.value.$2 : e.value.$1,
                    color: _idx == e.key
                        ? acc
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                  ),
                  title: Text(
                    e.value.$3,
                    style: TextStyle(
                      color: _idx == e.key
                          ? acc
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: _idx == e.key
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                  selected: _idx == e.key,
                  selectedTileColor: acc.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    Navigator.pop(context);
                    _onNav(e.key);
                  },
                )),

            const Spacer(),

            // Theme toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                        color: acc, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isDark ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: isDark,
                      onChanged: (_) => theme.toggleTheme(),
                      activeColor: acc,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlowButton(
                label: 'LOGOUT',
                icon: Icons.logout_rounded,
                gradient: AppColors.orangeGlow,
                width: double.infinity,
                onTap: () async {
                  Navigator.pop(context);
                  await auth.logout();
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'ANIMA AERO CLUB v1.0',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color accent;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? accent.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive
                    ? accent
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.35),
                size: 21,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? accent
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.35),
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
