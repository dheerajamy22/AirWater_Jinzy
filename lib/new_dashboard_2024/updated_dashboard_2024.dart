import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:demo/Earlygoing_latecoming/EC_LC_main.dart';
import 'package:demo/Earlygoing_latecoming/EG_LC.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/attendance_analysis/attendance_analysis.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/birthday_anniversary/birth_ani.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/halfday_leave/halfday_dash.dart';
import 'package:demo/leave_process/create_leave_request.dart';
import 'package:demo/miss_punch/miss_punch.dart';
import 'package:demo/my_drawer_header.dart';
import 'package:demo/myteam/team.dart';
import 'package:demo/new_leave_managerdashboard/leave_workflowmethod.dart';
import 'package:demo/new_leave_page_by_Vikas_Sir/leavelist.dart';
import 'package:demo/new_leave_page_by_Vikas_Sir/leavelist_method.dart';
import 'package:demo/purchase_request/purchaserqst.dart';
import 'package:demo/travel_expenses/create_travel_expenses.dart';
import 'package:demo/wfh/maindash_wfh.dart';
import 'package:demo/workflow_request_panel/all_attandance_aproved_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import '../app_color/color_constants.dart';
import '../team_request_access_panel/team_request_model.dart';
import '../upcoming_birthday/birthday_model.dart';
import 'balance_leave_model.dart';

class upcoming_dash extends StatefulWidget {
  const upcoming_dash({super.key});

  @override
  State<upcoming_dash> createState() => _upcoming_dashState();
}

class _upcoming_dashState extends State<upcoming_dash> {
  var currentPage = DrawerSections.dashboard;
  String emp_name = "", emp_img = "";
  String? leave_request_pending = '';
  String? document_request_pending = '';
  String? travel_expenses_request_pending = '';
  String? training_request_pending = '';
  String? trip_request_pending = '';
  String? ticket_request_pending = '';
  String? _currentAddress;
  String? _locality;
  String? _location_area_name;
  String? _country_name;
  String tdata = '';
  String current_ip = '';
  double lat = 0.0;
  double long = 0.0;
  String in_time = "";
  String out_time = "";
  String grosstime = "";
  String shift_time = "";
  String totalpresent = '';
  String latecheckin = '';
  String totalleave = '';
  String absent = '';
  String? in_out_status;
  Position? _currentPosition;
  String? reported_by, leave_group, empstatus;
  int checkIn = 0;
  int checkOut = 0;
  bool in_out_visi = true, in_out_visi_text = true;
  List<leavelistdetails> data = [];
  String focus_message = '';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _reson_controler = TextEditingController();
  List<BirthdayModel> birth_data = [];
  List<leave_workflow> workflow_list = [];
  List<Workflow> work_flow_data = [];
  List<BalanceLeaveModel> balance_list = [];
  File? _capturedImage;
  List<String> req_no_list = [];

  @override
  void initState() {
    //CallSingInApi();
    getvalues();
    //versionUpdate();
    getCheckIn_OutTime();
    ipGet();
    _getCurrentPosition();
    getAllBirthData();
    getLeaveBalance();
    getAttandanceWorkFlowRequest();
    super.initState();
  }

  Future<void> CallSingInApi() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? login_email = p.getString('login_email');
    String? login_password = p.getString('login_password');

    var response = await http.post(
        Uri.parse(
          '${baseurl.url}login',
        ),
        body: {'email': login_email, 'password': login_password});

    var jsonObject = jsonDecode(response.body);

