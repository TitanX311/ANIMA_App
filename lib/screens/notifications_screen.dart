// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ns = context.watch<NotificationService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);
    final items = ns.notifications;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('NOTIFICATIONS',
            style: TextStyle(color: acc, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: acc),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                ns.markAllRead();
                ns.clear();
              },
              child: Text(
                'CLEAR ALL',
                style: TextStyle(
                  fontSize: 11,
                  color: acc.withOpacity(0.6),
                  letterSpacing: 1,
                ),
              ),
            ),
          if (ns.unreadCount > 0)
            TextButton(
              onPressed: ns.markAllRead,
              child: Text(
                'MARK ALL READ',
                style: TextStyle(
                  fontSize: 11,
                  color: acc,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? const EmptyState(
              title: 'No notifications',
              subtitle: 'You\'re all caught up!',
              icon: Icons.notifications_none_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final n = items[i];
                return FadeInLeft(
                  delay: Duration(milliseconds: 50 * i),
                  child: Dismissible(
                    key: Key(n.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => ns.remove(n.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: AppColors.red),
                    ),
                    child: GestureDetector(
                      onTap: () => ns.markRead(n.id),
                      child: _NotifCard(notif: n),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification notif;
  const _NotifCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (notif.type) {
      NotificationType.success => (AppColors.green, Icons.check_circle_outline),
      NotificationType.warning => (AppColors.gold, Icons.warning_amber_outlined),
      NotificationType.error => (AppColors.red, Icons.error_outline),
      _ => (AppColors.cyan, Icons.info_outline),
    };

    return GlassCard(
      borderColor: notif.isRead
          ? color.withOpacity(0.1)
          : color.withOpacity(0.35),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: TextStyle(
                          fontWeight: notif.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (!notif.isRead)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  notif.message,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(notif.isRead ? 0.45 : 0.65),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _ago(notif.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
