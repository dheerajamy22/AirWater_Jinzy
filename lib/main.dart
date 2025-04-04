import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demo/on_boarding/onboard.dart';
//import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_dashboard_2024/updated_dashboard_2024.dart';

void main() async{
/*  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);*/
  // await Future.delayed(Duration(seconds: 2));
    WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()),
      
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
