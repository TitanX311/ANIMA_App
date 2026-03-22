// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..addListener(() {
        setState(() => _progress = _progressCtrl.value);
        if (_progressCtrl.isCompleted) widget.onComplete();
      });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _progressCtrl.forward();
    });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const acc = AppColors.cyan;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Animated star field
          CustomPaint(
            painter: _SplashStarPainter(_progressCtrl.value),
            size: size,
          ),

          // Radial glow
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    acc.withOpacity(0.15 * _progress),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Lottie
                FadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: 220,
                    height: 160,
                    child: Lottie.asset(
                      'assets/lottie/airplane.lottie',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          // Fallback if lottie not yet placed
                          Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_jcikwtux.json',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.airplanemode_active,
                          size: 100,
                          color: acc,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Logo text
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.heroGradient.createShader(bounds),
                    child: const Text(
                      'ANIMA',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 72,
                        letterSpacing: 16,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ),

                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    'THE AERO CLUB',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 8,
                      color: Colors.white.withOpacity(0.45),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Text(
                    'GUWAHATI, ASSAM',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 5,
                      color: acc.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Spacer(),

                // Progress bar
                FadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.white.withOpacity(0.08),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(acc),
                            minHeight: 3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _progressLabel(_progress),
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 3,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _progressLabel(double p) {
    if (p < 0.3) return 'INITIALIZING SYSTEMS...';
    if (p < 0.6) return 'LOADING CLUB DATA...';
    if (p < 0.85) return 'CALIBRATING INSTRUMENTS...';
    return 'CLEARED FOR TAKEOFF';
  }
}

class _SplashStarPainter extends CustomPainter {
  final double t;
  _SplashStarPainter(this.t);

  static final _stars = List.generate(120, (i) {
    final x = (i * 137.508) % 1.0;
    final y = (i * 89.123) % 1.0;
    final s = (i % 3) * 0.6 + 0.4;
    final phase = (i * 0.37) % 1.0;
    return (x, y, s, phase);
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, s, phase) in _stars) {
      final cycle = (t * 2 + phase) % 1.0;
      final opacity = 0.15 +
          0.6 * (cycle < 0.5 ? cycle * 2 : 1.0 - (cycle - 0.5) * 2);
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      canvas.drawCircle(Offset(x * size.width, y * size.height), s, paint);
    }
  }

  @override
  bool shouldRepaint(_SplashStarPainter old) => old.t != t;
}
