import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

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
    apiKey: 'AIzaSyCSsGTq5Kl5c96tkb8jPuQUcewlfalw8JA',
    appId: '1:924997518061:android:98319bab927b8b72ba42e4',
    messagingSenderId: '924997518061',
    projectId: 'airwater-jinzy',
    storageBucket: 'airwater-jinzy.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDn4-I5rBjtzMdiWeApEUd1Qj69R1YUlzA',
    appId: '1:187330311049:ios:0185a94301039944eba758',
    messagingSenderId: '924997518061',
    projectId: 'airwater-jinzy',
    storageBucket: 'airwater-jinzy.firebasestorage.app',
    iosBundleId: 'com.salehi-jinzy.alsalehi',
  );
}
