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
    apiKey: 'AIzaSyBzFk3N6m50aK6VAyFmjVLb1Ac8cbUSiRg',
    appId: '1:419738799513:web:b3731116d6711e710ed708',
    messagingSenderId: '419738799513',
    projectId: 'chatappmindriser',
    authDomain: 'chatappmindriser.firebaseapp.com',
    storageBucket: 'chatappmindriser.firebasestorage.app',
    measurementId: 'G-CZ61RYQEPG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACNEENL13GkWHfbLWVSYOX0SNAokOjjqA',
    appId: '1:419738799513:android:9988f41b7ab98c580ed708',
    messagingSenderId: '419738799513',
    projectId: 'chatappmindriser',
    storageBucket: 'chatappmindriser.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDhwQbX1QoHU6bxqbNzRoGQathBopLGPc',
    appId: '1:419738799513:ios:df223fd5da78eacb0ed708',
    messagingSenderId: '419738799513',
    projectId: 'chatappmindriser',
    storageBucket: 'chatappmindriser.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDhwQbX1QoHU6bxqbNzRoGQathBopLGPc',
    appId: '1:419738799513:ios:df223fd5da78eacb0ed708',
    messagingSenderId: '419738799513',
    projectId: 'chatappmindriser',
    storageBucket: 'chatappmindriser.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBzFk3N6m50aK6VAyFmjVLb1Ac8cbUSiRg',
    appId: '1:419738799513:web:a3c85e5bb6690c870ed708',
    messagingSenderId: '419738799513',
    projectId: 'chatappmindriser',
    authDomain: 'chatappmindriser.firebaseapp.com',
    storageBucket: 'chatappmindriser.firebasestorage.app',
    measurementId: 'G-SEVH8R6GLW',
  );
}
