import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../_login_part/login_activity.dart';
import '../encryption_file/encrp_data.dart';

class misspunch extends StatefulWidget {
  const misspunch({super.key});

  @override
  State<misspunch> createState() => _misspunchState();
}

class _misspunchState extends State<misspunch> {
  var FromedateInput = TextEditingController(text: 'Date');
  TextEditingController _reason = TextEditingController();
  bool _datevisi = true;
  String datevalid = "";
  List<String> punch_type = ["Check In", "Check Out"];
  String punchtype = "Check In";
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _currentAddress;
  String? _locality;
  String? _country_name;
  String tdata = '';
  String current_ip = '';
  String lat = '';
  String long = '';
  Position? _currentPosition;
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ipGet();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: MyColor.white_color,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              SizedBox(
                width: 8,
              ),
              Text(
                "Punch Regularization Request",
                style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Location",
              //   style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height * 0.05,
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(left: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.black26),
              //       borderRadius: BorderRadius.circular(8)),
              //   child: Text(
              //     '${_locality}',
              //     style: TextStyle(
              //         color: Colors.black, fontFamily: 'pop', fontSize: 14),
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              Text("Punch Type",
                  style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8)),
                child: DropdownButton(
                  value: punchtype,
                  isDense: true,
                  isExpanded: true,
                  underline: Container(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: punch_type.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      punchtype = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Date",
                            style:
                                TextStyle(fontFamily: "pop_m", fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().subtract(Duration(days: 1)),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              //DateTime.now() - not to allow to choose before today.
                              lastDate:
                                  DateTime.now().subtract(Duration(days: 1)),
                              firstDate: DateTime(2023),
                            );

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                FromedateInput.text = formattedDate;
                                _datevisi = false;
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Visibility(
                                          visible: _datevisi,
                                          child: Text(DateTime.now()
                                              .toString()
                                              .split(" ")
                                              .first)),
                                      Visibility(
                                          visible:
                                              _datevisi == false ? true : false,
                                          child: Text(FromedateInput.text)),
                                    ],
                                  ),
                                  Icon(Icons.calendar_month)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$punchtype Time",
                            style:
                                TextStyle(fontFamily: "pop_m", fontSize: 16)),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                initialEntryMode: TimePickerEntryMode.dial);
                            if (timeOfDay != null) {
                              setState(() {
                                selectedTime = timeOfDay;
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${selectedTime.hour}:${selectedTime.minute}"),
                                Icon(Icons.schedule)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Reason",
                style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _reason,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Reason..",
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    if (await _getCurrentPosition()) {
                      if (validation()) {
                        if (count == 0) {
                          count++;
                          sendCheckIn_Checkout(punchtype, '');
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                        color: MyColor.mainAppColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        "Confirm Request",
                        style: TextStyle(
                            fontFamily: "pop", color: MyColor.white_color),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _AleartToLocationAllow() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            content: SingleChildScrollView(
              child: Container(
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
                            padding: EdgeInsets.only(left: 0, right: 0),
                            child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/location.png',
                                  height: 45,
                                  width: 45,
                                  color: MyColor.mainAppColor,
                                )),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 0, right: 0, top: 16),
                            child: Text(
                                'This lets you send your current location for attendance. Allow location access in app settings for enhanced features.'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 0, top: 16),
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
                                  AppSettings.openAppSettings(
                                      type: AppSettingsType.location);
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

  bool validation() {
    if (FromedateInput.text == 'Date') {
      _showMyDialog('Please Select date', Color(0xFF861F41), 'error');
      return false;
    } else if (_reason.text == '') {
    _showMyDialog('Please enter reason', Color(0xFF861F41), 'error');
    return false;
  }

    return true;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _AleartToLocationAllow();
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
        _locality = place.locality;
        _country_name = '${place.country}';
        print('location $_currentAddress');
        print('lat  ${_currentPosition!.latitude}');
        print('long ${_currentPosition!.longitude}');
        print('_locality ${_locality}');
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
        print('dfgfADSC  $current_ip');
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

  void sendCheckIn_Checkout(String type, String reason) async {
    if (type == 'Check In') {
      type = 'Misspunch-In';
    } else {
      type = 'Misspunch-Out';
    }
    _customProgress('Please wait...');
    final ProgressDialog pr = ProgressDialog(context);

    //  pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? user_emp_code = pref.getString('user_emp_code');
    String? token = pref.getString('user_access_token');

    print("tyuiop " +
        EncryptData.decryptAES(user_emp_code!) +
        type +
        current_ip +
        '$_currentAddress' +
        '${selectedTime.hour}:${selectedTime.minute}' +
        '${FromedateInput.text}' +
        '${_reason.text}');
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
      'reason': _reason.text,
      'date': '${FromedateInput.text}',
      'time': '${selectedTime.hour}:${selectedTime.minute}',
      'checkin_from': '',
      'checkout_from': '',
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      if (jsonObject['status'] == '1') {
        pr.hide();
        Navigator.pop(context);
        _showMyDialog(jsonObject['message'], Colors.green, 'success');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => upcoming_dash()));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else if (jsonObject['status'] == '0') {
        Navigator.pop(context);
        count = 0;
        _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else {
        pr.hide();
        count = 0;
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      pr.hide();
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  Future<void> _customProgress(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      '${msg}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
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
}
