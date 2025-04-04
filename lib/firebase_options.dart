// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB16Anf5D_HDiJ7aGMQ9YrQZNLj822ZdY8',
    appId: '1:229949339803:web:06f674c9aac41c7f552e3e',
    messagingSenderId: '229949339803',
    projectId: 'collabhub-ashesi',
    authDomain: 'collabhub-ashesi.firebaseapp.com',
    storageBucket: 'collabhub-ashesi.firebasestorage.app',
    measurementId: 'G-3S1Q6N509W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGBpjRRwJ8MAFW6FDoH1RiAjgjecz67-Q',
    appId: '1:229949339803:android:1d1c3afd0881573e552e3e',
    messagingSenderId: '229949339803',
    projectId: 'collabhub-ashesi',
    storageBucket: 'collabhub-ashesi.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANHUCNqtEkG9hlyJNbeO8gsFHBijnHKuY',
    appId: '1:229949339803:ios:e50c2673c0d613c4552e3e',
    messagingSenderId: '229949339803',
    projectId: 'collabhub-ashesi',
    storageBucket: 'collabhub-ashesi.firebasestorage.app',
    iosBundleId: 'com.example.collabhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANHUCNqtEkG9hlyJNbeO8gsFHBijnHKuY',
    appId: '1:229949339803:ios:e50c2673c0d613c4552e3e',
    messagingSenderId: '229949339803',
    projectId: 'collabhub-ashesi',
    storageBucket: 'collabhub-ashesi.firebasestorage.app',
    iosBundleId: 'com.example.collabhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB16Anf5D_HDiJ7aGMQ9YrQZNLj822ZdY8',
    appId: '1:229949339803:web:269fdcb880d76e61552e3e',
    messagingSenderId: '229949339803',
    projectId: 'collabhub-ashesi',
    authDomain: 'collabhub-ashesi.firebaseapp.com',
    storageBucket: 'collabhub-ashesi.firebasestorage.app',
    measurementId: 'G-PYBG51RJ8D',
  );
}
