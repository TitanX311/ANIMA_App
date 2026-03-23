// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() => _isLogin = _tabCtrl.index == 0);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();

    bool ok;
    if (_isLogin) {
      ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    } else {
      ok = await auth.signup(
          _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text.trim());
    }

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.error ?? 'Something went wrong'),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final acc = isDark ? AppColors.cyan : const Color(0xFF0066CC);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Logo
                FadeInDown(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: acc.withAlpha((0.6 * 255).toInt()),
                                blurRadius: 32,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.jpeg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced gap
                      Text(
                        'ANIMA',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 52,
                          letterSpacing: 12,
                          color: acc,
                          shadows: isDark
                              ? [
                                  Shadow(
                                      color: acc.withAlpha((0.5 * 255).toInt()),
                                      blurRadius: 20)
                                ]
                              : [],
                        ),
                      ),
                      Text(
                        'THE AERO CLUB',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 6,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha((0.5 * 255).toInt()),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Demo hint
                FadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.gold.withAlpha((0.3 * 255).toInt()),
                          width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 14, color: AppColors.gold),
                            const SizedBox(width: 6),
                            Text(
                              'DEMO CREDENTIALS',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...[
                          ('Admin', 'admin@anima.aero', 'admin123'),
                          ('R&D', 'rd@anima.aero', 'rd123'),
                          ('Treasurer', 'treasurer@anima.aero', 'treas123'),
                          ('Member', 'member@anima.aero', 'member123'),
                        ].map((d) => Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: GestureDetector(
                                onTap: () {
                                  _emailCtrl.text = d.$2;
                                  _passCtrl.text = d.$3;
                                  setState(() => _isLogin = true);
                                  _tabCtrl.animateTo(0);
                                },
                                child: Text(
                                  '${d.$1}: ${d.$2}  •  ${d.$3}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha((0.6 * 255).toInt()),
                                    fontFamily: 'SpaceMono',
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tab bar
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        gradient:
                            isDark ? AppColors.cyanGlow : AppColors.cyanGlow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha((0.4 * 255).toInt()),
                      labelStyle: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'LOGIN'),
                        Tab(text: 'SIGN UP'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Form
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: TextFormField(
                                    controller: _nameCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Full Name',
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                    validator: (v) =>
                                        (!_isLogin && (v?.isEmpty ?? true))
                                            ? 'Enter your name'
                                            : null,
                                  ),
                                ),
                        ),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Enter password' : null,
                        ),
                        const SizedBox(height: 28),
                        GlowButton(
                          label: _isLogin ? 'Fly In →' : 'Join the Club →',
                          onTap: _submit,
                          isLoading: auth.isLoading,
                          width: double.infinity,
                          gradient:
                              isDark ? AppColors.cyanGlow : AppColors.cyanGlow,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Footer
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    '✦ ANIMA AERO CLUB • AGARTALA ✦',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 3,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha((0.25 * 255).toInt()),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
