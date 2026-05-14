import 'package:flutter/material.dart';

class AppDirectionality extends StatelessWidget {
  const AppDirectionality({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
