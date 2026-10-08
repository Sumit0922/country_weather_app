import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';

abstract final class AppFeedback {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void success(String message) {
    _show(message, isError: false);
  }

  static void error(String message) {
    _show(message, isError: true);
  }

  static void _show(String message, {required bool isError}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = messengerKey.currentState;

      if (messenger == null) return;

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: isError ? AppColors.error : AppColors.text,
            margin: EdgeInsets.all(16.r.clamp(12.0, 24.0).toDouble()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            duration: const Duration(seconds: 3),
            content: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: AppColors.surface,
                  size: 22.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 13.spMin,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    });
  }
}
