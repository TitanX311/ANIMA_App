// lib/screens/announcements_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class Announcement {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final DateTime createdAt;
  final String type; // 'info' | 'warning' | 'event' | 'urgent'

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.createdAt,
    required this.type,
  });
}

// Seed announcements (replace with API in backend mode)
final _seedAnnouncements = [
  Announcement(
    id: '1',
    title: 'Monthly Flying Meet — Sunday 10 AM',
    body: 'All members are invited to the monthly flying session at Amingaon Field. Bring your aircraft and good vibes. Breakfast will be arranged.',
    authorName: 'Arjun Sharma',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    type: 'event',
  ),
  Announcement(
    id: '2',
    title: 'Field Maintenance This Saturday',
    body: 'Please note the flying field runway will undergo maintenance from 8 AM to 12 PM on Saturday. No flights during this window.',
    authorName: 'Arjun Sharma',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    type: 'warning',
  ),
  Announcement(
    id: '3',
    title: 'Annual Membership Fee Due',
    body: 'Annual membership fee of ₹2,500 is due by end of this month. Please contact the treasurer Rahul Borah to pay. UPI and cash accepted.',
    authorName: 'Rahul Borah',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    type: 'urgent',
  ),
  Announcement(
    id: '4',
    title: 'New R&D Publication Available',
    body: 'Check out the latest publication on Electric Propulsion Analysis by Arjun Sharma in the R&D section. Great insights for our transition to electric fleet.',
    authorName: 'Priya Das',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    type: 'info',
  ),
];

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final List<Announcement> _items = List.from(_seedAnnouncements);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('ANNOUNCEMENTS',
            style: TextStyle(color: acc, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: acc),
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
        actions: [
          if (auth.isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => _showAdd(context, auth, isDark, acc),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: AppColors.cyanGlow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('POST',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 1.5)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? const EmptyState(
              title: 'No announcements',
              subtitle: 'Club announcements will appear here',
              icon: Icons.campaign_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => FadeInUp(
                delay: Duration(milliseconds: 60 * i),
                child: _AnnouncementCard(
                  item: _items[i],
                  canDelete: auth.isAdmin,
                  onDelete: () => setState(() => _items.removeAt(i)),
                ),
              ),
            ),
    );
  }

  void _showAdd(
      BuildContext ctx, AuthProvider auth, bool isDark, Color acc) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    String type = 'info';

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.65,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: acc.withOpacity(0.3))),
          ),
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('POST ANNOUNCEMENT',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 20,
                      letterSpacing: 2,
                      color: acc,
                    )),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.campaign_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.message_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                    DropdownMenuItem(value: 'event', child: Text('Event')),
                    DropdownMenuItem(value: 'warning', child: Text('Warning')),
                    DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                  ],
                  onChanged: (v) => setS(() => type = v!),
                  dropdownColor:
                      isDark ? AppColors.darkSurface : Colors.white,
                ),
                const SizedBox(height: 24),
                GlowButton(
                  label: 'POST',
                  gradient: AppColors.cyanGlow,
                  width: double.infinity,
                  onTap: () {
                    if (titleCtrl.text.isEmpty) return;
                    setState(() {
                      _items.insert(
                        0,
                        Announcement(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleCtrl.text.trim(),
                          body: bodyCtrl.text.trim(),
                          authorName: auth.currentUser!.name,
                          createdAt: DateTime.now(),
                          type: type,
                        ),
                      );
                    });
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement item;
  final bool canDelete;
  final VoidCallback onDelete;

  const _AnnouncementCard({
    required this.item,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (item.type) {
      'event' => (AppColors.cyan, Icons.event_rounded),
      'warning' => (AppColors.gold, Icons.warning_amber_rounded),
      'urgent' => (AppColors.red, Icons.priority_high_rounded),
      _ => (AppColors.purple, Icons.info_outline_rounded),
    };

    return GlassCard(
      borderColor: color.withOpacity(0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.authorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    Text(_ago(item.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        )),
                  ],
                ),
              ),
              AccentChip(
                  label: item.type.toUpperCase(), color: color),
              if (canDelete) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline,
                      size: 16,
                      color: AppColors.red.withOpacity(0.6)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, height: 1.3)),
          const SizedBox(height: 6),
          Text(item.body,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6),
              )),
        ],
      ),
    );
  }

  String _ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
