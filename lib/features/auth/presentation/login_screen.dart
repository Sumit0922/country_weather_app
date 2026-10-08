import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_loader.dart';
import '../../../widgets/content_card.dart';
import 'auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authActionProvider).isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();

    await ref
        .read(authActionProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final action = ref.watch(authActionProvider);
    final padding = 24.r.clamp(16.0, 32.0).toDouble();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - padding * 2)
                      .clamp(0.0, double.infinity)
                      .toDouble(),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConfig.formWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Icon(
                            Icons.public,
                            size: 40.r,
                            color: AppColors.primary,
                          ),
                        ),
                        24.verticalSpace,
                        Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontSize: 30.spMin,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          AppStrings.appDescription,
                          style: TextStyle(
                            fontSize: 14.spMin,
                            color: AppColors.muted,
                          ),
                        ),
                        28.verticalSpace,
                        ContentCard(
                          child: Form(
                            key: _formKey,
                            child: AutofillGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.welcome,
                                    style: TextStyle(
                                      fontSize: 23.spMin,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    AppStrings.loginSubtitle,
                                    style: TextStyle(
                                      fontSize: 13.spMin,
                                      height: 1.5,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  24.verticalSpace,
                                  TextFormField(
                                    controller: _email,
                                    enabled: !action.isLoading,
                                    validator: Validators.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [
                                      AutofillHints.username,
                                    ],
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      labelText: AppStrings.email,
                                      hintText: AppStrings.emailHint,
                                      prefixIcon: Icon(Icons.mail_outline),
                                    ),
                                  ),
                                  16.verticalSpace,
                                  TextFormField(
                                    controller: _password,
                                    enabled: !action.isLoading,
                                    validator: Validators.password,
                                    obscureText: _obscurePassword,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    onFieldSubmitted: (_) => _submit(),
                                    decoration: InputDecoration(
                                      labelText: AppStrings.password,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? AppStrings.showPassword
                                            : AppStrings.hidePassword,
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: AppConfig.animationDuration,
                                    child: action.hasError
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 14.r),
                                            child: Text(
                                              ErrorMessage.from(action.error!),
                                              style: TextStyle(
                                                color: AppColors.error,
                                                fontSize: 13.spMin,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  24.verticalSpace,
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: action.isLoading
                                          ? null
                                          : _submit,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.r,
                                        ),
                                        child: action.isLoading
                                            ? const AppLoader(
                                                size: 26,
                                                color: AppColors.surface,
                                                trackColor: AppColors.primary,
                                              )
                                            : const Text(AppStrings.signIn),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
