import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/document_request/document_main_tab.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/holidays/holidays_model.dart';
import 'package:demo/my_drawer_header.dart';
import 'package:demo/new_leave_page_by_Vikas_Sir/new_leave_mainlistpage.dart';
import 'package:demo/team_request_access_panel/team_request_dashboard/team_request_dashboard.dart';
import 'package:demo/ticket_request_panel/ticket_request_main_tab.dart';
import 'package:demo/training_request/training_request_main_tab.dart';
import 'package:demo/travel_expenses/travel_expeses_tab_main.dart';
import 'package:demo/trip_request_panel/trip_request_main_tab.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../anniversary/anniversary_model.dart';
import '../app_color/color_constants.dart';
import '../new_dashboard_2024/updated_dashboard_2024.dart';
import '../team_request_access_panel/team_request_model.dart';
import '../upcoming_birthday/birthday_model.dart';

class MyDashboard extends StatefulWidget {
  MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  var currentPage = DrawerSections.dashboard;
  String? leave_request_pending = '';
  String? document_request_pending = '';
  String? travel_expenses_request_pending = '';
  String? training_request_pending = '';
  String? trip_request_pending = '';
  String? ticket_request_pending = '';
  String? _currentAddress;
  String? _country_name;
  String tdata = '';
  String current_ip = '';
  String lat = '';
  String long = '';
  String? in_out_time;
  String? in_out_status;
  String? _timeString;

  Position? _currentPosition;
  String? reported_by, leave_group;
  int checkIn=0;
  int checkOut=0;

  TextEditingController _reson_controler = TextEditingController();

  List<BirthdayModel> birth_data = [];
  List<UpComing_AnniversaryModel> anniver_data = [];
  List<Workflow> work_flow_data = [];
  List<HolidaysModel> holidaysData = [];

  // that's function use to Birthday's Api
  Future<List<BirthdayModel>> getAllBirthData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? e_id = p.getString('e_id');
    String? token = p.getString('user_access_token');
    setState(() {
      leave_group = p.getString('leave_group');
      reported_by = p.getString('reported_by');
    });

