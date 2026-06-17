import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/widgets/aurora_tokens.dart';

/// Smooth animated area chart with touch tooltips.
class StatsAreaChart extends StatefulWidget {
  const StatsAreaChart({
    super.key,
    required this.values,
    required this.labels,
    required this.lineColor,
    required this.fillColor,
    this.maxValue,
    this.valueLabelBuilder,
    this.height = 170,
    this.selectedIndex,
    this.onSelectIndex,
  });

  final List<double> values;
  final List<String> labels;
  final Color lineColor;
  final Color fillColor;
  final double? maxValue;
  final String Function(double value)? valueLabelBuilder;
  final double height;
  final int? selectedIndex;
  final ValueChanged<int?>? onSelectIndex;

  @override
  State<StatsAreaChart> createState() => _StatsAreaChartState();
}

class _StatsAreaChartState extends State<StatsAreaChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant StatsAreaChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final max = widget.maxValue ??
        widget.values
            .fold<double>(0, (m, v) => v > m ? v : m)
            .clamp(1, double.infinity);

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTapDown: widget.onSelectIndex == null
                    ? null
                    : (d) => _handleTap(d.localPosition, constraints.maxWidth, max),
                onHorizontalDragUpdate: widget.onSelectIndex == null
                    ? null
                    : (d) => _handleTap(d.localPosition, constraints.maxWidth, max),
                child: CustomPaint(
                  size: Size(constraints.maxWidth, widget.height),
                  painter: _AreaChartPainter(
                    values: widget.values,
                    labels: widget.labels,
                    maxValue: max,
                    lineColor: widget.lineColor,
                    fillColor: widget.fillColor,
                    progress: Curves.easeOutCubic.transform(_controller.value),
                    selectedIndex: widget.selectedIndex,
                    gridColor: tokens.chartGrid,
                    labelColor: tokens.chartLabel,
                  ),
                  child: widget.selectedIndex != null &&
                          widget.selectedIndex! < widget.values.length
                      ? _TooltipOverlay(
                          index: widget.selectedIndex!,
                          value: widget.values[widget.selectedIndex!],
                          label: widget.labels[widget.selectedIndex!],
                          lineColor: widget.lineColor,
                          valueText: widget.valueLabelBuilder
                                  ?.call(widget.values[widget.selectedIndex!]) ??
                              widget.values[widget.selectedIndex!]
                                  .toStringAsFixed(0),
                          chartWidth: constraints.maxWidth,
                          chartHeight: widget.height,
                          pointCount: widget.values.length,
                          labelColor: tokens.onGlassSubtle,
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleTap(Offset pos, double width, double max) {
    final n = widget.values.length;
    if (n == 0) return;
    const leftPad = 4.0;
    final chartW = width - leftPad;
    final stepX = n > 1 ? chartW / (n - 1) : 0.0;
    var best = 0;
    var bestDist = double.infinity;
    for (var i = 0; i < n; i++) {
      final x = leftPad + stepX * i;
      final dist = (pos.dx - x).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
    }
    widget.onSelectIndex?.call(best);
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.index,
    required this.value,
    required this.label,
    required this.lineColor,
    required this.valueText,
    required this.chartWidth,
    required this.chartHeight,
    required this.pointCount,
    required this.labelColor,
  });

  final int index;
  final double value;
  final String label;
  final Color lineColor;
  final String valueText;
  final double chartWidth;
  final double chartHeight;
  final int pointCount;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    const leftPad = 4.0;
    const bottomPad = 22.0;
    const topPad = 8.0;
    final chartW = chartWidth - leftPad;
    final chartH = chartHeight - bottomPad - topPad;
    final stepX = pointCount > 1 ? chartW / (pointCount - 1) : 0.0;
    final x = leftPad + stepX * index;

    return Stack(
      children: [
        Positioned(
          left: (x - 1).clamp(0, chartWidth - 2),
          top: topPad,
          child: Container(
            width: 2,
            height: chartH,
            color: lineColor.withValues(alpha: 0.35),
          ),
        ),
        Positioned(
          left: (x - 52).clamp(8, chartWidth - 112),
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bleuNuit.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lineColor.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: lineColor.withValues(alpha: 0.25),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(color: labelColor, fontSize: 10),
                ),
                Text(
                  valueText,
                  style: TextStyle(
                    color: lineColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  _AreaChartPainter({
    required this.values,
    required this.labels,
    required this.maxValue,
    required this.lineColor,
    required this.fillColor,
    required this.progress,
    required this.gridColor,
    required this.labelColor,
    this.selectedIndex,
  });

  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color lineColor;
  final Color fillColor;
  final double progress;
  final Color gridColor;
  final Color labelColor;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const leftPad = 4.0;
    const bottomPad = 22.0;
    const topPad = 8.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = topPad + chartH * i / 3;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), gridPaint);
    }

    final visibleCount = math.max(2, (values.length * progress).ceil());
    final n = visibleCount.clamp(1, values.length);
    final stepX = values.length > 1 ? chartW / (values.length - 1) : 0.0;

    Offset pointAt(int i) {
      final x = leftPad + stepX * i;
      final y = topPad + chartH * (1 - values[i] / maxValue);
      return Offset(x, y);
    }

    final path = Path();
    final fillPath = Path();
    for (var i = 0; i < n; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
        fillPath.moveTo(p.dx, topPad + chartH);
        fillPath.lineTo(p.dx, p.dy);
      } else {
        final prev = pointAt(i - 1);
        final cx = (prev.dx + p.dx) / 2;
        path.cubicTo(cx, prev.dy, cx, p.dy, p.dx, p.dy);
        fillPath.cubicTo(cx, prev.dy, cx, p.dy, p.dx, p.dy);
      }
    }
    if (n > 0) {
      fillPath.lineTo(pointAt(n - 1).dx, topPad + chartH);
      fillPath.close();
    }

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, topPad),
          Offset(0, topPad + chartH),
          [fillColor.withValues(alpha: 0.5), fillColor.withValues(alpha: 0.02)],
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < n; i++) {
      if (values[i] <= 0 && selectedIndex != i) continue;
      final p = pointAt(i);
      final isSelected = selectedIndex == i;
      canvas.drawCircle(
        p,
        isSelected ? 5 : 3,
        Paint()..color = lineColor,
      );
      if (isSelected) {
        canvas.drawCircle(
          p,
          8,
          Paint()..color = lineColor.withValues(alpha: 0.3),
        );
      }
    }

    final labelStyle = TextStyle(
      color: labelColor,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    final labelIndices = _labelIndices(values.length);
    for (final i in labelIndices) {
      if (i >= labels.length) continue;
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = pointAt(i).dx - tp.width / 2;
      tp.paint(
        canvas,
        Offset(x.clamp(0, size.width - tp.width), size.height - 16),
      );
    }
  }

  List<int> _labelIndices(int n) {
    if (n <= 1) return [0];
    if (n <= 7) return List.generate(n, (i) => i);
    return [0, n ~/ 3, (2 * n) ~/ 3, n - 1];
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter old) =>
      old.values != values ||
      old.maxValue != maxValue ||
      old.progress != progress ||
      old.selectedIndex != selectedIndex ||
      old.gridColor != gridColor ||
      old.labelColor != labelColor;
}

