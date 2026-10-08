import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'app_loader.dart';

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.title,
    this.message,
    this.onRetry,
    this.loading = false,
    this.icon = Icons.public_off_outlined,
    super.key,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final bool loading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final padding = 20.r.clamp(12.0, 24.0).toDouble();

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          const AppLoader()
        else
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32.r, color: AppColors.primary),
          ),
        18.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.spMin,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        if (message != null) ...[
          8.verticalSpace,
          Text(
            message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.spMin,
              height: 1.5,
              color: AppColors.muted,
            ),
          ),
        ],
        if (onRetry != null) ...[
          16.verticalSpace,
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.retry),
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedHeight) {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: Center(child: content),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - padding * 2)
                  .clamp(0.0, double.infinity)
                  .toDouble(),
            ),
            child: Center(child: content),
          ),
        );
      },
    );
  }
}
