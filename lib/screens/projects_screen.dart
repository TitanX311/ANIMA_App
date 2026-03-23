// lib/screens/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<DataProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('AIRCRAFT PROJECTS',
            style: TextStyle(color: acc, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        // leading: Builder(
        //   builder: (ctx) => IconButton(
        //     icon: Icon(Icons.menu_rounded, color: acc),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showAddProject(context, auth, data, isDark, acc),
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
                    Text('ADD',
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
      body: data.projects.isEmpty
          ? const EmptyState(
              title: 'No projects yet',
              subtitle: 'Add your club aircraft with photos and specs',
              icon: Icons.flight_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
              itemCount: data.projects.length,
              itemBuilder: (ctx, i) {
                final proj = data.projects[i];
                return FadeInUp(
                  delay: Duration(milliseconds: 80 * i),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _ProjectCard(
                      project: proj,
                      acc: acc,
                      isDark: isDark,
                      canDelete: auth.isAdmin ||
                          auth.currentUser?.id == proj.addedById,
                      onDelete: () => data.deleteProject(proj.id),
                      onTap: () => _showProjectDetail(ctx, proj, isDark, acc),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddProject(BuildContext ctx, AuthProvider auth, DataProvider data,
      bool isDark, Color acc) {
    final nameCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imgUrlCtrl = TextEditingController();
    final imgUrls = <String>[];
    final specs = <String, String>{};
    final specKeyCtrl = TextEditingController();
    final specValCtrl = TextEditingController();
    String status = 'Active';

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: acc.withOpacity(0.3))),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: AppColors.cyanGlow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.flight,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text('ADD AIRCRAFT PROJECT',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            letterSpacing: 2,
                            color: acc)),
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
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Aircraft Name',
                          prefixIcon: Icon(Icons.flight),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: typeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Type (e.g., Fixed Wing, Quadcopter)',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        items: ['Active', 'In Build', 'Retired', 'Testing']
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) => setS(() => status = v!),
                        dropdownColor:
                            isDark ? AppColors.darkSurface : Colors.white,
                      ),
                      const SizedBox(height: 16),

                      // Image URLs
                      Text('IMAGE URLS',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: acc,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imgUrlCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                                prefixIcon: Icon(Icons.image_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (imgUrlCtrl.text.isNotEmpty) {
                                setS(() {
                                  imgUrls.add(imgUrlCtrl.text.trim());
                                  imgUrlCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.cyanGlow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      if (imgUrls.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: imgUrls.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imgUrls[i],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 70,
                                      height: 70,
                                      color: acc.withOpacity(0.15),
                                      child:
                                          Icon(Icons.broken_image, color: acc),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setS(() => imgUrls.removeAt(i)),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: AppColors.red,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: const Icon(Icons.close,
                                          size: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Specs
                      Text('TECHNICAL SPECS',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: acc,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: specKeyCtrl,
                              decoration: const InputDecoration(
                                  labelText: 'Spec (e.g., Wingspan)'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: specValCtrl,
                              decoration:
                                  const InputDecoration(labelText: 'Value'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (specKeyCtrl.text.isNotEmpty &&
                                  specValCtrl.text.isNotEmpty) {
                                setS(() {
                                  specs[specKeyCtrl.text.trim()] =
                                      specValCtrl.text.trim();
                                  specKeyCtrl.clear();
                                  specValCtrl.clear();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.cyanGlow,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      if (specs.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ...specs.entries.map((e) => Row(
                              children: [
                                Text('${e.key}: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: acc,
                                        fontWeight: FontWeight.w600)),
                                Text(e.value,
                                    style: const TextStyle(fontSize: 12)),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => setS(() => specs.remove(e.key)),
                                  child: Icon(Icons.close,
                                      size: 14, color: AppColors.red),
                                ),
                              ],
                            )),
                      ],

                      const SizedBox(height: 24),
                      GlowButton(
                        label: 'ADD PROJECT',
                        gradient: AppColors.cyanGlow,
                        width: double.infinity,
                        onTap: () {
                          if (nameCtrl.text.isEmpty) return;
                          data.addProject(ClubProject(
                            planeName: nameCtrl.text.trim(),
                            type: typeCtrl.text.trim().isEmpty
                                ? 'Unknown'
                                : typeCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            imageUrls: imgUrls,
                            addedById: auth.currentUser!.id,
                            addedByName: auth.currentUser!.name,
                            status: status,
                            specs: specs,
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

  void _showProjectDetail(
      BuildContext ctx, ClubProject proj, bool isDark, Color acc) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(ctx).size.height * 0.88,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Image header
            if (proj.imageUrls.isNotEmpty)
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: PageView.builder(
                    itemCount: proj.imageUrls.length,
                    itemBuilder: (_, i) => Image.network(
                      proj.imageUrls[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: acc.withOpacity(0.1),
                        child: Icon(Icons.flight_rounded, size: 80, color: acc),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: acc.withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Icon(Icons.flight_rounded, size: 60, color: acc),
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                                proj.planeName,
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 30,
                                  letterSpacing: 2,
                                  color: acc,
                                  height: 1,
                                ),
                              ),
                              Text(
                                proj.type,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(ctx)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AccentChip(
                          label: proj.status,
                          color: proj.status == 'Active'
                              ? AppColors.green
                              : proj.status == 'Testing'
                                  ? AppColors.gold
                                  : proj.status == 'In Build'
                                      ? AppColors.orange
                                      : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Added by ${proj.addedByName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      proj.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                      ),
                    ),
                    if (proj.specs.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'SPECIFICATIONS',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: acc,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: proj.specs.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((e) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: e.key < proj.specs.length - 1
                                          ? Border(
                                              bottom: BorderSide(
                                                  color: acc.withOpacity(0.1)))
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          e.value.key,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(ctx)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          e.value.value,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: acc,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
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
}

class _ProjectCard extends StatelessWidget {
  final ClubProject project;
  final Color acc;
  final bool isDark;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.project,
    required this.acc,
    required this.isDark,
    required this.canDelete,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(0),
      onTap: onTap,
      borderColor: acc.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              color: acc.withOpacity(0.08),
            ),
            clipBehavior: Clip.antiAlias,
            child: project.imageUrls.isEmpty
                ? Center(
                    child: Icon(Icons.flight_rounded, size: 60, color: acc))
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          project.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.flight_rounded,
                                  size: 60, color: acc)),
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
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (project.imageUrls.length > 1)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+${project.imageUrls.length - 1} more',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
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
                            project.planeName,
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 22,
                              letterSpacing: 1.5,
                              color: acc,
                            ),
                          ),
                          Text(
                            project.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AccentChip(
                      label: project.status,
                      color: project.status == 'Active'
                          ? AppColors.green
                          : AppColors.gold,
                    ),
                    if (canDelete) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(Icons.delete_outline,
                            size: 18, color: AppColors.red.withOpacity(0.6)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.55),
                  ),
                ),
                if (project.specs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: project.specs.entries
                        .take(4)
                        .map((e) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: acc.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${e.key}: ${e.value}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: acc,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.35)),
                    const SizedBox(width: 4),
                    Text(
                      project.addedByName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.35),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: acc.withOpacity(0.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
