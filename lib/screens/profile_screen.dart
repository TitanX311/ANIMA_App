// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/data_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final data = context.watch<DataProvider>();
    final isDark = theme.isDark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);
    final user = auth.currentUser!;

    final userPubs =
        data.publications.where((p) => p.authorId == user.id).length;
    final userProjects =
        data.projects.where((p) => p.addedById == user.id).length;
    final userPhotos =
        data.gallery.where((g) => g.uploadedById == user.id).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.menu_rounded, color: acc),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      acc.withOpacity(0.25),
                      acc.withOpacity(0.05),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      FadeInDown(
                        child: Stack(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                gradient: isDark
                                    ? AppColors.cyanGlow
                                    : AppColors.cyanGlow,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: acc.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  user.name.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkBg
                                        : AppColors.lightBg,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 26,
                            letterSpacing: 2,
                            color:
                                isDark ? Colors.white : const Color(0xFF1E3A5F),
                          ),
                        ),
                      ),
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: RoleBadge(role: user.role.name),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                FadeInUp(
                  child: Row(
                    children: [
                      _StatPill(
                        label: 'Publications',
                        value: userPubs.toString(),
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 10),
                      _StatPill(
                        label: 'Projects',
                        value: userProjects.toString(),
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 10),
                      _StatPill(
                        label: 'Photos',
                        value: userPhotos.toString(),
                        color: AppColors.gold,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // About
                if (user.bio != null) ...[
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: SectionHeader(title: 'ABOUT'),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: GlassCard(
                      child: Text(
                        user.bio!,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Member since
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: acc.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.calendar_today_outlined,
                              color: acc, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Member Since',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.45),
                              ),
                            ),
                            Text(
                              '${user.joinedAt.day} / ${user.joinedAt.month} / ${user.joinedAt.year}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Settings
                FadeInUp(
                  delay: const Duration(milliseconds: 250),
                  child: SectionHeader(title: 'SETTINGS'),
                ),
                const SizedBox(height: 12),

                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: GlassCard(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: isDark ? Icons.dark_mode : Icons.light_mode,
                          label: isDark ? 'Dark Mode' : 'Light Mode',
                          subtitle: 'Toggle app theme',
                          trailing: Switch.adaptive(
                            value: isDark,
                            onChanged: (_) =>
                                context.read<ThemeProvider>().toggleTheme(),
                            activeColor: acc,
                          ),
                          isFirst: true,
                        ),
                        Divider(
                            height: 1, color: acc.withOpacity(0.1), indent: 56),
                        _SettingsTile(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          subtitle: 'Club updates & alerts',
                          trailing: Switch.adaptive(
                            value: true,
                            onChanged: (_) {},
                            activeColor: acc,
                          ),
                        ),
                        Divider(
                            height: 1, color: acc.withOpacity(0.1), indent: 56),
                        _SettingsTile(
                          icon: Icons.language_outlined,
                          label: 'Language',
                          subtitle: 'English (India)',
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3)),
                        ),
                        Divider(
                            height: 1, color: acc.withOpacity(0.1), indent: 56),
                        _SettingsTile(
                          icon: Icons.info_outline,
                          label: 'About ANIMA',
                          subtitle: 'Version 1.0.0',
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3)),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Logout
                FadeInUp(
                  delay: const Duration(milliseconds: 350),
                  child: GlowButton(
                    label: 'LOGOUT',
                    icon: Icons.logout_rounded,
                    gradient: AppColors.orangeGlow,
                    width: double.infinity,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Logout?'),
                          content:
                              const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('LOGOUT',
                                  style: TextStyle(color: AppColors.orange)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        await context.read<AuthProvider>().logout();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    '✦ ANIMA AERO CLUB • AGARTALA ✦',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 3,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.2),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 28,
                color: color,
                letterSpacing: 1,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Widget trailing;
  final bool isFirst;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.trailing,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);

    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 4 : 0,
        bottom: isLast ? 4 : 0,
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: acc.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: acc, size: 18),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
          ),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
