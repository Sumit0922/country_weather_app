import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    required this.child,
    this.padding,
    this.color = AppColors.surface,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(20.r.clamp(14.0, 24.0).toDouble()),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r.clamp(14.0, 24.0).toDouble()),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
