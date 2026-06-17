import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'aurora_background.dart';

/// Shared premium page chrome used across the app:
/// - aurora backdrop
/// - transparent AppBar (optionally)
/// - consistent padding + safe areas
///
/// This wrapper also applies the app dark theme locally so text/buttons stay
/// readable over the dark aurora background even when the global theme is light.
class AuroraPage extends StatelessWidget {
  const AuroraPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.padding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    this.extendBodyBehindAppBar = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark(),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        floatingActionButton: floatingActionButton,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.cremeDoux,
          elevation: 0,
          leading: leading,
          actions: actions,
        ),
        body: AuroraBackground(
          child: SafeArea(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

