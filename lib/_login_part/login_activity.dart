import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:demo/web_view/web_view_activity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_color/color_constants.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Login_Activity extends StatefulWidget {
  @override
  _Login_ActivityState createState() => _Login_ActivityState();
}

class _Login_ActivityState extends State<Login_Activity> {
  var user_email = TextEditingController(text: "");
  var user_pass = TextEditingController(text: "");
  bool _passwordVisible = false;
  var user_captcha_controller = TextEditingController(text: "");
  bool isEmptyUEmail = false, isEmptyPassword = false;
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  void ipGet() async {
    try {
      // Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.text);

      // Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      dynamic name = await ipAddress.getIpAddress();

      print('ip address ' + data.toString());
      print('ip address name ' + name.toString());

      final info = NetworkInfo();

      final wifiName = await info.getWifiName(); // "FooNetwork"
      final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
      final wifiIP = await info.getWifiIP(); // 192.168.1.43
      final wifiIPv6 =
          await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
      final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
      final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
      final wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1

      print('w n ${wifiName}');
      print('w bsd ${wifiBSSID}');
      print('w wifiIP ${wifiIP}');
      print('w wifiIPV6 ${wifiIPv6}');
      print('w wifiSubmask ${wifiSubmask}');
      print('w wifiBroadcast ${wifiBroadcast}');
      print('w wifiGateway ${wifiGateway}');
    } on IpAddressException catch (exception) {
      // Handle the exception.
      print(exception.message);
    }
  }

  Future<void> _showMyDialog(
      String msg, Color color_dynamic, String success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          if (success == 'success') ...[
            Icon(
              Icons.check,
              color: MyColor.white_color,
            ),
          ] else ...[
            Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
          ],
          SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            msg,
            style: TextStyle(color: MyColor.white_color),
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: color_dynamic,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
    ));
  }

//late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;

