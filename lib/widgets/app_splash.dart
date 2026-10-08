import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'app_loader.dart';

class AppSplash extends StatelessWidget {
  const AppSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = 24.r.clamp(16.0, 32.0).toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - padding * 2)
                      .clamp(0.0, double.infinity)
                      .toDouble(),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLoader(size: 84),
                      28.verticalSpace,
                      Text(
                        AppStrings.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.spMin,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        AppStrings.preparingExplorer,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.spMin,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
