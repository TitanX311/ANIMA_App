// lib/widgets/weather_widget.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';

/// Simulated weather data.
/// Replace [_fetchWeather] with a real API call (e.g. OpenWeatherMap) when
/// you connect the backend.
class WeatherCondition {
  final String condition;
  final double tempC;
  final int windKts;
  final String windDir;
  final int visibilityKm;
  final bool flyable;

  const WeatherCondition({
    required this.condition,
    required this.tempC,
    required this.windKts,
    required this.windDir,
    required this.visibilityKm,
    required this.flyable,
  });
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherCondition? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // ── BACKEND INTEGRATION POINT ──────────────────────────────────────────
    // Replace this with a real API call, e.g.:
    //   final res = await ApiService().getWeather('AGARTALA');
    //   setState(() { _weather = res; _loading = false; });
    // ───────────────────────────────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _weather = const WeatherCondition(
        condition: 'CLEAR',
        tempC: 28,
        windKts: 8,
        windDir: 'NE',
        visibilityKm: 12,
        flyable: true,
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Loading weather...',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.gold.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_weather == null) return const SizedBox.shrink();

    final w = _weather!;
    final statusColor = w.flyable ? AppColors.green : AppColors.red;
    final statusLabel = w.flyable ? 'FLYABLE' : 'NO-FLY';

    return FadeIn(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.gold.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            // Weather icon
            Text(
              _conditionEmoji(w.condition),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 10),

            // Main info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AGARTALA  ${w.tempC.toInt()}°C  •  ${w.condition}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                  Text(
                    'Wind ${w.windKts} kts ${w.windDir}  •  Vis ${w.visibilityKm}+ km',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.gold.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),

            // Flyable badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: statusColor.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                      letterSpacing: 1,
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

  String _conditionEmoji(String c) => switch (c.toUpperCase()) {
        'CLEAR' => '☀️',
        'CLOUDY' => '☁️',
        'PARTLY CLOUDY' => '⛅',
        'RAIN' || 'RAINY' => '🌧️',
        'STORM' || 'THUNDERSTORM' => '⛈️',
        'FOG' || 'FOGGY' => '🌫️',
        'HAZE' => '🌁',
        _ => '🌤️',
      };
}
