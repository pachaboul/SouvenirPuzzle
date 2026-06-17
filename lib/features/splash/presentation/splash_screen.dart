import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../shell/presentation/main_shell.dart';

/// Animated aurora + glassmorphism splash shown briefly at startup.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..forward();
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween<double>(begin: 0.82, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    return Scaffold(
      body: AuroraBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlassCard(
                    borderRadius: 36,
                    padding: const EdgeInsets.all(28),
                    child: Image.asset(
                      'assets/images/logo-souvenirpuzzle.png',
                      height: 132,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.extension_outlined,
                        size: 112,
                        color: AppColors.or,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l.appName,
                    style: TextStyle(
                      color: tokens.onGlass,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.splashTagline,
                    style: TextStyle(color: tokens.onGlassMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.or,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
