import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaperTypePreviewLine extends StatelessWidget {
  const PaperTypePreviewLine({
    super.key,
    required this.color,
    required this.height,
    this.widthFactor = 1,
    this.opacity = 1,
  });

  final Color color;
  final double height;
  final double widthFactor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerRight,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
