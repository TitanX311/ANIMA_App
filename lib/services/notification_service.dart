// lib/services/notification_service.dart
// ─────────────────────────────────────────────────────────────────────────────
// NOTIFICATION SERVICE
//
// Currently a local in-app notification queue.
// To upgrade to push notifications, integrate:
//   - firebase_messaging (FCM) for push
//   - flutter_local_notifications for in-device toasts
//
// Add to pubspec.yaml when ready:
//   firebase_messaging: ^14.7.9
//   flutter_local_notifications: ^16.3.0
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

enum NotificationType { info, success, warning, error }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    this.type = NotificationType.info,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  NotificationService() {
    _seedDemoNotifications();
  }

  void _seedDemoNotifications() {
    _notifications.addAll([
      AppNotification(
        id: '1',
        title: 'Welcome to ANIMA!',
        message: 'You have successfully joined the Aero Club.',
        type: NotificationType.success,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: '2',
        title: 'New R&D Publication',
        message: 'Priya Das published a new research paper.',
        type: NotificationType.info,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AppNotification(
        id: '3',
        title: 'Flying Meet Tomorrow',
        message: 'Don\'t forget — Monthly Flying Meet at 10 AM.',
        type: NotificationType.warning,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ]);
  }

  void add({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        type: type,
      ),
    );
    notifyListeners();
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markRead(String id) {
    final n = _notifications.firstWhere((n) => n.id == id,
        orElse: () => _notifications.first);
    n.isRead = true;
    notifyListeners();
  }

  void remove(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clear() {
    _notifications.clear();
    notifyListeners();
  }

  // ── BACKEND INTEGRATION POINT ─────────────────────────────────────────────
  // Call this from main() after initializing Firebase:
  //
  // static Future<void> initFirebase() async {
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onMessage.listen((msg) {
  //     NotificationService().add(
  //       title: msg.notification?.title ?? '',
  //       message: msg.notification?.body ?? '',
  //     );
  //   });
  //   final token = await FirebaseMessaging.instance.getToken();
  //   await ApiService().registerFcmToken(token!);
  // }
  // ─────────────────────────────────────────────────────────────────────────
}

// ── In-App Toast Overlay ────────────────────────────────────────────────────
class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (color, icon) = switch (type) {
      NotificationType.success => (const Color(0xFF10B981), Icons.check_circle),
      NotificationType.warning =>
        (const Color(0xFFF59E0B), Icons.warning_amber),
      NotificationType.error => (const Color(0xFFEF4444), Icons.error_outline),
      _ => (const Color(0xFF00D4FF), Icons.info_outline),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A2744),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }
}
