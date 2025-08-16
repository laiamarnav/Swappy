import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // WEB (ya lo tenías)
      return const FirebaseOptions(
        apiKey: "AIzaSyDbOuR4UjmEa6huZO9ACsN6tMSSc5LNJGQ",
        authDomain: "swivo-d8bfa.firebaseapp.com",
        projectId: "swivo-d8bfa",
        storageBucket: "swivo-d8bfa.firebasestorage.app",
        messagingSenderId: "474776385675",
        appId: "1:474776385675:web:e3a7693fbe605c102d7c8e",
        measurementId: "G-8MYLL87WJQ",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // ANDROID — datos sacados de android/app/google-services.json
        // mobilesdk_app_id -> appId, current_key -> apiKey
        return const FirebaseOptions(
          apiKey: "AIzaSyB76nQerj35VawN1t09-rvugXJORMNkYZk",
          appId: "1:474776385675:android:65e2196a922cab482d7c8e",
          messagingSenderId: "474776385675",
          projectId: "swivo-d8bfa",
          storageBucket: "swivo-d8bfa.firebasestorage.app",
        );

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // iOS — reemplaza los TODO con valores de ios/Runner/GoogleService-Info.plist
        // API_KEY -> apiKey
        // GOOGLE_APP_ID -> appId
        // CLIENT_ID -> iosClientId
        // BUNDLE_ID (com.swivo.app) ya lo fijamos abajo
        return const FirebaseOptions(
          apiKey: "TU_IOS_API_KEY",             // <- API_KEY del plist
          appId: "TU_IOS_APP_ID",               // <- GOOGLE_APP_ID del plist
          messagingSenderId: "474776385675",    // <- GCM_SENDER_ID del plist (coincide)
          projectId: "swivo-d8bfa",
          storageBucket: "swivo-d8bfa.firebasestorage.app",
          iosBundleId: "com.swivo.app",
          iosClientId: "TU_IOS_CLIENT_ID.apps.googleusercontent.com",
        );

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for this platform.',
        );
    }
  }
}
