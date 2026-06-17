import 'package:flutter/material.dart';

import 'aurora_background.dart';
import 'aurora_tokens.dart';

/// Shared premium page chrome used across the app:
/// - aurora backdrop (light or dark)
/// - transparent AppBar
/// - consistent padding + safe areas
///
/// Respects [MaterialApp.themeMode] — no longer forces dark theme.
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
    final tokens = AuroraTokens.of(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        foregroundColor: tokens.onGlass,
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
    );
  }
}