/*  checkInternet() async {
    List<ConnectivityResult> results =
        (await Connectivity().checkConnectivity());
    if (results.isNotEmpty && results.first != ConnectivityResult.none) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
        showDailogBox();
      });
    }
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

  showDailogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Network Error"),
            content: Text("Please Check your Network Connection"),
            actions: [
              CupertinoButton(
                  child: Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    checkInternet();
                  })
            ],
          );
        });
  }*/

  @override
  void initState() {
    // startStreaming();
    _initNetworkInfo();
    super.initState();
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore : deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';
    });

    print('${_connectionStatus}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text('Do you want to Exit'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text('No')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Exit')),
                ],
              );
            });
        if (value != null) {
          exit(0);
          // return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    child: Stack(
                      children: <Widget>[
                        CustomPaint(
                          painter: ShapesPainter(),
                          child: Container(height: 300),
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Image.asset(
                                "assets/images/power_jinzy.png",
                                width: 200,
                                height: 120,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //height: MediaQuery.of(context).size.height,
                            child: Column(
                              //  crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 24, left: 16, right: 16, bottom: 24),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: user_email,
                                          decoration: InputDecoration(
                                              isCollapsed: true,
                                              filled: true,
                                              labelText: 'Email id',
                                              fillColor: Colors.white,
                                              labelStyle: new TextStyle(
                                                  color: MyColor.mainAppColor),
                                              hintText: "Email id",
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color:
                                                        MyColor.mainAppColor),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: MyColor
                                                          .mainAppColor)),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: 'pop')),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: user_pass,
                                          keyboardType: TextInputType.text,
                                          obscureText: !_passwordVisible,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                              isCollapsed: true,
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: 'Password',
                                              labelStyle: new TextStyle(
                                                  color: MyColor.mainAppColor),
                                              hintText: "Password",
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color:
                                                        MyColor.mainAppColor),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  _passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  borderSide: BorderSide(
                                                      color: MyColor
                                                          .mainAppColor)),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: 'pop')),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: MyColor.mainAppColor,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'pop',
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (validate()) {
                                            if (EmailValidator.validate(
                                                user_email.text)) {
                                              CallSingInApi();
                                            } else {
                                              _showMyDialog(
                                                  "Please enter valid email",
                                                  Color(0xFF861F41),
                                                  'error');
                                            }
                                          } else {}
                                        },
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 12),
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Don\'t have a account? ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'pop_m'),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                /* launchUrl(
                                                  Uri.parse('https://jinzy.co/sign-up'),mode: LaunchMode.externalApplication
                                              );*/
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            new WebViewExample()));
                                              },
                                              child: Text(
                                                'Sign up',
                                                style: TextStyle(
                                                    color: MyColor.mainAppColor,
                                                    fontSize: 14,
                                                    fontFamily: 'pop_m'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  bool validate() {
    if (user_email.text == '') {
      _showMyDialog('Please enter valid email id', Color(0xFF861F41), 'error');
      return false;
    } else if (user_pass.text == '') {
      _showMyDialog('Please enter your password', Color(0xFF861F41), 'error');
      return false;
    }
    /*else if(user_captcha_controller.text==''){
      _showMyDialog('Please enter captcha');
      return false;
    }*/

    return true;
  }

  Future<void> CallSingInApi() async {
    final ProgressDialog pr = ProgressDialog(
      context,
      isDismissible: true,
    );
    await pr.show();
    String? fcm_token;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      fcm_token = await messaging.getToken();
    } catch (notificationError) {}
    print('TTTOKENNNN $fcm_token');
//
    var response = await http.post(
        Uri.parse(
          '${baseurl.url}login',
        ),
        body: {
          'email': EncryptData.encryptAES(user_email.text),
          'password': EncryptData.encryptAES(user_pass.text),
          'fcm_token': '$fcm_token',
          // 'email': user_email.text,
          // 'password': user_pass.text,
        });
    print(response.statusCode);
    print(response.body);
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("200 code");
      if (jsonObject['status'] == "1") {
        pr.hide();
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();

        await preferences.setString("user_name", jsonObject['emp_fullName']);
        await preferences.setString("user_id", jsonObject['id']);
        await preferences.setString(
            "login_email", EncryptData.encryptAES(user_email.text));
        await preferences.setString(
            "login_password", EncryptData.encryptAES(user_pass.text));
        await preferences.setString("e_id", jsonObject['tbl_entity_id']);
        // await preferences.setString("emp_wcal_id", jsonObject['emp_wcal_id']);
        // await preferences.setString("emp_id", jsonObject['emp_id']);
        //await preferences.setString("e_code", jsonObject['emp_code']);
        await preferences.setString("user_email", jsonObject['emp_email']);
        await preferences.setString(
            "emp_joining_date", jsonObject['emp_joining_date']);
        await preferences.setString("emp_pos_name", jsonObject['emp_pos_name']);
        await preferences.setString(
            "emp_notice_period", jsonObject['emp_notice_period'].toString());
        await preferences.setString("emp_probation_period",
            jsonObject['emp_probation_period'].toString());
        await preferences.setString("user_emp_code", jsonObject['emp_code']);
        await preferences.setString("user_profile", jsonObject['emp_photo']);
        await preferences.setString(
            "emp_contact", jsonObject['emp_contact_no']);
        await preferences.setString(
            "line_manager_name", jsonObject['line_manager_name']);
        await preferences.setString(
            "line_manager_poscode", jsonObject['line_manager_poscode']);
        await preferences.setString("reported_by", jsonObject['reported_by']);
        await preferences.setString("leave_group", jsonObject['leave_group']);
        await preferences.setString(
            "empstatus", jsonObject['employement_status']);
        await preferences.setString("user_access_token", jsonObject['token']);
        await preferences.setString("login_check", "true");

        //  SharedPreferences preferences = await SharedPreferences.getInstance();
        String? login_value = preferences.getString("login_check");
        print('login se $login_value');

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => upcoming_dash()));
      } else if (jsonObject['status'] == "0") {
        await pr.hide();
        _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
      }
    } else if (response.statusCode == 422) {
      Navigator.of(context).pop();
      _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
    } else if (response.statusCode == 500) {
      Navigator.of(context).pop();
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    } else {
      print("else part");
    pr.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }
}

const double _kCurveHeight = 48;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = MyColor.mainAppColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LoginModelResponse {
  String email;
  String password;

  LoginModelResponse({required this.email, required this.password});

  factory LoginModelResponse.fromJson(Map<String, dynamic> json) {
    return LoginModelResponse(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