    if (jsonObject['status'] == "1") {
      print(response.body);

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setString("user_name", jsonObject['emp_fullName']);
      await preferences.setString("user_id", jsonObject['id']);
      await preferences.setString("login_email", '${login_email}');
      await preferences.setString("login_password", '${login_password}');
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
      await preferences.setString("emp_contact", jsonObject['emp_contact_no']);
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
      getvalues();
      print('employement_status ${jsonObject['employement_status']}');
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => upcoming_dash()));
      //  _showMyDialog(jsonObject['message'],Color(0xFF861F41),'error');
    } else if (jsonObject['status'] == "0") {
      _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
    }
  }

  Widget MyDrawerList() {
    return Container(
      color: MyColor.white_color,
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
      child: Container(
        color: MyColor.white_color,
        child: InkWell(
          onTap: () async {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => upcoming_dash()));
            } else if (id == 2) {
              currentPage = DrawerSections.leave_request;

              if (empstatus == "Confirmed") {
                if (reported_by == "1") {
                  showDialog(
                      context: context,
                      builder: (BuildContext) {
                        return AlertDialog(
                          scrollable: true,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreteLeaveRequest(
                                                        self_select: 'Self',
                                                      )));
                                        },
                                        child: Card(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: SvgPicture.asset(
                                                      "assets/new_svgs/Self.svg"),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text("Self",
                                                    style: TextStyle(
                                                        fontFamily: "pop",
                                                        fontSize: 14))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreteLeaveRequest(
                                                        self_select:
                                                            'On Behalf',
                                                      )));
                                        },
                                        child: Card(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: SvgPicture.asset(
                                                      "assets/new_svgs/Onbehalf.svg"),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "On-Behalf",
                                                  style: TextStyle(
                                                      fontFamily: "pop",
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: MyColor.mainAppColor,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                        child: Text(
                                      "Cancel",
                                      style:
                                          TextStyle(color: MyColor.white_color),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreteLeaveRequest(
                                self_select: 'Self',
                              )));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("This is not Available for you")));
              }
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.tic;
            } else if (id == 7) {
            } else if (id == 8) {
              currentPage = DrawerSections.logout;
              final value = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text(
                        'Do you want to Log out',
                        style: TextStyle(fontSize: 16, fontFamily: 'i_medium'),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text(
                              'No',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'i_medium'),
                            )),
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'i_medium'),
                            )),
                      ],
                    );
                  });

              if (value != null) {
                sendLogoutRequest();
              } else {
                return Future.value(false);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 16, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  iconData,
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF0054A4),
                      fontSize: 16,
                      fontFamily: 'pop_m'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text('Do you want to Exit ?'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text('No')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Exit'))
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
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        barrierDismissible: false,
        showLater: false,
        showIgnore: false,
        showReleaseNotes: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: MyColor.new_light_gray,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: Icon(Icons.menu)),
                CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: emp_img != "" && emp_img.isNotEmpty
                        ? Image.network(
                            emp_img,
                            fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          )
                        : Icon(
                            Icons.person, // Fallback icon
                            size: 50,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $emp_name",
                      style: TextStyle(fontFamily: 'pop_m', fontSize: 16),
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(fontFamily: 'pop', fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: MyColor.new_light_gray,
          key: _scaffoldKey,
          drawer: Drawer(
            backgroundColor: MyColor.white_color,
            surfaceTintColor: MyColor.white_color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(0))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshitems,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 16, bottom: 32),
                  child: Column(
                    children: [
                      // In out card STart
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: MyColor.light_gray),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //this area for checkin and out info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Today's Shift",
                                          style: TextStyle(
                                              fontFamily: 'pop_m',
                                              fontSize: 14)),
                                      Text("${shift_time}",
                                          style: TextStyle(
                                              fontFamily: 'pop', fontSize: 14)),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text("Check In",
                                                  style: TextStyle(
                                                      fontFamily: 'pop_m',
                                                      fontSize: 14)),
                                              if (in_time.isEmpty) ...[
                                                Text('--',
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14))
                                              ] else ...[
                                                Text(in_time,
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14))
                                              ]
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Column(
                                            children: [
                                              Text("Check Out",
                                                  style: TextStyle(
                                                      fontFamily: 'pop_m',
                                                      fontSize: 14)),
                                              if (out_time.isEmpty) ...[
                                                Text('--',
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14))
                                              ] else ...[
                                                Text(out_time,
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14))
                                              ]
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ), //End of checkin and out area
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        in_out_visi_text = false;
                                      });

                                      ///print('checkout value ${in_out_visi_text}');

                                      if (await _getCurrentPosition()) {
                                        final Distance distance =
                                            new Distance();

                                        final double meter = distance(
                                            new LatLng(lat, long),
                                            new LatLng(28.6247543, 77.3782848));
                                        if (in_out_visi == true) {
                                          if (checkOut == 0) {
                                            checkOut++;
                                            sendCheckIn_Checkout(
                                                'In', '', '', 'Inside');
                                          }
                                        } else {
                                          if (checkOut == 0) {
                                            checkOut++;
                                            sendCheckIn_Checkout(
                                                'Out', '', '', 'Inside');
                                          }
                                        }
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Visibility(
                                          visible: in_out_visi,
                                          child: CircleAvatar(
                                            radius: 50,
                                            // backgroundColor: MyColor.white_color,
                                            child: SvgPicture.asset(
                                                "assets/new_svgs/Check_in.svg"),
                                          ),
                                        ),
                                        Visibility(
                                          visible: in_out_visi == false
                                              ? true
                                              : false,
                                          child: CircleAvatar(
                                            radius: 50,
                                            // backgroundColor: MyColor.white_color,
                                            child: SvgPicture.asset(
                                                "assets/new_svgs/Check_out.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  BoxDecoration(color: MyColor.new_light_gray),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Text("Total time - ",
                                      style: TextStyle(
                                          fontFamily: 'pop', fontSize: 14)),
                                  Text(
                                      '${grosstime.split(':').first} h ${grosstime.split(':').last} m',
                                      style: TextStyle(
                                          fontFamily: 'pop_m', fontSize: 14))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on),
                                  if (_currentAddress == null) ...[
                                    Text('--',
                                        style: TextStyle(
                                            fontFamily: 'pop', fontSize: 14))
                                  ] else ...[
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                            '${_currentAddress.toString()}',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontFamily: 'pop',
                                                fontSize: 14)),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            )
                          ],
                        ),
                      ),
                      // In out card End
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Attendance Analysis",
                              style:
                                  TextStyle(fontFamily: 'pop_m', fontSize: 16)),
                          Text(DateFormat('MMM yyyy').format(DateTime.now()),
                              style:
                                  TextStyle(fontFamily: 'pop', fontSize: 14)),
                        ],
                      ),
                      //Attendance analysis cards start here
                      const SizedBox(
                        height: 8,
                      ),
                      Card(
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyColor.white_color,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  padding: EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color,
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: MyColor.new_blue_color
                                            .withOpacity(0.2),
                                        child: Text(
                                          "${totalpresent}",
                                          style: TextStyle(
                                              color: MyColor.new_blue_color),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Present",
                                          style: TextStyle(
                                              fontFamily: 'pop', fontSize: 16))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  padding: EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color,
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: MyColor
                                            .new_yellow_color
                                            .withOpacity(0.2),
                                        child: Text(
                                          "${latecheckin}",
                                          style: TextStyle(
                                              color: MyColor.new_yellow_color),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Late",
                                          style: TextStyle(
                                              fontFamily: 'pop', fontSize: 16))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  padding: EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color,
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: MyColor.new_red_color
                                            .withOpacity(0.2),
                                        child: Text(
                                          "${totalleave}",
                                          style: TextStyle(
                                              color: MyColor.new_red_color),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Leave",
                                          style: TextStyle(
                                              fontFamily: 'pop', fontSize: 16))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Attendance analysis cards end here
                      const SizedBox(
                        height: 16,
                      ),
                      //services start here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Services",
                              style:
                                  TextStyle(fontFamily: 'pop', fontSize: 16)),
                          //   Text("See all", style: TextStyle(fontFamily: 'pop'))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (empstatus == "Confirmed") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreteLeaveRequest(
                                                        self_select: 'Self',
                                                      )));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text("Not Applicable")));
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/ApplyLeave.svg',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.065,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyColor.mainAppColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Apply \n Leave',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Flexible(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (empstatus == "Confirmed") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      main_wfh()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Not Applicable")));
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/ApplyWFH.svg',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.065,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyColor.new_yellow_color),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Apply \n OT',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Flexible(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    attendanceanalysis(
                                                        late: latecheckin,
                                                        present: totalpresent,
                                                        absent: absent)));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/Check_In_Out_1.svg',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.065,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyColor.new_light_green),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'CheckIn \n out Logs',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Flexible(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    misspunch()));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/Punch.svg',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.065,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: MyColor.new_red_color),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Missed \n Punch',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (empstatus == "Confirmed") {
                                            _leavebalance(balance_list);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Not Applicable")));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/Leave_Balance.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.mainAppColor),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Leave \n Balance',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (empstatus == "Confirmed") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        leavelist()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Not Applicable")));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/Leave_History.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.new_yellow_color),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Leave \n History',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (reported_by == "1") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        myteam()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Not Applicable")));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/my_team_icon.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.green_color
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'My \n Team',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (empstatus == "Confirmed") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        halfdayDash()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Not Applicable")));
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/half_day.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.new_red_color
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Apply \n Halfday',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EGLCDash()));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/Punch.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.mainAppColor),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'LC/EG',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Create_Travel_Activty()));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/Leave_History.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.new_yellow_color),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Expense \n Claim',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      purchaseRequest()));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/new_svgs/my_team_icon.svg',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: MyColor.green_color
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Purchase \n Request',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        alignment: Alignment.center,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //services end here

                      //My team area end here
                      const SizedBox(
                        height: 16,
                      ),
                      //Birthday area start here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Birthdays & Anniversary",
                              style:
                                  TextStyle(fontFamily: 'pop_m', fontSize: 16)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            birthday_anniversary()));
                              },
                              child: Text("See all",
                                  style: TextStyle(fontFamily: 'pop')))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (!birth_data.isEmpty) ...[
                        Row(
                          children: [
                            Flexible(
                              child: Card(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  //width: MediaQuery.of(context).size.width * 0.3,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        child: ClipOval(
                                          child: Image.network(
                                            birth_data[0].emp_photo,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        birth_data[0].name,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        birth_data[0].emp_birthdate,
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (birth_data.length == 2) ...[
                              Flexible(
                                child: Visibility(
                                  visible: birth_data.length > 1 ? true : false,
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: MyColor.white_color,
                                      ),
                                      padding: EdgeInsets.all(10),
                                      //width: MediaQuery.of(context).size.width * 0.3,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            child: ClipOval(
                                              child: Image.network(
                                                birth_data[1].emp_photo,
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            birth_data[1].name,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            birth_data[1].emp_birthdate,
                                            style: TextStyle(fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ] else ...[
                        SizedBox(
                          height: 16,
                        ),
                        SvgPicture.asset(
                          "assets/svgs/no_data_found.svg",
                          height: 55,
                          width: 55,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                      //Birthday area end here
                      const SizedBox(
                        height: 16,
                      ),
                      //leave request area start here
                      Visibility(
                        visible: reported_by == "1" ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Attendance Request",
                                style: TextStyle(
                                    fontFamily: 'pop_m', fontSize: 16)),
                            InkWell(
                                onTap: () {
                                  if (work_flow_data.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllAttandanceApprovePage(
                                                    work_flow_data:
                                                        work_flow_data,
                                                    req_no_list: req_no_list)));
                                  }
                                },
                                child: Text("See all",
                                    style: TextStyle(fontFamily: 'pop')))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (work_flow_data.isNotEmpty) ...[
                        if (work_flow_data.length == 1) ...[
                          Column(
                            children: [
                              Card(
                                elevation: 4,
                                shadowColor: MyColor.mainAppColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyColor.white_color),
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(
                                                child: Image.network(
                                                  '${EncryptData.decryptAES(work_flow_data[0].emp_photo.toString())}',
                                                  fit: BoxFit.cover,
                                                  width: 60,
                                                  height: 60,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${EncryptData.decryptAES(work_flow_data[0].wtxn_requester_emp_name.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Text(
                                                    '${EncryptData.decryptAES(work_flow_data[0].wtxn_request_datetime.toString())}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '${EncryptData.decryptAES(work_flow_data[0].ccl_type.toString())}',
                                          style: const TextStyle(
                                              fontSize: 16, fontFamily: 'pop'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ] else ...[
                          Column(
                            children: [
                              Card(
                                elevation: 4,
                                shadowColor: MyColor.mainAppColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyColor.white_color),
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(
                                                child: Image.network(
                                                  '${EncryptData.decryptAES(work_flow_data[0].emp_photo.toString())}',
                                                  fit: BoxFit.cover,
                                                  width: 60,
                                                  height: 60,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${EncryptData.decryptAES(work_flow_data[0].wtxn_requester_emp_name.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Text(
                                                    '${EncryptData.decryptAES(work_flow_data[0].wtxn_request_datetime.toString())}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '${EncryptData.decryptAES(work_flow_data[0].ccl_type.toString())}',
                                          style: const TextStyle(
                                              fontSize: 16, fontFamily: 'pop'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Column(
                            children: [
                              Card(
                                elevation: 4,
                                shadowColor: MyColor.mainAppColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyColor.white_color),
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(
                                                child: Image.network(
                                                  '${EncryptData.decryptAES(work_flow_data[1].emp_photo.toString())}',
                                                  fit: BoxFit.cover,
                                                  width: 60,
                                                  height: 60,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${EncryptData.decryptAES(work_flow_data[1].wtxn_requester_emp_name.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Text(
                                                    '${EncryptData.decryptAES(work_flow_data[1].wtxn_request_datetime.toString())}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 2,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '${EncryptData.decryptAES(work_flow_data[1].ccl_type.toString())}',
                                          style: const TextStyle(
                                              fontSize: 16, fontFamily: 'pop'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ] else ...[
                        SizedBox(
                          height: 16,
                        ),
                        Visibility(
                          visible: reported_by == "1" ? true : false,
                          child: SvgPicture.asset(
                            "assets/svgs/no_data_found.svg",
                            height: 55,
                            width: 55,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ]
                      ////leave request area end here
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// that's function use to Location featch
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
        _location_area_name = place.name;
        _country_name = '${place.country}';
        lat = _currentPosition!.latitude;
        long = _currentPosition!.longitude;
        print('location $_currentAddress');
        print('lat  ${_currentPosition!.latitude}');
        print('long ${_currentPosition!.longitude}');
        print('_locality ${_locality}');
        print('postal code ${place.postalCode}');
        print('name ${place.name}');
        print('subAdministrativeArea ${place.subAdministrativeArea}');
        print('administrativeArea ${place.administrativeArea}');
        print('subThoroughfare ${place.subThoroughfare}');
        print('subThoroughfare ${place.isoCountryCode}');
        print('street ${place.street}');
        print('subLocality ${place.subLocality}');
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

  void getvalues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      emp_name = EncryptData.decryptAES(pref.getString("user_name")!);
      emp_img = EncryptData.decryptAES(pref.getString("user_profile")!);
      //print('profile $emp_img');
    });
  }

  void getCheckIn_OutTime() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? user_emp_code = pr.getString('user_emp_code');
    String? token = pr.getString('user_access_token');
    print('${token}');
    var response = await http
        .post(Uri.parse('${baseurl.url}WebLog-CheckIn-OutDetails'), body: {
      'emp_code': EncryptData.decryptAES(user_emp_code!),
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    print("checkin out logs");
    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        setState(() {
          in_time = jsonObject['in_time'];
          out_time = jsonObject['out_time'];
          grosstime = jsonObject['grosstime'];
          shift_time = jsonObject['shift_time'];
          totalpresent = jsonObject['totalpresent'];
          latecheckin = jsonObject['latecheckin'];
          totalleave = jsonObject['totalleave'];
          absent = jsonObject['absent'];

          if (in_time.isEmpty) {
            setState(() {
              in_out_visi = true;
            });
          } else {
            setState(() {
              in_out_visi = false;
            });
          }
        });
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  void versionUpdate() async {
    var response = await http.post(
      Uri.parse('${baseurl.url}versionupdate'),
      body: {
        'version': '1',
      },
    );

    print('kya session ${response.body}');
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
      } else if (jsonObject['status'] == '0') {
        updateDialog(jsonObject['message']);
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  Future<void> _showinoutsucessdailog(String time, String type) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              contentPadding: EdgeInsets.all(20),
              content: Column(
                children: [
                  Stack(
                    children: [
                      Text("Check ${type} Successfull !",
                          style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.done,
                      size: 30,
                    ),
                    backgroundColor: MyColor.new_sky_color.withOpacity(0.2),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Date",
                    style: TextStyle(fontFamily: "pop", fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateTime.now().toString().split(" ").first,
                    style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Time",
                    style: TextStyle(fontFamily: "pop", fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    time,
                    style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Location",
                    style: TextStyle(fontFamily: "pop", fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _locality!,
                    style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      getCheckIn_OutTime();
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: MyColor.mainAppColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Text(
                        "Ok",
                        style:
                            TextStyle(color: MyColor.white_color, fontSize: 16),
                      )),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> _showcameradailog() {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text("Center your face in the square"),
                  ),
                  // CircleAvatar(
                  //   radius: 190,
                  //   child: ClipOval(
                  //     child: Image.network(
                  //       emp_img,
                  //       fit: BoxFit.cover,
                  //       width: 230,
                  //       height: 230,
                  //     ),
                  //   ),
                  // ),

                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 150,
                      backgroundColor: Colors.black.withOpacity(0.02),
                      child: ClipOval(
                        child: Builder(builder: (context) {
                          // if (_capturedImage != null) {
                          //   return Center(
                          //     child: Stack(
                          //       alignment: Alignment.bottomCenter,
                          //       children: [
                          //         Image.file(
                          //           _capturedImage!,
                          //           // width: double.maxFinite,
                          //           fit: BoxFit.fitWidth,
                          //         ),
                          //         ElevatedButton(
                          //             onPressed: () =>
                          //                 setState(() => _capturedImage = null),
                          //             child: const Text(
                          //               'Capture Again',
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.w700),
                          //             ))
                          //       ],
                          //     ),
                          //   );
                          // }
                          return SmartFaceCamera(
                              showCaptureControl: false,
                              showCameraLensControl: false,
                              showFlashControl: false,
                              autoCapture: true,
                              defaultCameraLens: CameraLens.front,
                              onCapture: (File? image) {
                                setState(() {
                                  _capturedImage = image;
                                  Navigator.pop(context);
                                  print(
                                      "path of image is  ${File(_capturedImage.toString())}");
                                });
                                if (in_out_visi == true) {
                                  if (checkIn == 0) {
                                    checkIn++;

                                    sendCheckIn_Checkout('In', '');
                                  }
                                } else {
                                  if (checkOut == 0) {
                                    checkOut++;

                                    sendCheckIn_Checkout('Out', '');
                                  }
                                }
                              },
                              onFaceDetected: (Face? face) {
                                print('rrrr');
                              },
                              messageBuilder: (context, face) {
                                if (face == null) {
                                  //    setState(() {
                                  //   focus_message='Place your face in the camera';
                                  // });
                                  return _message('');
                                }
                                if (!face.wellPositioned) {
                                  //     setState(() {
                                  //   focus_message='Center your face in the square';
                                  // });
                                  return _message('');
                                }
                                return const SizedBox.shrink();
                              });
                        }),
                      ),
                    ),
                  ),*/
                ],
              ),
            );
          });
        });
  }

  Widget _message(String msg) {
    // setState(() {
    //   focus_message=msg;
    // });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
      child: Text(msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
    );
  }

  Future<void> _leavebalance(List<BalanceLeaveModel> balancelist) {
    bool _leavebalance_visi = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 370,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Leave Balance",
                            style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close)),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: balancelist.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            return Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${balance_list[index].lc_name}",
                                      style: TextStyle(
                                          fontFamily: "pop_m", fontSize: 16),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                LinearProgressBar(
                                  maxSteps: int.parse(
                                      balancelist[index].totalbalance),
                                  progressType:
                                      LinearProgressBar.progressTypeLinear,
                                  // Use Dots progress
                                  currentStep: int.parse(balancelist[index]
                                      .usedleave
                                      .split('.')
                                      .first),
                                  backgroundColor: MyColor.mainAppColor,
                                  progressColor: Colors.grey,
                                  minHeight: 3,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: _leavebalance_visi == true
                                          ? false
                                          : true,
                                      child: Text(
                                        "${balance_list[index].usedleave}",
                                        style: TextStyle(
                                            fontFamily: "pop_m",
                                            fontSize: 16,
                                            color: Colors.black38),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _leavebalance_visi,
                                      child: Text(
                                        "${balance_list[index].balance}",
                                        style: TextStyle(
                                            fontFamily: "pop_m",
                                            fontSize: 16,
                                            color: MyColor.mainAppColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _leavebalance_visi = false;
                              });
                              print(_leavebalance_visi);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _leavebalance_visi == true
                                          ? Colors.transparent
                                          : Colors.black38),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "Used",
                                  style: TextStyle(
                                      color: Colors.black38, fontFamily: "pop"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _leavebalance_visi = true;
                              });
                              print(_leavebalance_visi);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _leavebalance_visi == true
                                          ? MyColor.mainAppColor
                                          : Colors.transparent),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "Available",
                                  style: TextStyle(
                                      color: MyColor.mainAppColor,
                                      fontFamily: "pop"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreteLeaveRequest(
                                        self_select: 'Self',
                                      )));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColor.mainAppColor),
                          child: Center(
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  fontFamily: "pop",
                                  fontSize: 16,
                                  color: MyColor.white_color),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
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

  Future<void> updateDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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

  void sendCheckIn_Checkout(String type, String reason, String checkin_from,
      String checkout_from) async {
    //  Navigator.pop(context);
    final ProgressDialog pr = ProgressDialog(context);
    _customProgress('Please wait...');
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
        '$_currentAddress');

    var response =
        await http.post(Uri.parse('${baseurl.url}checkinout'), body: {
      'emp_code': EncryptData.decryptAES(user_emp_code),
      'type': type,
      'ip': current_ip,
      'location': '$_currentAddress',
      'latitude': '${_currentPosition!.latitude}',
      'longitude': '${_currentPosition!.longitude}',
      'country': '$_country_name',
      'reason': reason,
      'checkin_from': checkin_from,
      'checkout_from': checkout_from,
    }, headers: {
      'Authorization': 'Bearer $token'
    });

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      if (jsonObject['status'] == '1') {
        pr.hide();
        setState(() {
          in_out_visi = false;
        });

        Navigator.pop(context);

        _showinoutsucessdailog(jsonObject['time'], type);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else if (jsonObject['status'] == '0') {
        Navigator.pop(context);
        pr.hide();
        _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else if (jsonObject['status'] == 'LateCheckin') {
        checkIn = 0;
        pr.hide();
        Navigator.pop(context);
        check_In_Dialog('In', 'Specify Reason (why are you late today?)');
      } else if (jsonObject['status'] == 'EarlyCheckout') {
        checkOut = 0;
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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  Future<List<BirthdayModel>> getAllBirthData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? e_id = p.getString('e_id');
    String? token = p.getString('user_access_token');
    setState(() {
      leave_group = p.getString('leave_group');
      reported_by = p.getString('reported_by');
      empstatus = p.getString('empstatus');
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
    } else if (response.statusCode == 401) {}
    print("size of birthday    ${birth_data.length}");
    return birth_data;
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
                                  print(_reson_controler.text);

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

  Future<List<BalanceLeaveModel>> getLeaveBalance() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    var response = await http.get(
      Uri.parse("${baseurl.url}leavebalance"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Leave Balance featch ' + response.body);

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);
      if (jsonObject['status'] == '1') {
        balance_list.clear();
        var getJsonArray = jsonObject['leave_details'];
        for (var balanceData in getJsonArray) {
          BalanceLeaveModel leaveModel = BalanceLeaveModel(
            lc_name: balanceData['lc_name'],
            balance: balanceData['balance'],
            usedleave: balanceData['usedleave'],
            totalbalance: balanceData['totalbalance'],
          );

          setState(() {
            balance_list.add(leaveModel);
          });
        }
      } else {}
    } else if (response.statusCode == 401) {}

    return balance_list;
  }

  void check_In_Dialog(String type, String msg) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            //    contentPadding: EdgeInsets.all(20),
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
                            padding: const EdgeInsets.only(left: 0, right: 0),
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
                                            color: Colors.red, fontSize: 14))
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 8),
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
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
                                left: 8, right: 8, top: 24),
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
                              onTap: () async {
                                print(_reson_controler.text);
                                if (_reson_controler.text == '') {
                                  Flushbar(
                                    message: 'Please enter your specify reason',
                                    duration: const Duration(seconds: 1),
                                    flushbarPosition: FlushbarPosition.BOTTOM,
                                  ).show(context);
                                } else {
                                  Navigator.pop(context);
                                  if (await _getCurrentPosition()) {
                                    final Distance distance = new Distance();
                                    final double meter = distance(
                                        new LatLng(lat, long),
                                        new LatLng(28.6247543, 77.3782848));
                                    if (meter < 100.0) {
                                      if (type == 'In') {
                                        sendCheckIn_Checkout(
                                            type,
                                            _reson_controler.text,
                                            'Inside',
                                            '');
                                      } else {
                                        sendCheckIn_Checkout(
                                            type,
                                            _reson_controler.text,
                                            '',
                                            'Inside');
                                      }
                                    } else {
                                      if (type == 'In') {
                                        sendCheckIn_Checkout(
                                            type,
                                            _reson_controler.text,
                                            'Outside',
                                            '');
                                      } else {
                                        sendCheckIn_Checkout(
                                            type,
                                            _reson_controler.text,
                                            '',
                                            'Outside');
                                      }
                                    }
                                  }

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

  void getleavehistory() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    data.clear();
    var response = await http.post(
      Uri.parse("${baseurl.url}leave_request_list"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        // leaverqst_details.clear();
        var jsonarray = jsonObject['data'];
        for (var i in jsonarray) {
          leavelistdetails leavedetails = leavelistdetails(
              ref_no: i['ref_no'],
              leave_code: i['leave_code'],
              from_date: i['from_date'],
              to_date: i['to_date'],
              no_of_days: i['no_of_days'].toString(),
              employee_name: i['employee_name'],
              created_on: i['created_on'],
              lr_status: i['lr_status'],
              leave_planned: i['leave_planned'],
              lr_id: i['lr_id'].toString(),
              reason: i['reason'],
              requesting_type: i['requesting_type']);
          // filter_list.add(leavedetails);
          setState(() {
            data.add(leavedetails);
          });
        }
        print(" length of leave list is ${data.length}");
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
    // return filter_list;
  }

  void sendLogoutRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _customProgress('Please wait...');
    String? id = pref.getString('id');
    String? token = pref.getString('user_access_token');
    String? fcm_token;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      fcm_token = await messaging.getToken();
    } catch (notificationError) {}
    print('TTTOKENNNN $fcm_token');

    var response = await http.post(Uri.parse('${baseurl.url}logout'),
        body: {"fcm_token": "$fcm_token"},
        headers: {'Authorization': 'Bearer $token'});
    print('${response.statusCode}');
    print('${response.body}');

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      await pref.clear();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } else if (response.statusCode == 404) {
      var jsonObject = json.decode(response.body);

      Navigator.pop(context);
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else if (response.statusCode == 500) {
      Navigator.pop(context);
      _showMyDialog(
          'Something went wrong', MyColor.dialog_error_color, 'error');
    }
  }

  Future<void> _refreshitems() async {
    //CallSingInApi();
    // versionUpdate();
    getvalues();
    getCheckIn_OutTime();
    ipGet();
    _getCurrentPosition();
    getAllBirthData();
    getLeaveBalance();
    getAttandanceWorkFlowRequest();
    return await Future.delayed(Duration(seconds: 2));
  }

  void getAttandanceWorkFlowRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? e_id = pref.getString('e_id');
    String? emp_id = pref.getString('emp_id');
    String? token = pref.getString('user_access_token');
    var response =
        await http.post(Uri.parse('${baseurl.url}WorkflowListView'), body: {
      'emp_code': '',
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    print(token);
    print('hiiigwnnjgsfnjgnjskngdsngjdgn');

    var jsonObject = json.decode(response.body);
    print('ff ' + response.body);

    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        var jsonArray = jsonObject['requested_Tasks'];
        work_flow_data.clear();
        for (var flow in jsonArray) {
          Workflow workflow = Workflow(
            //wtxn_id: flow['wtxn_id'],
            wtxn_code: flow['EmpCode'],
            wtxn_requester_emp_name: flow['EmpName'],
            wtxn_request_datetime: flow['AssignDate'],
            ccl_type: flow['Type'],
            ccl_inout_ip: flow['IP'],
            checkio_reason: flow['Reason'],
            wtxn_ref_request_no: flow['ReqNo'],
            emp_photo: flow['Image'],
          );
          req_no_list.add(EncryptData.decryptAES(flow['ReqNo']));

          // flow.add(workflow);

          setState(() {
            work_flow_data.add(workflow);
          });
        }
        print('attendance ${work_flow_data.length}');
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

    print('work flow data ${response.body}');

    // return work_flow_data;
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
/*
*
Leave Balance data





                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Casual Leave",
                        style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  LinearProgressBar(
                    maxSteps: 7,
                    progressType: LinearProgressBar.progressTypeLinear,
                    // Use Dots progress
                    currentStep: 2,
                    backgroundColor: MyColor.mainAppColor,
                    progressColor: Colors.grey,
                    minHeight: 3,
                  ),
                  const SizedBox(
                    height: 4,
                  ),



 Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: _leavebalance_visi == true ? false : true,
                        child: Text(
                          "2 Days",
                          style: TextStyle(
                              fontFamily: "pop_m",
                              fontSize: 16,
                              color: Colors.black38),
                        ),
                      ),
                      Visibility(
                        visible: _leavebalance_visi,
                        child: Text(
                          "5 Days",
                          style: TextStyle(
                              fontFamily: "pop_m",
                              fontSize: 16,
                              color: MyColor.mainAppColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Earn Leave",
                        style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  LinearProgressBar(
                    maxSteps: 15,
                    progressType: LinearProgressBar.progressTypeLinear,
                    // Use Dots progress
                    currentStep: 2,
                    backgroundColor: MyColor.mainAppColor,
                    progressColor: Colors.grey,
                    minHeight: 3,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: _leavebalance_visi == true ? false : true,
                        child: Text(
                          "2 Days",
                          style: TextStyle(
                              fontFamily: "pop_m",
                              fontSize: 16,
                              color: Colors.black38),
                        ),
                      ),
                      Visibility(
                        visible: _leavebalance_visi,
                        child: Text(
                          "13 Days",
                          style: TextStyle(
                              fontFamily: "pop_m",
                              fontSize: 16,
                              color: MyColor.mainAppColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

*
* */
