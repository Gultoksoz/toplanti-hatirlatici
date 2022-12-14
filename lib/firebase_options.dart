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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCiqDgViWqIYIda_nazWnRyk6wbOQd8a2w',
    appId: '1:323218960593:web:67494165c5abf72d5415f0',
    messagingSenderId: '323218960593',
    projectId: 'meeting-reminder-890bc',
    authDomain: 'meeting-reminder-890bc.firebaseapp.com',
    storageBucket: 'meeting-reminder-890bc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdGqniSizMuwHBoGqamHiaTY_73GQFWO8',
    appId: '1:323218960593:android:9b3e6e63050e40135415f0',
    messagingSenderId: '323218960593',
    projectId: 'meeting-reminder-890bc',
    storageBucket: 'meeting-reminder-890bc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnB-Ed_haSmTN_5WR4SAG--XeHPlfn-6k',
    appId: '1:323218960593:ios:ce463461a892a3f65415f0',
    messagingSenderId: '323218960593',
    projectId: 'meeting-reminder-890bc',
    storageBucket: 'meeting-reminder-890bc.appspot.com',
    iosClientId: '323218960593-al97addko8og1m8n8c2d02pb1pqmaph3.apps.googleusercontent.com',
    iosBundleId: 'seri.meetingreminderProject',
  );
}
