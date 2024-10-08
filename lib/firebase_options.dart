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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtxrh0b0F53TUnDKebBJmXDsll1nBII5g',
    appId: '1:939882538884:android:b63034a8424e9a1e745fd1',
    messagingSenderId: '939882538884',
    projectId: 'attendoapp-8509f',
    storageBucket: 'attendoapp-8509f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8b4JJlv5YsjdCb6bdJEEwOHRR3uR519Y',
    appId: '1:939882538884:ios:5b086654ed3fd519745fd1',
    messagingSenderId: '939882538884',
    projectId: 'attendoapp-8509f',
    storageBucket: 'attendoapp-8509f.appspot.com',
    androidClientId: '939882538884-noeogb2nmtsp9lns6p17tg6thg50gob3.apps.googleusercontent.com',
    iosClientId: '939882538884-poihvkutjs3vlkqe7q3onrkinp01v2h3.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendoApp',
  );
}
