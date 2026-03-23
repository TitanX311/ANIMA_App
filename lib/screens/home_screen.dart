// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/weather_widget.dart';
import 'announcements_screen.dart';
import 'members_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<DataProvider>();
    final ns = context.watch<NotificationService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);
    final user = auth.currentUser!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            // leading: Builder(
            //   builder: (ctx) => IconButton(
            //     icon: Icon(Icons.menu_rounded, color: acc),
            //     onPressed: () => Scaffold.of(ctx).openDrawer(),
            //   ),
            // ),
            title: Text(
              'ANIMA AERO CLUB',
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 20,
                letterSpacing: 3,
                color: acc,
              ),
            ),
            actions: [
              // Notification bell with badge
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: acc),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()),
                    ),
                  ),
                  if (ns.unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isDark ? AppColors.darkBg : AppColors.lightBg,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            ns.unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Avatar
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanGlow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hero banner
                FadeInDown(
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderColor: acc.withAlpha((0.3 * 255).toInt()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha((0.5 * 255).toInt()),
                                    ),
                                  ),
                                  Text(
                                    user.name.split(' ').first,
                                    style: TextStyle(
                                      fontFamily: 'BebasNeue',
                                      fontSize: 34,
                                      letterSpacing: 2,
                                      color: acc,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RoleBadge(role: user.role.name),
                                  if (user.bio != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      user.bio!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha((0.45 * 255).toInt()),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            // Lottie airplane
                            SizedBox(
                              width: 120,
                              height: 110,
                              child: Lottie.asset(
                                'assets/lottie/Plane.json',
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Lottie.network(
                                  'https://assets10.lottiefiles.com/packages/lf20_jcikwtux.json',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.airplanemode_active,
                                    size: 60,
                                    color: acc,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Weather widget
                        const WeatherWidget(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Quick action row
                FadeInUp(
                  delay: const Duration(milliseconds: 80),
                  child: Row(
                    children: [
                      _QuickAction(
                        icon: Icons.campaign_outlined,
                        label: 'Announcements',
                        color: AppColors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AnnouncementsScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _QuickAction(
                        icon: Icons.group_outlined,
                        label: 'Members',
                        color: AppColors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MembersScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _QuickAction(
                        icon: Icons.notifications_outlined,
                        label: 'Alerts',
                        color: AppColors.gold,
                        badge: ns.unreadCount,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationsScreen()),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats grid
                FadeInUp(
                  delay: const Duration(milliseconds: 120),
                  child: SectionHeader(
                    title: 'CLUB STATS',
                    subtitle: 'Live dashboard',
                  ),
                ),
                const SizedBox(height: 14),
                AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 400),
                      childAnimationBuilder: (w) => SlideAnimation(
                        verticalOffset: 20,
                        child: FadeInAnimation(child: w),
                      ),
                      children: [
                        StatCard(
                          label: 'PUBLICATIONS',
                          value: data.publications.length.toString(),
                          icon: Icons.science_rounded,
                          gradient: AppColors.purpleGlow,
                          index: 0,
                        ),
                        StatCard(
                          label: 'EXPENSES',
                          value:
                              '₹${(data.totalExpenses / 1000).toStringAsFixed(1)}K',
                          icon: Icons.account_balance_wallet_rounded,
                          gradient: AppColors.orangeGlow,
                          index: 1,
                        ),
                        StatCard(
                          label: 'AIRCRAFT',
                          value: data.projects.length.toString(),
                          icon: Icons.flight_rounded,
                          gradient: AppColors.cyanGlow,
                          index: 2,
                        ),
                        StatCard(
                          label: 'GALLERY',
                          value: data.gallery.length.toString(),
                          icon: Icons.photo_library_rounded,
                          gradient: AppColors.goldGlow,
                          index: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Recent R&D
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: SectionHeader(
                    title: 'RECENT R&D',
                    subtitle: 'Latest publications',
                  ),
                ),
                const SizedBox(height: 14),

                if (data.publications.isEmpty)
                  const EmptyState(
                    title: 'No publications yet',
                    subtitle: 'R&D team members can publish research here',
                    icon: Icons.science_outlined,
                  )
                else
                  ...data.publications.take(2).map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FadeInLeft(
                            child: GlassCard(
                              borderColor: AppColors.purple
                                  .withAlpha((0.2 * 255).toInt()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          gradient: AppColors.purpleGlow,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.science,
                                            color: Colors.white, size: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          p.authorName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Text(
                                        _formatDate(p.publishedAt),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withAlpha((0.35 * 255).toInt()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    p.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.abstract,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha((0.55 * 255).toInt()),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: p.tags
                                        .take(3)
                                        .map((t) => AccentChip(
                                            label: t, color: AppColors.purple))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 28),

                // Aircraft carousel
                FadeInUp(
                  delay: const Duration(milliseconds: 280),
                  child: SectionHeader(
                    title: 'OUR AIRCRAFT',
                    subtitle: 'Club project gallery',
                  ),
                ),
                const SizedBox(height: 14),

                if (data.projects.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.projects.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (ctx, i) {
                        final proj = data.projects[i];
                        return FadeInRight(
                          delay: Duration(milliseconds: 80 * i),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: acc.withAlpha((0.2 * 255).toInt()),
                                  width: 1),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: proj.imageUrls.isNotEmpty
                                      ? Image.network(
                                          proj.imageUrls.first,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: acc
                                                .withAlpha((0.1 * 255).toInt()),
                                            child: Icon(Icons.flight_rounded,
                                                size: 48, color: acc),
                                          ),
                                        )
                                      : Container(
                                          color: acc
                                              .withAlpha((0.1 * 255).toInt()),
                                          child: Icon(Icons.flight_rounded,
                                              size: 48, color: acc),
                                        ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                              .withAlpha((0.7 * 255).toInt()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        proj.planeName,
                                        style: const TextStyle(
                                          fontFamily: 'BebasNeue',
                                          fontSize: 18,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      Text(
                                        proj.type,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white
                                              .withAlpha((0.7 * 255).toInt()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const EmptyState(
                    title: 'No aircraft yet',
                    subtitle: 'Add your club planes in the Aircraft tab',
                    icon: Icons.flight_outlined,
                  ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '${diff}d ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int badge;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.badge = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha((0.25 * 255).toInt())),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color, size: 22),
                  if (badge > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            badge.toString(),
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
