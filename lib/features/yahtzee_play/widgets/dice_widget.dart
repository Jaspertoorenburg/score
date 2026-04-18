import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Eén dobbelsteen in de UI.
///
/// Toont de waarde als een visueel stippenpatroon (1–6).
/// Als [kept] true is, krijgt de dobbelsteen een rode rand (bewaard voor volgende worp).
/// Als [value] 0 is, wordt de dobbelsteen grijs getoond (nog niet gegooid).
class DiceWidget extends StatelessWidget {
  final int value; // 0 = leeg, 1–6 = waarde
  final bool kept;
  final bool enabled;
  final VoidCallback? onTap;

  const DiceWidget({
    super.key,
    required this.value,
    this.kept = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == 0;
    final bgColor = isEmpty
        ? AppColors.dividerLight
        : kept
            ? AppColors.primary
            : Colors.white;
    final dotColor = isEmpty
        ? AppColors.textMuted.withOpacity(0.3)
        : kept
            ? Colors.white
            : AppColors.textPrimary;

    return GestureDetector(
      onTap: enabled && !isEmpty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kept ? AppColors.primary : AppColors.dividerLight,
            width: kept ? 2.5 : 1,
          ),
          boxShadow: kept
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: isEmpty
            ? const SizedBox.shrink()
            : CustomPaint(painter: _DotsPainter(value: value, dotColor: dotColor)),
      ),
    );
  }
}

/// Tekent de stippen op de dobbelsteen via Canvas.
class _DotsPainter extends CustomPainter {
  final int value;
  final Color dotColor;

  const _DotsPainter({required this.value, required this.dotColor});

  // Stipposities als fracties van de breedte/hoogte (0.0 – 1.0).
  static const _patterns = <int, List<Offset>>{
    1: [Offset(0.5, 0.5)],
    2: [Offset(0.28, 0.28), Offset(0.72, 0.72)],
    3: [Offset(0.28, 0.28), Offset(0.5, 0.5), Offset(0.72, 0.72)],
    4: [
      Offset(0.28, 0.28), Offset(0.72, 0.28),
      Offset(0.28, 0.72), Offset(0.72, 0.72),
    ],
    5: [
      Offset(0.28, 0.28), Offset(0.72, 0.28),
      Offset(0.5, 0.5),
      Offset(0.28, 0.72), Offset(0.72, 0.72),
    ],
    6: [
      Offset(0.28, 0.22), Offset(0.72, 0.22),
      Offset(0.28, 0.5),  Offset(0.72, 0.5),
      Offset(0.28, 0.78), Offset(0.72, 0.78),
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    final radius = size.width * 0.09;
    final offsets = _patterns[value] ?? [];

    for (final o in offsets) {
      canvas.drawCircle(
        Offset(o.dx * size.width, o.dy * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) =>
      old.value != value || old.dotColor != dotColor;
}
