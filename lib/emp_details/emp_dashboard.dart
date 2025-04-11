import 'dart:convert';
import 'package:demo/Earlygoing_latecoming/emp_EGLC.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/halfday_leave/emp_halfday.dart';
import 'package:demo/new_leave_managerdashboard/manager_leaveworkflow.dart';
import 'package:demo/wfh/emp_wfh.dart';
import 'package:demo/workflow_request_panel/work_flow_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../_login_part/login_activity.dart';
import '../app_color/color_constants.dart';

class EmployeeDetails extends StatefulWidget {
  final String emp_code, name, img;
  const EmployeeDetails(
      {Key? key, required this.emp_code, required this.name, required this.img})
      : super(key: key);

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  String in_time = "";
  String out_time = "";
  String grosstime = "";
  String shift_time = "";
  String totalpresent = '';
  String latecheckin = '';
  String totalleave = '';
  String absent = '';
  String location = '';

  int selectedMonthIndex = DateTime.now().month - 1; // Current month
  int selectedYear = DateTime.now().year; // Current year

  List<String> months = [
    '01 Jan',
    '02 Feb',
    '03 Mar',
    '04 Apr',
    '05 May',
    '06 Jun',
    '07 Jul',
    '08 Aug',
    '09 Sep',
    '10 Oct',
    '11 Nov',
    '12 Dec'
  ];

  //   List<String> months_old = [
  //   '01 January', '02 February', '03 March', '04 April', '05 May', '06 June',
  //   '07 July', '08 August', '09 September', '10 October', '11 November', '12 December'
  // ];

