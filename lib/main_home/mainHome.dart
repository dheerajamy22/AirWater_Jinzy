import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:demo/announcements/announcements_daily.dart';
import 'package:demo/attandance_part/attandance.dart';
import 'package:demo/document_request/document_main_tab.dart';
import 'package:demo/key_event/plaud_feed/plaud_feed_.dart';
import 'package:demo/leave_process/leave_tab_main.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/my_drawer_header.dart';
import 'package:demo/send_plaud/send_plaud_.dart';
import 'package:demo/team_request_access_panel/team_request_dashboard/team_request_dashboard.dart';
import 'package:demo/ticket_request_panel/ticket_request_main_tab.dart';
import 'package:demo/training_request/training_request_main_tab.dart';
import 'package:demo/travel_expenses/travel_expeses_tab_main.dart';
import 'package:demo/trip_request_panel/trip_request_main_tab.dart';
import 'package:demo/upcoming_birthday/up_coming_birthday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../app_color/color_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MainHome extends StatefulWidget {
  @override
  MainHomeState createState() => MainHomeState();
}

class MainHomeState extends State<MainHome> {
  var currentPage = DrawerSections.dashboard;
  String? leave_request_pending = '';
  String? document_request_pending = '';
  String? travel_expenses_request_pending = '';
  String? training_request_pending = '';
  String? trip_request_pending = '';
  String? ticket_request_pending = '';
  String? _currentAddress;
  Position? _currentPosition;

  // part of location
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.locality} ${place.subLocality} ${place.street} - ${place.postalCode}';

        print('location ${_currentAddress}');
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // --end part of location start rest Api
  Future getAllPendingRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user_id = sharedPreferences.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_EMPLOYEE_REQUEST_STATISTICS'),
        body: {
          'emp_userid': '${user_id}',
        });

    var jsonData = json.decode(response.body);

    var jsonArray = jsonData['ReqStatisticsList'];

    for (var pend in jsonArray) {
      setState(() {
        leave_request_pending = pend['leave_request_pending'];
        document_request_pending = pend['document_request_pending'];
        travel_expenses_request_pending =
            pend['travel_expenses_request_pending'];
        training_request_pending = pend['training_request_pending'];
        trip_request_pending = pend['trip_request_pending'];
        ticket_request_pending = pend['ticket_request_pending'];
      });
      print('object' '$leave_request_pending');
    }

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
  }

  String? _timeString;

  @override
  void initState() {
    getAllPendingRequest();
    _getCurrentPosition();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    print('${Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime())}');
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
    return DateFormat('dd,MMM hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: const Color(0xFF0054A4),
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                      ),
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
              Container(
                height: 70,
                color: MyColor.mainAppColor,
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(right: 24),
                  child: Text(
                    '${_timeString}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: 'pop'),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                  child: InkWell(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(4),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/leave_req.png'))),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Attendance',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'pop'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // print("click");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyAttandance()));
                                },
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/tm_req.png'))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Team Request',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                        ],
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
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                  child: InkWell(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(4),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/leave_req.png'))),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 25,
                                                height: 25,
                                                decoration: const BoxDecoration(
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
                                                      color: Color(0xFF0054A4)),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // print("click");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LeaveListActivity()));
                                },
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/training_req.png'))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Training Request',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: Text(
                                                    training_request_pending
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new Training_Main_Tab()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                  child: InkWell(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: const EdgeInsets.all(4),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/trip_req.png'))),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Business trip \n Request',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'pop'),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 25,
                                                height: 25,
                                                decoration: const BoxDecoration(
                                                  // border: Border.all(color: Colors.lightBlueAccent),
                                                  shape: BoxShape.circle,
                                                  color: Color(0XFFEEF7FF),
                                                ),
                                                child: Text(
                                                  trip_request_pending
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'pop',
                                                      color: Color(0xFF0054A4)),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new Trip_Request_Main_Tab()));
                                },
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/ticket_req.png'))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Ticket Request',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: Text(
                                                    ticket_request_pending
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new Ticket_Requets_Main_Tab()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/travel_req.png'))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Travel Expenses',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: Text(
                                                    travel_expenses_request_pending
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new TravelMainTab()));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/document.png'))),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: Text(
                                                    document_request_pending
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new Document_Main_Tab()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
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
                                                    'assets/svgs/reward_recognisation.svg'),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Reward & Recognization',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: const Text(
                                                    '0',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new My_Plaud_feed()));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: InkWell(
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4),
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
                                                  'assets/svgs/plaud_feed.svg',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                'Plaud feed',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, right: 8),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 25,
                                                  height: 25,
                                                  decoration: const BoxDecoration(
                                                    // border: Border.all(color: Colors.lightBlueAccent),
                                                    shape: BoxShape.circle,
                                                    color: Color(0XFFEEF7FF),
                                                  ),
                                                  child: const Text(
                                                    '0',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop',
                                                        color:
                                                            Color(0xFF0054A4)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new My_Send_Plaud()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Visibility(
                            visible: false,
                            child: InkWell(
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Image.asset(
                                            'assets/images/tm_req.png',
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(left: 12.0),
                                          child: Text(
                                            'Team Request',
                                            style: TextStyle(
                                              fontFamily: 'pop',
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
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
                                            new Team_main_request_access()));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(4),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Image.asset(
                                          '',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Announcements',
                                          style: TextStyle(
                                            fontFamily: 'pop',
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
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
                                          new UpComing_Announcements()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(4),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Image.asset(
                                          'assets/images/birthday.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Upcoming birthday',
                                          style: TextStyle(
                                            fontFamily: 'pop',
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
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
                                          new UpComing_Birthday()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: const EdgeInsets.all(4),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Image.asset(
                                          'assets/images/anniversary.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Work anniversary',
                                          style: TextStyle(
                                            fontFamily: 'pop',
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {

                            },
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
            child: Container(
              child: Column(
                children: [
                  const MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Dashboard", "assets/images/home.png",
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Leave request", "assets/images/leave_req.png",
              currentPage == DrawerSections.leave_request ? true : false),
          menuItem(3, "Travel request", "assets/images/travel_req.png",
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainHome()));
          } else if (id == 2) {
            currentPage = DrawerSections.leave_request;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LeaveListActivity()));
          } else if (id == 3) {
            currentPage = DrawerSections.events;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TravelMainTab()));
          } else if (id == 4) {
            currentPage = DrawerSections.notes;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Training_Main_Tab()));
          } else if (id == 5) {
            currentPage = DrawerSections.settings;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Document_Main_Tab()));
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Login_Activity()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                  child: Image.asset(
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
