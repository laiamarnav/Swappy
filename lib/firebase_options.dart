import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
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

    // Si quieres puedes poner la config de Android/iOS aquí también
    return const FirebaseOptions(
      apiKey: "AIzaSyDbOuR4UjmEa6huZO9ACsN6tMSSc5LNJGQ",
      projectId: "swivo-d8bfa",
      storageBucket: "swivo-d8bfa.firebasestorage.app",
      messagingSenderId: "474776385675",
      appId: "1:474776385675:web:e3a7693fbe605c102d7c8e",
    );
  }
}