/// Donut chart for difficulty distribution.
class StatsDonutChart extends StatelessWidget {
  const StatsDonutChart({
    super.key,
    required this.segments,
    this.size = 140,
    this.animate = true,
  });

  final List<StatsDonutSegment> segments;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final total = segments.fold<int>(0, (s, e) => s + e.value);
    if (total == 0) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            '—',
            style: TextStyle(color: tokens.onGlassSubtle),
          ),
        ),
      );
    }

    final child = CustomPaint(
      size: Size(size, size),
      painter: _DonutPainter(
        segments: segments,
        total: total,
        trackColor: tokens.surfaceElevated,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$total',
              style: TextStyle(
                color: tokens.onGlass,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Σ',
              style: TextStyle(
                color: tokens.chartLabel,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );

    if (!animate) return SizedBox(width: size, height: size, child: child);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DonutPainter(
              segments: segments,
              total: total,
              progress: t,
              trackColor: tokens.surfaceElevated,
            ),
            child: Center(
              child: Opacity(
                opacity: t,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$total',
                      style: TextStyle(
                        color: tokens.onGlass,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Σ',
                      style: TextStyle(
                        color: tokens.chartLabel,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StatsDonutSegment {
  const StatsDonutSegment({required this.value, required this.color});

  final int value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.segments,
    required this.total,
    required this.trackColor,
    this.progress = 1,
  });

  final List<StatsDonutSegment> segments;
  final int total;
  final Color trackColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 18.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    var start = -math.pi / 2;
    final sweepTotal = 2 * math.pi * progress;
    var drawn = 0.0;

    for (final seg in segments) {
      if (seg.value <= 0) continue;
      final sweep = (seg.value / total) * 2 * math.pi * progress;
      if (drawn + sweep > sweepTotal) break;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
      drawn += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.segments != segments ||
      old.progress != progress ||
      old.trackColor != trackColor;
}

/// Horizontal bar chart for difficulty breakdown.
class StatsHorizontalBars extends StatelessWidget {
  const StatsHorizontalBars({
    super.key,
    required this.items,
    this.height = 10,
    this.animate = true,
  });

  final List<StatsBarItem> items;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final max = items.fold<int>(0, (m, i) => i.value > m ? i.value : m);
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _BarRow(
            item: items[i],
            maxValue: math.max(max, 1),
            barHeight: height,
            animate: animate,
          ),
        ],
      ],
    );
  }
}

class StatsBarItem {
  const StatsBarItem({
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });

  final String label;
  final int value;
  final Color color;
  final String? subtitle;
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.item,
    required this.maxValue,
    required this.barHeight,
    required this.animate,
  });

  final StatsBarItem item;
  final int maxValue;
  final double barHeight;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final fraction = item.value / maxValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: item.color.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: tokens.onGlass,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${item.value}',
              style: TextStyle(
                color: item.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              item.subtitle!,
              style: TextStyle(color: tokens.onGlassSubtle, fontSize: 11),
            ),
          ),
        ],
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(barHeight / 2),
          child: SizedBox(
            height: barHeight,
            child: Stack(
              children: [
                Container(color: tokens.surfaceElevated),
                if (animate)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, _) => FractionallySizedBox(
                      widthFactor: t,
                      child: _barFill(item.color),
                    ),
                  )
                else
                  FractionallySizedBox(
                    widthFactor: fraction.clamp(0.0, 1.0),
                    child: _barFill(item.color),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _barFill(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.45),
          ],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 8),
        ],
      ),
    );
  }
}

/// Ring progress indicator for KPI highlights.
class StatsRingGauge extends StatelessWidget {
  const StatsRingGauge({
    super.key,
    required this.progress,
    required this.color,
    required this.child,
    this.size = 52,
    this.strokeWidth = 5,
    this.animate = true,
  });

  final double progress;
  final Color color;
  final Widget child;
  final double size;
  final double strokeWidth;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final p = progress.clamp(0.0, 1.0);
    if (!animate) return _buildRing(p, tokens);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: p),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => _buildRing(t, tokens),
    );
  }

  Widget _buildRing(double p, AuroraTokens tokens) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: p,
              color: color,
              strokeWidth: strokeWidth,
              trackColor: tokens.surfaceElevated,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final double strokeWidth;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final bg = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);

    final fg = Paint()
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0.3), color, AppColors.orClair],
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.trackColor != trackColor;
}

/// Animated count-up text for hero metrics.
class StatsAnimatedCount extends StatelessWidget {
  const StatsAnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  final int value;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(
        '$v',
        style: style,
      ),
    );
  }
}