    var response = await http.get(
        Uri.parse(
            '${baseurl.url}birthday_View?entity_id=${EncryptData.decryptAES(e_id.toString())}'),
        headers: {'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['BirthdayList'];

        print('bdayc  ' + response.body);
        for (var data in jsonArray) {
          BirthdayModel birthdayModel = BirthdayModel(
              name: data['name'],
              emp_birthdate: data['emp_birthdate'],
              emp_photo: data['emp_photo'],
              cake_icon: data['cake_icon'],
              emp_gender: data['emp_gender']);

          birth_data.add(birthdayModel);
        }
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

    return birth_data;
  }

  // that's function use to Anniversary Api
  Future<List<UpComing_AnniversaryModel>> getAllAniversary() async {
    SharedPreferences p = await SharedPreferences.getInstance();
     String? token = p.getString('user_access_token');
    String? e_id = p.getString('e_id');
    // String? token = p.getString('user_access_token');
    var response = await http.get(
      Uri.parse('${baseurl.url}anniversary_View?entity_id=${EncryptData.decryptAES(e_id.toString())}'),
      headers: {'Authorization': 'Bearer $token'}
    );

    print('annivesary  ' + response.body);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['AnniversaryList'];
        UpComing_AnniversaryModel aniData;
        for (var data in jsonArray) {
          aniData = UpComing_AnniversaryModel(
              emp_name: data['name'],
              emp_anidate: data['emp_joining_date'],
              profile_photo: data['emp_photo'],
              cake_icon: data['cake_icon'],
              emp_pos_name: data['emp_gender']);
          anniver_data.add(aniData);
        }
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

    return anniver_data;
  }

  Future<List<HolidaysModel>> getAllHolidaysList() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? e_id = p.getString('e_id');
    String? token = p.getString('user_access_token');
    var response = await http.get(
      Uri.parse(
          '${baseurl.url}holidays_View?entity_id=${EncryptData.decryptAES(e_id.toString())}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['holidays'];
        HolidaysModel holidaysModel;
        for (var data in jsonArray) {
          holidaysModel = HolidaysModel(
              Date: data['Date'], holiday_name: data['holiday_name']);
          holidaysData.add(holidaysModel);
        }
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

    return holidaysData;
  }

  // that's function use to Location featch
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
    // permission = await Geolocator.checkPermission();
      _AleartToLocationAllow();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<bool> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return false;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
      print("ufffff");
    });
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.locality} ${place.subLocality} ${place.street} - ${place.postalCode}';
        _country_name = '${place.country}';
        print('location $_currentAddress');
        print('lat  ${_currentPosition!.latitude}');
        print('long ${_currentPosition!.longitude}');
        print('country ${place.country}');
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // that's function use to Get ip address
  void ipGet() async {
    try {
      // Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.text);

      // Get the IpAddress based on requestType.
      final data = await ipAddress.getIpAddress();
      setState(() {
        current_ip = data.toString();
      });
      dynamic name = await ipAddress.getIpAddress();

      // print('ip address '+data.toString());
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

      print('w n $wifiName');
      print('w bsd $wifiBSSID');
      print('w wifiIP $wifiIP');
      print('w wifiIPV6 $wifiIPv6');
      print('w wifiSubmask $wifiSubmask');
      print('w wifiBroadcast $wifiBroadcast');
      print('w wifiGateway $wifiGateway');
    } on IpAddressException catch (exception) {
      // Handle the exception.
      print(exception.message);
    }
  }

  @override
  void initState() {
   // _getCurrentPosition();
    getAllBirthData();
    getAllAniversary();
    getCheckIn_OutTime();
    getAllHolidaysList();
    ipGet();

    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    print(
        'data time  ${Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime())}');
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd,MMM hh:mm:s a').format(dateTime);
  }
  void _AleartToLocationAllow() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height*0.31,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: MyColor.mainAppColor,
                            )),
                      ),
                      StatefulBuilder(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Padding(padding: EdgeInsets.only(left: 16,right: 16),
                                child: Container(alignment: Alignment.center,child: Image.asset('assets/images/location.png',height: 45,width: 45,color: MyColor.mainAppColor,)),),

                              Padding(padding: EdgeInsets.only(left: 16,right: 16,top: 20),
                              child: Text('This lets you send your current location for attendance. Allow location access in app settings for enhanced features.'),),

                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    child: const Text(
                                      'Go to app settings',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: MyColor.mainAppColor),
                                    ),
                                    onTap: () {
                                      print(_reson_controler.text);

                                      AppSettings.openAppSettings(type: AppSettingsType.location);
                                        Navigator.pop(context);





                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )),
            ),
          );
        });
  }
 
  void check_In_Dialog(String type, String msg) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: MyColor.mainAppColor,
                            )),
                      ),
                      StatefulBuilder(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: RichText(
                                  text: TextSpan(
                                      text: msg,
                                      style: const TextStyle(
                                          color: MyColor.mainAppColor,
                                          fontSize: 14),
                                      children: const [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14))
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: TextField(
                                      controller: _reson_controler,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Write here ...'),
                                      maxLines: 5,
                                      minLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 24),
                                child: InkWell(
                                  child: Container(
                                    height: 48,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: MyColor.mainAppColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: Colors.white),
                                    ),
                                  ),
                                  onTap: () {
                                    print(_reson_controler.text);
                                    if (_reson_controler.text == '') {
                                      Flushbar(
                                        message:
                                            'Please enter your specify reason',
                                        duration: const Duration(seconds: 1),
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
                                      ).show(context);
                                    } else {
                                      Navigator.pop(context);
                                      sendCheckIn_Checkout(
                                          type, _reson_controler.text);

                                      _reson_controler.clear();


                                    }

                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  void getCheckIn_OutTime() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? user_emp_code = pr.getString('user_emp_code');
    String? token = pr.getString('user_access_token');

    var response = await http
        .post(Uri.parse('${baseurl.url}WebLog-CheckIn-OutDetails'), body: {
      'emp_code': EncryptData.decryptAES(user_emp_code!),
    }, headers: {
      'Authorization': 'Bearer $token'
    });

    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        setState(() {
          in_out_status = jsonObject['type'];
          in_out_time = jsonObject['time'];
        });
      } else {
        in_out_status = "time";
        in_out_time = _timeString;
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: MyColor.new_light_gray,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white, // Change Custom Drawer Icon Color
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              elevation: 0.0,
              backgroundColor:  MyColor.mainAppColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: const Text(
                        'Dashboard',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'pop',
                            color: MyColor.white_color),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          'assets/images/powered_by_tag.png',
                          width: 90,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                // kereen
                Container(
                  height: 110,
                  color: MyColor.mainAppColor,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      child: InkWell(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Container(
                                        height: 58,
                                        decoration: BoxDecoration(
                                            color: MyColor.white_color
                                            ,borderRadius: BorderRadius.circular(10)
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Check-in',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'pop'),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            SvgPicture.asset(
                                                'assets/svgs/Checkin.svg'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      tdata = DateFormat("HH:mm")
                                          .format(DateTime.now());
                                      print(tdata);

                                      String dd = tdata.split(':')[0];
                                      String dd1 = tdata.split(':')[1];
                                      int firstTime = int.parse(dd);
                                      int secondTime = int.parse(dd1);

                                      if ( await _getCurrentPosition()) {
                                        if(checkIn==0){
                                          checkIn++;

                                          sendCheckIn_Checkout('In', '');
                                        }else{

                                        }

                                      }
                                    },
                                  )),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                      child: InkWell(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Container(
                                        height: 58,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: MyColor.white_color
                                            ,borderRadius: BorderRadius.circular(10)
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Check-out',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'pop'),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            SvgPicture.asset(
                                                'assets/svgs/Checkout.svg')
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {



                                      if (await _getCurrentPosition()) {
                                        if(checkOut==0){
                                          checkOut++;

                                          sendCheckIn_Checkout('Out', '');
                                        }else{

                                        }

                                      }
                                    },
                                  )),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Card(
                              elevation: 2,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: MyColor.white_color
                                    ,borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$in_out_status',
                                      style: TextStyle(
                                          color: in_out_status == 'Check Out'
                                              ? Colors.red
                                              : Colors.green,
                                          fontFamily: 'pop',
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '$in_out_time',
                                      style: TextStyle(
                                          color: in_out_status == 'Check Out'
                                              ? Colors.red
                                              : Colors.green,
                                          fontFamily: 'pop',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                    child: InkWell(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                    ),

                                    elevation: 5,
                                    margin: const EdgeInsets.all(4),
                                    child: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                          color: MyColor.white_color
                                          ,borderRadius: BorderRadius.circular(10)
                                      ),

                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                alignment: Alignment.center,
                                                /*decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/document.png'))),*/
                                                child: SvgPicture.asset(
                                                    'assets/svgs/leave_req_icon.svg'),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Leave Request',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Visibility(
                                            visible: false,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, right: 8),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 25,
                                                    height: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                      // border: Border.all(color: Colors.lightBlueAccent),
                                                      shape: BoxShape.circle,
                                                      color: Color(0XFFEEF7FF),
                                                    ),
                                                    child: Text(
                                                      leave_request_pending
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'pop',
                                                          color: Color(
                                                              0xFF0054A4)),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: leave_group == "3"
                                      ? () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "This option is not available for you")));
                                        }
                                      : () {
                                          // Flushbar(
                                          //   message: 'Under process...',
                                          //   duration: const Duration(seconds: 2),
                                          //   flushbarPosition: FlushbarPosition.BOTTOM,
                                          // ).show(context);
                                          // print("click");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const New_leavelist_mainpage()));
                                        },
                                )),
                                const SizedBox(
                                  width: 8,
                                ),
                                Flexible(
                                  child: InkWell(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                            color: MyColor.white_color
                                            ,borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/Doc.svg',
                                                    color: MyColor.mainAppColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  'Document Request',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'pop'),
                                                )
                                              ],
                                            ),
                                            Visibility(
                                              visible: false,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8, right: 8),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 25,
                                                      height: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        // border: Border.all(color: Colors.lightBlueAccent),
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Color(0XFFEEF7FF),
                                                      ),
                                                      child: Text(
                                                        document_request_pending
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: 'pop',
                                                            color: Color(
                                                                0xFF0054A4)),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      // Flushbar(
                                      //   message: 'Coming soon...',
                                      //   duration: const Duration(seconds: 2),
                                      //   flushbarPosition:
                                      //       FlushbarPosition.BOTTOM,
                                      // ).show(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Document_Main_Tab()));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: InkWell(
                              child: Visibility(
                                visible: reported_by == "0" ? false : true,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(4),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: MyColor.white_color
                                        ,borderRadius: BorderRadius.circular(10)
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image(
                                                image: AssetImage(
                                                    "assets/images/tm_req.png")),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Team Request',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'pop',
                                                  color: MyColor.mainAppColor),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: MyColor.mainAppColor,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Team_main_request_access()));
                              },
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 16.0),
                          //   child: Card(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10.0),
                          //     ),
                          //     elevation: 1,
                          //     borderOnForeground: false,
                          //     margin: const EdgeInsets.all(4),
                          //     child: Theme(
                          //       data: Theme.of(context)
                          //           .copyWith(dividerColor: Colors.transparent),
                          //       child: ExpansionTile(
                          //         initiallyExpanded: true,
                          //         title: Row(
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 SvgPicture.asset(
                          //                     "assets/svgs/Team_req.svg"),
                          //                 const SizedBox(
                          //                   width: 8,
                          //                 ),
                          //                 const Text(
                          //                   "Team request",
                          //                   style: TextStyle(
                          //                       color: MyColor.mainAppColor,
                          //                       fontFamily: 'pop',
                          //                       fontSize: 16),
                          //                 )
                          //               ],
                          //             )
                          //           ],
                          //         ),
                          //         children: [
                          //           if (work_flow_data.isEmpty) ...[
                          //             Column(
                          //               children: [
                          //                 SvgPicture.asset(
                          //                   'assets/svgs/no_data_found.svg',
                          //                   width: 60,
                          //                   height: 60,
                          //                 ),
                          //                 const Padding(
                          //                   padding: EdgeInsets.only(
                          //                       top: 16.0, bottom: 8.0),
                          //                   child: Text(
                          //                     'No data found',
                          //                     style: TextStyle(
                          //                         fontSize: 14,
                          //                         fontFamily: 'pop'),
                          //                   ),
                          //                 ),
                          //               ],
                          //             )
                          //           ] else ...[
                          //             if (work_flow_data.length == 1) ...[
                          //               Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 0.0),
                          //                       child: Row(
                          //                         children: [
                          //                           CircleAvatar(
                          //                             radius: 30,
                          //                             child: ClipOval(
                          //                               child: Image.network(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[0]
                          //                                         .emp_photo),
                          //                                 fit: BoxFit.cover,
                          //                                 width: 60,
                          //                                 height: 60,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                             width: 16,
                          //                           ),
                          //                           Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment
                          //                                     .start,
                          //                             children: [
                          //                               Text(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[0]
                          //                                         .wtxn_requester_emp_name
                          //                                         .toString()),
                          //                                 style:
                          //                                     const TextStyle(
                          //                                         fontSize: 16,
                          //                                         fontFamily:
                          //                                             'pop'),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   EncryptData.decryptAES(
                          //                                       work_flow_data[
                          //                                               0]
                          //                                           .wtxn_request_datetime
                          //                                           .toString()),
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   '${EncryptData.decryptAES(work_flow_data[0].ccl_type.toString())}',
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           )
                          //                         ],
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               Align(
                          //                 alignment: Alignment.topRight,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       right: 8.0, bottom: 8.0),
                          //                   child: InkWell(
                          //                     child: const Text(
                          //                       'See more',
                          //                       textAlign: TextAlign.end,
                          //                       style: TextStyle(
                          //                           fontSize: 16,
                          //                           fontFamily: 'pop',
                          //                           color:
                          //                               MyColor.mainAppColor),
                          //                     ),
                          //                     onTap: () {
                          //                       Navigator.of(context).push(
                          //                           MaterialPageRoute(
                          //                               builder: (context) =>
                          //                                   new My_Work_flow_Request(
                          //                                       flow:
                          //                                           work_flow_data)));
                          //                     },
                          //                   ),
                          //                 ),
                          //               )
                          //             ] else if (work_flow_data.length >=
                          //                 2) ...[
                          //               Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 0.0),
                          //                       child: Row(
                          //                         children: [
                          //                           CircleAvatar(
                          //                             radius: 30,
                          //                             child: ClipOval(
                          //                               child: Image.network(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[0]
                          //                                         .emp_photo),
                          //                                 fit: BoxFit.cover,
                          //                                 width: 60,
                          //                                 height: 60,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                             width: 16,
                          //                           ),
                          //                           Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment
                          //                                     .start,
                          //                             children: [
                          //                               Text(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[0]
                          //                                         .wtxn_requester_emp_name
                          //                                         .toString()),
                          //                                 style:
                          //                                     const TextStyle(
                          //                                         fontSize: 16,
                          //                                         fontFamily:
                          //                                             'pop'),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   EncryptData.decryptAES(
                          //                                       work_flow_data[
                          //                                               0]
                          //                                           .wtxn_request_datetime
                          //                                           .toString()),
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   '${EncryptData.decryptAES(work_flow_data[0].ccl_type.toString())}',
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           )
                          //                         ],
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 0.0),
                          //                       child: Row(
                          //                         children: [
                          //                           CircleAvatar(
                          //                             radius: 30,
                          //                             child: ClipOval(
                          //                               child: Image.network(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[1]
                          //                                         .emp_photo),
                          //                                 fit: BoxFit.cover,
                          //                                 width: 60,
                          //                                 height: 60,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                             width: 16,
                          //                           ),
                          //                           Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment
                          //                                     .start,
                          //                             children: [
                          //                               Text(
                          //                                 EncryptData.decryptAES(
                          //                                     work_flow_data[1]
                          //                                         .wtxn_requester_emp_name
                          //                                         .toString()),
                          //                                 style:
                          //                                     const TextStyle(
                          //                                         fontSize: 16,
                          //                                         fontFamily:
                          //                                             'pop'),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   EncryptData.decryptAES(
                          //                                       work_flow_data[
                          //                                               1]
                          //                                           .wtxn_request_datetime
                          //                                           .toString()),
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                               Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .only(
                          //                                         top: 2.0),
                          //                                 child: Text(
                          //                                   '${EncryptData.decryptAES(work_flow_data[1].ccl_type.toString())}',
                          //                                   style:
                          //                                       const TextStyle(
                          //                                           fontSize:
                          //                                               16,
                          //                                           fontFamily:
                          //                                               'pop'),
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           )
                          //                         ],
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               Align(
                          //                 alignment: Alignment.topRight,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       right: 8.0, bottom: 8.0),
                          //                   child: InkWell(
                          //                     child: const Text(
                          //                       'See more',
                          //                       textAlign: TextAlign.end,
                          //                       style: TextStyle(
                          //                           fontSize: 16,
                          //                           fontFamily: 'pop',
                          //                           color:
                          //                               MyColor.mainAppColor),
                          //                     ),
                          //                     onTap: () {
                          //                       Navigator.of(context).push(
                          //                           MaterialPageRoute(
                          //                               builder: (context) =>
                          //                                   new My_Work_flow_Request(
                          //                                       flow:
                          //                                           work_flow_data)));
                          //                     },
                          //                   ),
                          //                 ),
                          //               )
                          //             ]
                          //           ],
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(4),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColor.white_color
                                    ,borderRadius: BorderRadius.circular(10)
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svgs/Birthday.svg"),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "Upcoming birthday",
                                          style: TextStyle(
                                              color: MyColor.mainAppColor,
                                              fontFamily: 'pop',
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                    children: [
                                      if (birth_data.isEmpty) ...[
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgs/no_data_found.svg',
                                              width: 60,
                                              height: 60,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16.0, bottom: 8.0),
                                              child: Text(
                                                'No data found',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 0,
                                                      mainAxisSpacing: 0,
                                                      //childAspectRatio: 1.30,
                                                      mainAxisExtent: 140),
                                              shrinkWrap: true,
                                              itemCount: birth_data.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  color: MyColor.light_bg,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 55,
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 25,
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      birth_data[
                                                                              index]
                                                                          .emp_photo,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 45,
                                                                      height:
                                                                          45,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child: Image
                                                                      .network(
                                                                    birth_data[
                                                                            index]
                                                                        .cake_icon,
                                                                    height: 20,
                                                                    width: 20,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            birth_data[index]
                                                                .name,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'pop_m'),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 2.0),
                                                          child: Text(
                                                            birth_data[index]
                                                                .emp_birthdate,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'pop_m'),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColor.white_color
                                    ,borderRadius: BorderRadius.circular(10)
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Row(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/svgs/Anniversary.svg"),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Work anniversary",
                                              style: TextStyle(
                                                  color: MyColor.mainAppColor,
                                                  fontFamily: 'pop',
                                                  fontSize: 16),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    children: [
                                      if (anniver_data.isEmpty) ...[
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgs/no_data_found.svg',
                                              width: 60,
                                              height: 60,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16.0, bottom: 8.0),
                                              child: Text(
                                                'No data found',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                            ),
                                          ],
                                        )
                                      ] else ...[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 0,
                                                      mainAxisSpacing: 0,
                                                      //childAspectRatio: 1.30,
                                                      mainAxisExtent: 140),
                                              shrinkWrap: true,
                                              itemCount: anniver_data.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  color: MyColor.light_bg,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 55,
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 25,
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      anniver_data[
                                                                              index]
                                                                          .profile_photo,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: 45,
                                                                      height:
                                                                          45,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child: Image
                                                                      .network(
                                                                    anniver_data[
                                                                            index]
                                                                        .cake_icon,
                                                                    height: 20,
                                                                    width: 20,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            anniver_data[index]
                                                                .emp_name,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'pop_m'),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 2.0),
                                                          child: Text(
                                                            anniver_data[index]
                                                                .emp_anidate,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'pop_m'),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColor.white_color
                                    ,borderRadius: BorderRadius.circular(10)
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: false,
                                    title: Row(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svgs/Public_holidays.svg",
                                              color: MyColor.mainAppColor,
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              "Public holidays",
                                              style: TextStyle(
                                                  color: MyColor.mainAppColor,
                                                  fontFamily: 'pop',
                                                  fontSize: 16),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    children: [
                                      if (holidaysData.isEmpty) ...[
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgs/no_data_found.svg',
                                              width: 60,
                                              height: 60,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16.0, bottom: 8.0),
                                              child: Text(
                                                'No data found',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                            ),
                                          ],
                                        )
                                      ] else ...[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: holidaysData.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: MyColor
                                                              .light_gray),
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          holidaysData[index]
                                                              .Date
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'pop_m'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2.0),
                                                        child: Text(
                                                          holidaysData[index]
                                                              .holiday_name,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: MyColor
                                                                  .mainAppColor,
                                                              fontFamily:
                                                                  'pop_m'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          )),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          menuItem(1, "Dashboard", "assets/svgs/Dashboard.svg",
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Leave request", "assets/svgs/Leaverequest92x92.svg",
              currentPage == DrawerSections.leave_request ? true : false),
          menuItem(8, "Log out", "assets/svgs/Logout.svg",
              currentPage == DrawerSections.logout ? true : false),
          /*       menuItem(3, "Travel request", "assets/images/travel_req.png",
              currentPage == DrawerSections.events ? true : false),
          menuItem(4, "Training request", "assets/images/training_req.png",
              currentPage == DrawerSections.notes ? true : false),
          menuItem(5, "Document request", "assets/images/document.png",
              currentPage == DrawerSections.settings ? true : false),
          menuItem(6, "Ticket request", "assets/images/ticket_req.png",
              currentPage == DrawerSections.tic ? true : false),
          menuItem(7, "Trip request", "assets/images/trip_req.png",
              currentPage == DrawerSections.trip ? true : false),
          menuItem(8, "Log out", "assets/images/logout.png",
              currentPage == DrawerSections.logout ? true : false),
   */
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, String iconData, var selected) {
    return Material(
      child: InkWell(
        onTap: () async {
          if (id == 1) {
            currentPage = DrawerSections.dashboard;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => upcoming_dash()));
          } else if (id == 2) {
            currentPage = DrawerSections.leave_request;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const New_leavelist_mainpage()));
          } else if (id == 3) {
            currentPage = DrawerSections.events;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TravelMainTab()));
          } else if (id == 4) {
            currentPage = DrawerSections.notes;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Training_Main_Tab()));
          } else if (id == 5) {
            currentPage = DrawerSections.settings;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Document_Main_Tab()));
          } else if (id == 6) {
            currentPage = DrawerSections.tic;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Ticket_Requets_Main_Tab()));
          } else if (id == 7) {
            currentPage = DrawerSections.trip;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Trip_Request_Main_Tab()));
          } else if (id == 8) {
            currentPage = DrawerSections.logout;
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setString("login_check", "false");
            preferences.commit();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Login_Activity()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top:10,bottom: 10),
          child: Row(
            children: [
              Expanded(
                  child: SvgPicture.asset(
                iconData,
                width: 20,
                height: 20,
                
              )),
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xFF0054A4),
                        fontSize: 14,
                        fontFamily: 'pop'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(16.0)),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                    child: Text('${msg}')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _customProgress(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 80),
          shape: const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(16.0)),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                    child: Text('${msg}',style: TextStyle(
                      fontSize: 18,

                    ),)),
              ],
            ),
          ),

        );
      },
    );
  }

  void sendCheckIn_Checkout(String type, String reason) async {
  //  Navigator.pop(context);
   final ProgressDialog  pr =   ProgressDialog(context);
   _customProgress('Please wait...');
  //  pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? user_emp_code = pref.getString('user_emp_code');
    String? token = pref.getString('user_access_token');
    print("tyuiop " + EncryptData.decryptAES(user_emp_code!));
// var response = await http.post(Uri.parse('http://10.10.10.252/jinzy.co/appMDDAPI/Mobapp_API.php?action=EMP_CHECK_INOUT_REQUEST'), body: {
    var response =
        await http.post(Uri.parse('${baseurl.url}checkinout'), body: {
      'emp_code': EncryptData.decryptAES(user_emp_code),
      //'e_id': '$e_id',
      'type': type,
      'ip': current_ip,
      'location': '$_currentAddress',
      'latitude': '${_currentPosition!.latitude}',
      'longitude': '${_currentPosition!.longitude}',
      'country': '$_country_name',
      // 'ccl_inout_longitude': '${_currentPosition!.longitude}',
      //  'ccl_inout_country_name': '$_country_name',
      //  'ccl_inout_isp': current_ip,
      'reason': reason,
    }, headers: {
      'Authorization': 'Bearer $token'
    });

    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        pr.hide();
        Navigator.pop(context);
        getCheckIn_OutTime();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else if (jsonObject['status'] == '0') {
        Navigator.pop(context);
        pr.hide();
        _showMyDialog(jsonObject['message']);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else if (jsonObject['status'] == 'LateCheckin') {
        pr.hide();
        Navigator.pop(context);
        check_In_Dialog('In', 'Specify Reason (why are you late today?)');
      } else if (jsonObject['status'] == 'EarlyCheckout') {
        pr.hide();
        Navigator.pop(context);
        check_In_Dialog(
            'Out', 'Specify Reason (why are you leaving early today?)');
      } else {
        pr.hide();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      pr.hide();
      Navigator.pop(context);
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }
}



enum DrawerSections {
  dashboard,
  leave_request,
  events,
  notes,
  settings,
  tic,
  trip,
  logout
}
