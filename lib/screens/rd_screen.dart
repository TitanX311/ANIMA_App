// lib/screens/rd_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class RDScreen extends StatefulWidget {
  const RDScreen({super.key});

  @override
  State<RDScreen> createState() => _RDScreenState();
}

class _RDScreenState extends State<RDScreen> {
  String _filter = 'All';
  final _tags = [
    'All',
    'UAV',
    'Aerodynamics',
    'CFD',
    'Electric',
    'Propulsion',
    'Wing Design'
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<DataProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.purple : const Color(0xFF6D28D9);

    final filtered = _filter == 'All'
        ? data.publications
        : data.publications.where((p) => p.tags.contains(_filter)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'RESEARCH & DEVELOPMENT',
          style: TextStyle(color: acc, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        // leading: Builder(
        //   builder: (ctx) => IconButton(
        //     icon: Icon(Icons.menu_rounded, color: acc),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
        //   ),
        // ),
        actions: [
          if (auth.isRDTeam || auth.isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => _showPublishDialog(context, auth, data),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleGlow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('PUBLISH',
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
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final tag = _tags[i];
                final selected = _filter == tag;
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = tag),
                  selectedColor: acc.withOpacity(0.2),
                  backgroundColor:
                      isDark ? AppColors.darkCard : AppColors.lightCard,
                  labelStyle: TextStyle(
                    color: selected
                        ? acc
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color:
                        selected ? acc.withOpacity(0.5) : acc.withOpacity(0.15),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    title: 'No publications',
                    subtitle: auth.isRDTeam || auth.isAdmin
                        ? 'Tap + PUBLISH to share your research'
                        : 'R&D team members can post research here',
                    icon: Icons.science_outlined,
                  )
                : AnimationLimiter(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (ctx, i) =>
                          AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 20,
                          child: FadeInAnimation(
                            child: _PublicationCard(
                              pub: filtered[i],
                              canDelete: auth.isAdmin ||
                                  auth.currentUser?.id == filtered[i].authorId,
                              onDelete: () =>
                                  data.deletePublication(filtered[i].id),
                              onTap: () => _showDetail(
                                  context, filtered[i], isDark, acc),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showPublishDialog(
      BuildContext ctx, AuthProvider auth, DataProvider data) {
    final titleCtrl = TextEditingController();
    final abstractCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final selectedTags = <String>[];
    final isDark = Theme.of(ctx).brightness == Brightness.dark;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
                top: BorderSide(color: AppColors.purple.withOpacity(0.3))),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGlow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.science,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'PUBLISH RESEARCH',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,
                        letterSpacing: 2,
                        color: AppColors.purple,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Research Title',
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: abstractCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Abstract',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.short_text),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: contentCtrl,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Full Content',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.article_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: tagCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Add Tag',
                                prefixIcon: Icon(Icons.label_outline),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (tagCtrl.text.isNotEmpty) {
                                setS(() {
                                  selectedTags.add(tagCtrl.text.trim());
                                  tagCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.purpleGlow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (selectedTags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          children: selectedTags
                              .map((t) => Chip(
                                    label: Text(t),
                                    onDeleted: () =>
                                        setS(() => selectedTags.remove(t)),
                                    backgroundColor:
                                        AppColors.purple.withOpacity(0.12),
                                    labelStyle: const TextStyle(
                                        color: AppColors.purple, fontSize: 12),
                                    side: BorderSide(
                                        color:
                                            AppColors.purple.withOpacity(0.3)),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 24),
                      GlowButton(
                        label: 'PUBLISH',
                        gradient: AppColors.purpleGlow,
                        width: double.infinity,
                        onTap: () {
                          if (titleCtrl.text.isEmpty) return;
                          data.addPublication(RDPublication(
                            title: titleCtrl.text.trim(),
                            abstract: abstractCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            authorId: auth.currentUser!.id,
                            authorName: auth.currentUser!.name,
                            tags: selectedTags,
                          ));
                          Navigator.pop(ctx);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(
      BuildContext ctx, RDPublication pub, bool isDark, Color acc) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border:
              Border(top: BorderSide(color: AppColors.purple.withOpacity(0.3))),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      children: pub.tags
                          .map((t) =>
                              AccentChip(label: t, color: AppColors.purple))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pub.title,
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 26,
                        letterSpacing: 1.5,
                        color: AppColors.purple,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By ${pub.authorName}  •  ${_fmt(pub.publishedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.45),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.purple.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ABSTRACT',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2,
                              color: AppColors.purple,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pub.abstract,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Theme.of(ctx)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'FULL PAPER',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: AppColors.purple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pub.content,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.8,
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _PublicationCard extends StatelessWidget {
  final RDPublication pub;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _PublicationCard({
    required this.pub,
    required this.canDelete,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      onTap: onTap,
      borderColor: AppColors.purple.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGlow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.science, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pub.authorName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '${pub.publishedAt.day}/${pub.publishedAt.month}/${pub.publishedAt.year}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              if (canDelete)
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: AppColors.red.withOpacity(0.7)),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios,
                  size: 12,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pub.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            pub.abstract,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: pub.tags
                .take(4)
                .map((t) => AccentChip(label: t, color: AppColors.purple))
                .toList(),
          ),
        ],
      ),
    );
  }
}
