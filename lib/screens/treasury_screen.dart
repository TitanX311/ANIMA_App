// lib/screens/treasury_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import 'package:intl/intl.dart';

class TreasuryScreen extends StatefulWidget {
  const TreasuryScreen({super.key});

  @override
  State<TreasuryScreen> createState() => _TreasuryScreenState();
}

class _TreasuryScreenState extends State<TreasuryScreen> {
  String _filterCat = 'All';
  int _touchedIndex = -1;

  static const _catColors = {
    ExpenseCategory.fuel: AppColors.orange,
    ExpenseCategory.maintenance: AppColors.cyan,
    ExpenseCategory.equipment: AppColors.purple,
    ExpenseCategory.events: AppColors.gold,
    ExpenseCategory.training: AppColors.green,
    ExpenseCategory.misc: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<DataProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.green : const Color(0xFF059669);

    final filtered = _filterCat == 'All'
        ? data.expenses
        : data.expenses.where((e) => e.category == _filterCat).toList();

    final byCategory = data.expensesByCategory;
    final fmt = NumberFormat('#,##0.00', 'en_IN');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'TREASURY',
          style: TextStyle(color: acc, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: acc),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          if (auth.isTreasurer || auth.isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => _showAddExpense(context, auth, data),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGlow,
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Total expenses card
                FadeInDown(
                  child: GlassCard(
                    borderColor: acc.withOpacity(0.3),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL EXPENDITURE',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${fmt.format(data.totalExpenses)}',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 36,
                                  color: acc,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                '${data.expenses.length} transactions',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.45),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGlow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 28),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Pie chart
                if (byCategory.isNotEmpty) ...[
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: SectionHeader(
                      title: 'BY CATEGORY',
                      subtitle: 'Expense breakdown',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: GlassCard(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: byCategory.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  final idx = e.key;
                                  final entry = e.value;
                                  final color = _catColors[entry.key] ??
                                      Colors.grey;
                                  final isTouched = idx == _touchedIndex;
                                  return PieChartSectionData(
                                    value: entry.value,
                                    title: isTouched
                                        ? '₹${(entry.value / 1000).toStringAsFixed(1)}K'
                                        : '',
                                    radius: isTouched ? 85 : 70,
                                    color: color,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent, width: 0),
                                  );
                                }).toList(),
                                pieTouchData: PieTouchData(
                                  touchCallback: (evt, resp) {
                                    if (resp != null &&
                                        resp.touchedSection != null) {
                                      setState(() {
                                        _touchedIndex = resp.touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    } else {
                                      setState(() => _touchedIndex = -1);
                                    }
                                  },
                                ),
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            children: byCategory.entries.map((e) {
                              final color = _catColors[e.key] ?? Colors.grey;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    e.key,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Filter
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', ...ExpenseCategory.all].map((cat) {
                      final sel = _filterCat == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: sel,
                          onSelected: (_) => setState(() => _filterCat = cat),
                          selectedColor: acc.withOpacity(0.2),
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
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
                            color: sel
                                ? acc.withOpacity(0.5)
                                : acc.withOpacity(0.15),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                SectionHeader(
                  title: 'TRANSACTIONS',
                  subtitle: '${filtered.length} records',
                ),
                const SizedBox(height: 14),

                if (filtered.isEmpty)
                  const EmptyState(
                    title: 'No expenses',
                    subtitle: 'Treasurer can add expense records here',
                    icon: Icons.receipt_long_outlined,
                  )
                else
                  AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 350),
                        childAnimationBuilder: (w) => SlideAnimation(
                          verticalOffset: 15,
                          child: FadeInAnimation(child: w),
                        ),
                        children: filtered
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _ExpenseCard(
                                    expense: e,
                                    catColor:
                                        _catColors[e.category] ?? Colors.grey,
                                    canDelete: auth.isTreasurer || auth.isAdmin,
                                    onDelete: () =>
                                        data.deleteExpense(e.id),
                                  ),
                                ))
                            .toList(),
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

  void _showAddExpense(
      BuildContext ctx, AuthProvider auth, DataProvider data) {
    final titleCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedCat = ExpenseCategory.equipment;
    final isDark = Theme.of(ctx).brightness == Brightness.dark;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg2 : AppColors.lightSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
                top: BorderSide(color: AppColors.gold.withOpacity(0.3))),
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
                const Text(
                  'ADD EXPENSE',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 22,
                    letterSpacing: 2,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amtCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: ExpenseCategory.all
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setS(() => selectedCat = v!),
                  dropdownColor:
                      isDark ? AppColors.darkSurface : Colors.white,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: notesCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                const SizedBox(height: 24),
                GlowButton(
                  label: 'RECORD EXPENSE',
                  gradient: AppColors.goldGlow,
                  width: double.infinity,
                  onTap: () {
                    if (titleCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
                    data.addExpense(Expense(
                      title: titleCtrl.text.trim(),
                      amount: double.tryParse(amtCtrl.text) ?? 0,
                      category: selectedCat,
                      addedById: auth.currentUser!.id,
                      addedByName: auth.currentUser!.name,
                      notes: notesCtrl.text.isNotEmpty
                          ? notesCtrl.text.trim()
                          : null,
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
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Color catColor;
  final bool canDelete;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.catColor,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00', 'en_IN');
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: catColor.withOpacity(0.2),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: catColor.withOpacity(0.3)),
            ),
            child: Icon(_catIcon(expense.category), color: catColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    AccentChip(label: expense.category, color: catColor),
                    const SizedBox(width: 6),
                    Text(
                      '${expense.date.day}/${expense.date.month}/${expense.date.year}',
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
                if (expense.notes != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    expense.notes!,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${fmt.format(expense.amount)}',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 18,
                  color: catColor,
                  letterSpacing: 1,
                ),
              ),
              if (canDelete)
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline,
                      size: 16, color: AppColors.red.withOpacity(0.6)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _catIcon(String cat) => switch (cat) {
        ExpenseCategory.fuel => Icons.local_gas_station,
        ExpenseCategory.maintenance => Icons.build_outlined,
        ExpenseCategory.equipment => Icons.handyman_outlined,
        ExpenseCategory.events => Icons.event_outlined,
        ExpenseCategory.training => Icons.school_outlined,
        _ => Icons.attach_money,
      };
}
