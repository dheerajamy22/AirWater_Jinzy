import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demo/firebase_options.dart';
import 'package:demo/new_leave_managerdashboard/manager_leaveworkflow.dart';
import 'package:demo/on_boarding/onboard.dart';
import 'package:demo/workflow_request_panel/work_flow_request.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_dashboard_2024/updated_dashboard_2024.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  print('message: ${message}');

/*  String? screen = message.data['screen'];
  String? emp_code = message.data['emp_code'];
  String? emp_name = message.data['emp_name'];
  String? emp_photo = message.data['emp_photo'];
  if (screen != null && emp_code!=null && emp_name !=null&&emp_photo!=null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_screen', screen);
    await prefs.setString('from_firebase_emp_name', emp_name);
    await prefs.setString('from_firebase_emp_photo', emp_photo);
    await prefs.setString('emp_code', emp_code);
    await prefs.setBool('fromNotification', true);

  }*/

  // Store the notification screen name and flag in SharedPreferences for later use
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    try {
      // Request permission to show notifications
      await _firebaseMessaging.requestPermission();

      // Get the FCM token
      final fCMToken = await _firebaseMessaging.getToken();
      print("Token: $fCMToken");

      // Set the notification options for foreground messages
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
        badge: true,
      );

      // Set the background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Listen for when the app is opened via a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _navigateToScreen(message);
      });

      // Handle the case when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _navigateToScreen(message);
      });
    } catch (e) {
      // Handle exceptions
      await _firebaseMessaging.requestPermission();
      String? fcmToken = await _firebaseMessaging.getToken();
      print('catch token $fcmToken');
    }
  }

  // Function to navigate to the appropriate screen based on the notification data
  Future<void> _navigateToScreen(RemoteMessage message) async {
    String screenToNavigate = message.data['screen'] ?? '';
    String emp_code = message.data['emp_code'] ?? '';
    String emp_name = message.data['emp_name'] ?? '';
    String emp_photo = message.data['emp_photo'] ?? '';
    if (screenToNavigate.isNotEmpty) {
      // Store the data in SharedPreferences for later use in case the app is backgrounded
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('notification_screen', screenToNavigate);
      prefs.setString('emp_code', emp_code);
      await prefs.setString('from_firebase_emp_name', emp_name);
      await prefs.setString('from_firebase_emp_photo', emp_photo);

      await prefs.setBool('fromNotification', false);

      // After the app is resumed, check SharedPreferences to decide where to navigate
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure that the navigator key is not null before pushing to the next screen
        if (navigatorKey.currentState != null) {
          if (screenToNavigate == "leave") {
            Navigator.push(
                navigatorKey.currentState!.context,
                MaterialPageRoute(
                    builder: (context) => manager_workflow(
                          emp_code: emp_code,
                        )));
            prefs.setString('notification_screen', "");
            prefs.setBool('fromNotification', false);
          } else if (screenToNavigate == "attendance") {
            Navigator.push(
                navigatorKey.currentState!.context,
                MaterialPageRoute(
                    builder: (context) => My_Work_flow_Request(
                          emp_code: emp_code,
                        )));
            prefs.setString('notification_screen', "");
            prefs.setBool('fromNotification', false);
          }
        } else {
          print("Navigator key is null. Cannot navigate to screen.");
        }
      });
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async{
 WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        // name: "maana_beta_testing",
        options: DefaultFirebaseOptions.currentPlatform);
    try {
      await FirebaseApi().initNotification();
    } catch (notificationError) {}
  } catch (firebaseError) {}

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFromNotification = prefs.getBool('fromNotification') ?? false;

  if (!isFromNotification) {
    // If app is opened manually, reset notification data
    await prefs.setString('notification_screen', "");
    await prefs.setBool('fromNotification', false);
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application


  @override
  Widget build(BuildContext context) {
    //FlutterNativeSplash.remove();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Container(
              child: SvgPicture.asset("assets/svgs/new_splash_icon.svg"
                ,height: 192,width: 192,),
            ),
            nextScreen: onboarding(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: MyColor.mainAppColor),
    );
  }
  void check_login_status(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? login_value = preferences.getString("login_check");

    if (login_value == "true"){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new upcoming_dash()));

    }else{
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new onboarding()));

    }


  }

}
