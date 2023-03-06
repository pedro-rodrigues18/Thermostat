// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC2Hixgu97eBnfXOHsGG1xDAEgd8KpG1_c',
    appId: '1:122924989099:web:e4205a5d491aac05ebd5ee',
    messagingSenderId: '122924989099',
    projectId: 'thermostat-29c96',
    authDomain: 'thermostat-29c96.firebaseapp.com',
    databaseURL: 'https://thermostat-29c96-default-rtdb.firebaseio.com',
    storageBucket: 'thermostat-29c96.appspot.com',
    measurementId: 'G-87BH15M2S6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClHIMTKJL5NbXWsfLh__bcCWpn_cWeNNA',
    appId: '1:122924989099:android:c37cf66c1c798d30ebd5ee',
    messagingSenderId: '122924989099',
    projectId: 'thermostat-29c96',
    databaseURL: 'https://thermostat-29c96-default-rtdb.firebaseio.com',
    storageBucket: 'thermostat-29c96.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiDXYlf5ZqDz_jf0kSs2isYd8RAjgn-hI',
    appId: '1:122924989099:ios:83e181b0118a565febd5ee',
    messagingSenderId: '122924989099',
    projectId: 'thermostat-29c96',
    databaseURL: 'https://thermostat-29c96-default-rtdb.firebaseio.com',
    storageBucket: 'thermostat-29c96.appspot.com',
    iosClientId: '122924989099-bkth5fj248q14lgcsr9rk5s2ta1ktmt4.apps.googleusercontent.com',
    iosBundleId: 'com.example.thermostat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCiDXYlf5ZqDz_jf0kSs2isYd8RAjgn-hI',
    appId: '1:122924989099:ios:83e181b0118a565febd5ee',
    messagingSenderId: '122924989099',
    projectId: 'thermostat-29c96',
    databaseURL: 'https://thermostat-29c96-default-rtdb.firebaseio.com',
    storageBucket: 'thermostat-29c96.appspot.com',
    iosClientId: '122924989099-bkth5fj248q14lgcsr9rk5s2ta1ktmt4.apps.googleusercontent.com',
    iosBundleId: 'com.example.thermostat',
  );
}