  void getCheckIn_OutTime() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? user_emp_code = pr.getString('user_emp_code');
    String? token = pr.getString('user_access_token');
    print('${token}');
    print(months[selectedMonthIndex].toString().split(" ").first);
    print(selectedYear);
    var response = await http
        .post(Uri.parse('${baseurl.url}WebLog-CheckIn-OutDetails'), body: {
      'emp_code': '${widget.emp_code}',
      'month_number':
          '${months[selectedMonthIndex].toString().split(" ").first}',
      'year': selectedYear.toString(),
    }, headers: {
      'Authorization': 'Bearer $token'
    });

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
          location = jsonObject['location'];
        });
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  @override
  void initState() {
    super.initState();
    getCheckIn_OutTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ))),
                    SizedBox(
                      width: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: ClipOval(
                                child: Image.network(
                                  widget.img,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style:
                                  TextStyle(fontFamily: 'pop_m', fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //this area for checkin and out info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today's Shift",
                                    style: TextStyle(
                                        fontFamily: 'pop_m', fontSize: 14)),
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
                                          Text('${in_time}',
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
                                          Text('${out_time}',
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
                        padding:
                            const EdgeInsets.only(top: 12, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                if (location.isEmpty) ...[
                                  Text(' - -',
                                      style: TextStyle(
                                          fontFamily: 'pop', fontSize: 14))
                                ] else ...[
                                  Text(
                                    '${location.split(' ').first}',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  )
                                ]
                              ],
                            ),
                            Row(
                              children: [
                                Text("Total time - ",
                                    style: TextStyle(
                                        fontFamily: 'pop_m', fontSize: 14)),
                                Text(
                                    '${grosstime.split(':').first} h  ${grosstime.split(':').last} m',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14))
                              ],
                            )
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
                    Container(
                      child: Text("Attendance Analysis",
                          style: TextStyle(fontFamily: 'pop_m', fontSize: 16)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            size: 14,
                          ),
                          onPressed: () {
                            setState(() {
                              if (selectedMonthIndex == 0) {
                                selectedMonthIndex = months.length - 1;
                                selectedYear -= 1;
                              } else {
                                selectedMonthIndex -= 1;
                              }
                            });
                            getCheckIn_OutTime();
                          },
                        ),
                        // Month Selector
                        Text(
                          '${months[selectedMonthIndex].split(' ').last} ${selectedYear.toString()}',
                          style: TextStyle(fontFamily: "pop", fontSize: 14),
                        ),

                        // Next Month Button
                        Visibility(
                          visible: DateFormat("MMM yyyy")
                                      .format(DateTime.now()) ==
                                  '${months[selectedMonthIndex].split(' ').last} ${selectedYear.toString()}'
                              ? false
                              : true,
                          child: IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 14,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedMonthIndex == months.length - 1) {
                                  selectedMonthIndex = 0;
                                  selectedYear += 1;
                                } else {
                                  selectedMonthIndex += 1;
                                }
                              });
                              getCheckIn_OutTime();
                            },
                          ),
                        ),
                      ],
                    )
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
                            height: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      MyColor.new_blue_color.withOpacity(0.2),
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
                                    style: TextStyle(fontFamily: 'pop_m'))
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
                            height: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      MyColor.new_yellow_color.withOpacity(0.2),
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
                                    style: TextStyle(fontFamily: 'pop_m'))
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
                            height: MediaQuery.of(context).size.height * 0.13,
                            padding: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      MyColor.new_red_color.withOpacity(0.2),
                                  child: Text(
                                    "${totalleave}",
                                    style:
                                        TextStyle(color: MyColor.new_red_color),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text("Leave",
                                    style: TextStyle(fontFamily: 'pop_m'))
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
                        style: TextStyle(fontFamily: 'pop_m', fontSize: 16)),
                    Text("", style: TextStyle(fontFamily: 'pop'))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                                            builder: (context) => employee_EGLC(
                                                  emp_code: widget.emp_code,
                                                )));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/new_svgs/Punch.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: MyColor.mainAppColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                                manager_workflow(
                                                  emp_code: widget.emp_code,
                                                )));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/new_svgs/Leave_History.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: MyColor.new_yellow_color),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                My_Work_flow_Request(
                                                  emp_code: widget.emp_code,
                                                )));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/new_svgs/Check_In_Out_1.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: MyColor.new_light_green),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Attendance \n Request',
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
                                            builder: (context) => emp_halfday(
                                                  emp_code: widget.emp_code,
                                                )));
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/new_svgs/half_day.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: MyColor.new_red_color
                                            .withOpacity(0.8)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Halfday \n History ',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    // Padding(
                    //      padding: const EdgeInsets.only(top: 16),
                    //      child: Row(
                    //       children: [
                    //          Flexible(
                    //             child: Container(
                    //           alignment: Alignment.center,
                    //           child: Column(
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {

                    //                 },
                    //                 child: Container(
                    //                   width: 50,
                    //                   height: 50,
                    //                   alignment: Alignment.center,
                    //                   child: SvgPicture.asset(
                    //                     'assets/new_svgs/Punch.svg',
                    //                     height: 25,
                    //                     width: 25,
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.circular(30),
                    //                       color: MyColor.mainAppColor),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 8.0),
                    //                 child: Text(
                    //                   'LC/EG',
                    //                   textAlign: TextAlign.center,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         )),
                    //         Flexible(
                    //             child: Container(
                    //           alignment: Alignment.center,
                    //           child: Column(
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 alignment: Alignment.center,

                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 8.0),

                    //               ),
                    //             ],
                    //           ),
                    //         )),
                    //         Flexible(
                    //             child: Container(
                    //           alignment: Alignment.center,
                    //           child: Column(
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 alignment: Alignment.center,

                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 8.0),

                    //               ),
                    //             ],
                    //           ),
                    //         )),
                    //         Flexible(
                    //             child: Container(
                    //           alignment: Alignment.center,
                    //           child: Column(
                    //             children: [
                    //               Container(
                    //                 width: 50,
                    //                 height: 50,
                    //                 alignment: Alignment.center,

                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 8.0),

                    //               ),
                    //             ],
                    //           ),
                    //         )),

                    //       ],
                    //                            ),
                    //    ),
                  ],
                ),
                //services end here
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    // Assuming you want to show years from 2000 to 2050
    int startYear = 2000;
    int endYear = 2050;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: endYear - startYear + 1,
              itemBuilder: (BuildContext context, int index) {
                int year = startYear + index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    setState(() {
                      selectedYear = year;
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
