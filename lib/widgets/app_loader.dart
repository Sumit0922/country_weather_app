import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    this.size = 64,
    this.color = AppColors.primary,
    this.trackColor = AppColors.primarySoft,
    super.key,
  });

  final double size;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    final diameter = size.r.clamp(size * 0.8, size * 1.25).toDouble();

    return Semantics(
      label: AppStrings.loading,
      child: SizedBox.square(
        dimension: diameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CircularProgressIndicator(
                value: reducedMotion ? 0.75 : null,
                strokeWidth: diameter < 40 ? 2 : 3,
                color: color,
                backgroundColor: trackColor,
              ),
            ),
            Icon(Icons.public, size: diameter * 0.52, color: color),
          ],
        ),
      ),
    );
  }
}
