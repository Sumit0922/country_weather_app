import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/config/app_config.dart';
import '../core/constants/app_strings.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../widgets/app_splash.dart';
import '../widgets/app_state_view.dart';
import 'firebase_options.dart';

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await Hive.initFlutter();

    if (!Hive.isBoxOpen(AppConfig.storageBox)) {
      await Hive.openBox<dynamic>(AppConfig.storageBox);
    }
  }

  void _retry() {
    setState(() {
      _initialization = _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppSplash();
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: AppStateView(
                title: AppStrings.errorTitle,
                message: AppStrings.startupError,
                onRetry: _retry,
              ),
            ),
          );
        }

        return const AuthGate();
      },
    );
  }
}
