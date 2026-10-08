import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }

    throw UnsupportedError(AppStrings.androidOnly);
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyDBhfgSe0I3gAtkMPs0rHvLt9DgKWrg95o',
    appId: '1:638495612635:android:cde38dce63945832eeb6fe',
    messagingSenderId: '638495612635',
    projectId: 'countryweather-1e97b',
    storageBucket: 'countryweather-1e97b.firebasestorage.app',
  );
}
