// lib/screens/gallery_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _filterTag = 'All';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<DataProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.gold : const Color(0xFFD97706);

    final allTags = <String>{'All'};
    for (final g in data.gallery) allTags.addAll(g.tags);
    final tagList = allTags.toList();

    final filtered = _filterTag == 'All'
        ? data.gallery
        : data.gallery.where((g) => g.tags.contains(_filterTag)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('GALLERY', style: TextStyle(color: acc, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        // leading: Builder(
        //   builder: (ctx) => IconButton(
        //     icon: Icon(Icons.menu_rounded, color: acc),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
        //   ),
        // ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUpload(context, auth, data, isDark, acc),
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text(
          'UPLOAD',
          style: TextStyle(fontFamily: 'BebasNeue', letterSpacing: 2),
        ),
        backgroundColor: acc,
        foregroundColor: isDark ? Colors.black : Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          // Tags filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: tagList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final tag = tagList[i];
                  final sel = _filterTag == tag;
                  return FilterChip(
                    label: Text(tag),
                    selected: sel,
                    onSelected: (_) => setState(() => _filterTag = tag),
                    selectedColor: acc.withOpacity(0.2),
                    backgroundColor:
                        isDark ? AppColors.darkCard : AppColors.lightCard,
                    labelStyle: TextStyle(
                      color: sel
                          ? acc
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: sel ? acc.withOpacity(0.5) : acc.withOpacity(0.15),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  );
                },
              ),
            ),
          ),

          if (filtered.isEmpty)
            const SliverFillRemaining(
              child: EmptyState(
                title: 'No photos yet',
                subtitle: 'Upload photos to share with the club',
                icon: Icons.photo_library_outlined,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => AnimationConfiguration.staggeredGrid(
                    position: i,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: _GalleryTile(
                          photo: filtered[i],
                          acc: acc,
                          canDelete: auth.isAdmin ||
                              auth.currentUser?.id == filtered[i].uploadedById,
                          onDelete: () =>
                              data.deleteGalleryPhoto(filtered[i].id),
                          onTap: () =>
                              _showPhotoDetail(ctx, filtered[i], isDark, acc),
                        ),
                      ),
                    ),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showUpload(BuildContext ctx, AuthProvider auth, DataProvider data,
      bool isDark, Color acc) {
    final titleCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final tags = <String>[];

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: acc.withOpacity(0.3))),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGlow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.photo_camera,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text('UPLOAD PHOTO',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          letterSpacing: 2,
                          color: acc,
                        )),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Photo Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: urlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    prefixIcon: Icon(Icons.link),
                    hintText: 'https://...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 12),
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
                            tags.add(tagCtrl.text.trim());
                            tagCtrl.clear();
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGlow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: tags
                        .map((t) => Chip(
                              label: Text(t),
                              onDeleted: () => setS(() => tags.remove(t)),
                              backgroundColor: acc.withOpacity(0.12),
                              labelStyle: TextStyle(color: acc, fontSize: 12),
                              side: BorderSide(color: acc.withOpacity(0.3)),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                GlowButton(
                  label: 'UPLOAD PHOTO',
                  gradient: AppColors.goldGlow,
                  width: double.infinity,
                  onTap: () {
                    if (titleCtrl.text.isEmpty || urlCtrl.text.isEmpty) return;
                    data.addGalleryPhoto(GalleryPhoto(
                      imageUrl: urlCtrl.text.trim(),
                      title: titleCtrl.text.trim(),
                      description:
                          descCtrl.text.isEmpty ? null : descCtrl.text.trim(),
                      uploadedById: auth.currentUser!.id,
                      uploadedByName: auth.currentUser!.name,
                      tags: tags,
                    ));
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

  void _showPhotoDetail(
      BuildContext ctx, GalleryPhoto photo, bool isDark, Color acc) {
    showDialog(
      context: ctx,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                photo.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: acc.withOpacity(0.1),
                  child: Icon(Icons.broken_image, color: acc, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.title,
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 20,
                      color: acc,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (photo.description != null) ...[
                    const SizedBox(height: 4),
                    Text(photo.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(ctx)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        )),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'By ${photo.uploadedByName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(ctx)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 4,
                        children: photo.tags
                            .map((t) => AccentChip(label: t, color: acc))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CLOSE',
                  style: TextStyle(color: Colors.white70, letterSpacing: 2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryTile extends StatefulWidget {
  final GalleryPhoto photo;
  final Color acc;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _GalleryTile({
    required this.photo,
    required this.acc,
    required this.canDelete,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.canDelete
          ? () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Photo?'),
                  content: Text('Remove "${widget.photo.title}" from gallery?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onDelete();
                      },
                      child: Text('DELETE',
                          style: TextStyle(color: AppColors.red)),
                    ),
                  ],
                ),
              )
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: widget.acc.withOpacity(_hovered ? 0.5 : 0.15), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.photo.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: widget.acc.withOpacity(0.05),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: widget.acc,
                          ),
                        ),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  color: widget.acc.withOpacity(0.08),
                  child: Icon(Icons.broken_image_outlined,
                      color: widget.acc, size: 40),
                ),
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
                      Colors.black.withOpacity(0.65),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.photo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  if (widget.photo.tags.isNotEmpty)
                    Text(
                      widget.photo.tags.take(2).join(' • '),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
