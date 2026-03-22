// lib/screens/members_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String _search = '';
  UserRole? _filterRole;

  // Demo member list — replace with API call in production
  final _members = [
    AppUser(
      name: 'Arjun Sharma',
      email: 'admin@anima.aero',
      password: '',
      role: UserRole.admin,
      bio: 'Club Founder & Chief Pilot',
    ),
    AppUser(
      name: 'Priya Das',
      email: 'rd@anima.aero',
      password: '',
      role: UserRole.rdTeam,
      bio: 'Aerodynamics Researcher',
    ),
    AppUser(
      name: 'Rahul Borah',
      email: 'treasurer@anima.aero',
      password: '',
      role: UserRole.treasurer,
      bio: 'Club Treasurer & Finance Manager',
    ),
    AppUser(
      name: 'Sneha Gogoi',
      email: 'member@anima.aero',
      password: '',
      role: UserRole.member,
      bio: 'Aviation Enthusiast',
    ),
    AppUser(
      name: 'Dipankar Nath',
      email: 'dipankar@anima.aero',
      password: '',
      role: UserRole.member,
      bio: 'RC Pilot — Fixed Wing Specialist',
    ),
    AppUser(
      name: 'Ankita Baruah',
      email: 'ankita@anima.aero',
      password: '',
      role: UserRole.rdTeam,
      bio: 'Avionics & Electronics Engineer',
    ),
    AppUser(
      name: 'Ranjit Choudhury',
      email: 'ranjit@anima.aero',
      password: '',
      role: UserRole.member,
      bio: 'FPV Racing Pilot',
    ),
  ];

  List<AppUser> get _filtered {
    var list = _members.where((m) {
      final matchSearch = _search.isEmpty ||
          m.name.toLowerCase().contains(_search.toLowerCase()) ||
          m.email.toLowerCase().contains(_search.toLowerCase());
      final matchRole = _filterRole == null || m.role == _filterRole;
      return matchSearch && matchRole;
    }).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);

    final roleCounts = {
      for (final r in UserRole.values)
        r: _members.where((m) => m.role == r).length,
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('CLUB MEMBERS',
            style: TextStyle(color: acc, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: acc),
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary cards
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: FadeInDown(
              child: Row(
                children: [
                  _MiniStat(
                    label: 'TOTAL',
                    value: _members.length.toString(),
                    color: acc,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'R&D',
                    value: roleCounts[UserRole.rdTeam].toString(),
                    color: AppColors.purple,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'ADMIN',
                    value: roleCounts[UserRole.admin].toString(),
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: 8),
                  _MiniStat(
                    label: 'MEMBERS',
                    value: roleCounts[UserRole.member].toString(),
                    color: AppColors.green,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeInUp(
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  prefixIcon: Icon(Icons.search, color: acc),
                  suffixIcon: _search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _search = ''),
                        )
                      : null,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Role filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _filterRole == null,
                    onSelected: (_) => setState(() => _filterRole = null),
                    selectedColor: acc.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: _filterRole == null ? acc : null,
                      fontWeight: _filterRole == null
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                        color: _filterRole == null
                            ? acc.withOpacity(0.5)
                            : acc.withOpacity(0.15)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ...UserRole.values.map((r) {
                  final selected = _filterRole == r;
                  final color = _roleColor(r);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_roleLabel(r)),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _filterRole = selected ? null : r),
                      selectedColor: color.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: selected ? color : null,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                          color: selected
                              ? color.withOpacity(0.5)
                              : color.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Members list
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(
                    title: 'No members found',
                    subtitle: 'Try a different search term',
                    icon: Icons.group_off_outlined,
                  )
                : AnimationLimiter(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) =>
                          AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 380),
                        child: SlideAnimation(
                          verticalOffset: 15,
                          child: FadeInAnimation(
                            child: _MemberCard(
                              member: _filtered[i],
                              isCurrentUser:
                                  auth.currentUser?.email ==
                                      _filtered[i].email,
                              isAdmin: auth.isAdmin,
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

  Color _roleColor(UserRole r) => switch (r) {
        UserRole.admin => AppColors.gold,
        UserRole.rdTeam => AppColors.purple,
        UserRole.treasurer => AppColors.green,
        UserRole.member => AppColors.cyan,
      };

  String _roleLabel(UserRole r) => switch (r) {
        UserRole.admin => 'Admin',
        UserRole.rdTeam => 'R&D',
        UserRole.treasurer => 'Treasurer',
        UserRole.member => 'Member',
      };
}

class _MemberCard extends StatelessWidget {
  final AppUser member;
  final bool isCurrentUser;
  final bool isAdmin;

  const _MemberCard({
    required this.member,
    required this.isCurrentUser,
    required this.isAdmin,
  });

  Color _roleColor() => switch (member.role) {
        UserRole.admin => AppColors.gold,
        UserRole.rdTeam => AppColors.purple,
        UserRole.treasurer => AppColors.green,
        UserRole.member => AppColors.cyan,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _roleColor();

    return GlassCard(
      borderColor: isCurrentUser ? color.withOpacity(0.4) : color.withOpacity(0.15),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                member.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'YOU',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: color,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.45),
                  ),
                ),
                if (member.bio != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    member.bio!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),
          RoleBadge(role: member.role.name),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 22,
                color: color,
                height: 1,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.45),
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
