import 'dart:convert';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'check_in_out_log_model.dart';

class attendanceanalysis extends StatefulWidget {
  final String late;
  final String present;
  final String absent;

  const attendanceanalysis(
      {super.key,
      required this.late,
      required this.present,
      required this.absent});

  @override
  State<attendanceanalysis> createState() => _attendanceanalysisState();
}

class _attendanceanalysisState extends State<attendanceanalysis> {
  List<CheckIn_OutLogsModel> checkin_out_log_list = [];
  String _selected = DateFormat('MMM yyyy').format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  String late = "", absent = "", total = "", progress = "";
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
  @override
  void initState() {
    callme();
    super.initState();
    getCheckIn_OutLogs();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  Future<void> _selectMonthAndYear(BuildContext context) async {
    DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _selected = DateFormat("MMM yyyy").format(selectedDate);
      });
      getCheckIn_OutLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
                "Attendance Status",
                style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              ),
            ],
          )),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: MyColor.white_color,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  MyColor.new_blue_color.withOpacity(0.2),
                              child: SvgPicture.asset(
                                  "assets/new_svgs/Present.svg"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              total.toString(),
                              style: TextStyle(fontFamily: "pop", fontSize: 16),
                            ),
                            Text(
                              "Present",
                              style: TextStyle(fontFamily: "pop", fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: MyColor.white_color,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  MyColor.new_yellow_color.withOpacity(0.2),
                              child:
                                  SvgPicture.asset("assets/new_svgs/Late.svg"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              late.toString(),
                              style: TextStyle(fontFamily: "pop", fontSize: 16),
                            ),
                            Text(
                              "Late",
                              style: TextStyle(fontFamily: "pop", fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Flexible(
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: MyColor.white_color,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  MyColor.new_red_color.withOpacity(0.2),
                              child: SvgPicture.asset(
                                  "assets/new_svgs/Absent.svg"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              absent.toString(),
                              style: TextStyle(fontFamily: "pop", fontSize: 16),
                            ),
                            Text(
                              "Absent",
                              style: TextStyle(fontFamily: "pop", fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text("Attendance Log",
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
                        getCheckIn_OutLogs();
                      },
                    ),
                    // Month Selector
                    Text(
                      '${months[selectedMonthIndex].split(' ').last} ${selectedYear.toString()}',
                      style: TextStyle(fontFamily: "pop", fontSize: 14),
                    ),

                    // Next Month Button
                    Visibility(
                      visible: DateFormat("MMM yyyy").format(DateTime.now()) ==
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
                          getCheckIn_OutLogs();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(12)),
                        color: MyColor.mainAppColor),
                    child: Text(
                      "Date",
                      style: TextStyle(
                          color: MyColor.white_color,
                          fontFamily: "pop",
                          fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(0)),
                        color: MyColor.mainAppColor),
                    child: Text(
                      "Status",
                      style: TextStyle(
                          color: MyColor.white_color,
                          fontFamily: "pop",
                          fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(0)),
                        color: MyColor.mainAppColor),
                    child: Text(
                      "Check In",
                      style: TextStyle(
                          color: MyColor.white_color,
                          fontFamily: "pop",
                          fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(12)),
                        color: MyColor.mainAppColor),
                    child: Text(
                      "Check Out",
                      style: TextStyle(
                          color: MyColor.white_color,
                          fontFamily: "pop",
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (progress == '')
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: MyColor.mainAppColor,
                )),
              )
            else if (checkin_out_log_list.length == 0) ...[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svgs/no_data_found.svg'),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'No data found',
                        style: TextStyle(
                            color: MyColor.mainAppColor,
                            fontSize: 16,
                            fontFamily: 'pop'),
                      ),
                    )
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                    itemCount: checkin_out_log_list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          color: MyColor.grey_color.withOpacity(0.2),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${checkin_out_log_list[index].checkindate}",
                                    style: TextStyle(
                                        fontFamily: "pop", fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text(
                                      "${checkin_out_log_list[index].attstatus}",
                                      style: TextStyle(
                                          fontFamily: "pop",
                                          fontSize: 12,
                                          color: checkin_out_log_list[index]
                                                      .attstatus ==
                                                  'Present'
                                              ? MyColor.yellow_color
                                              : MyColor.green_color)),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text(
                                      "${checkin_out_log_list[index].checkintime.split(':').first} : ${checkin_out_log_list[index].checkintime.split(':').last}",
                                      style: TextStyle(
                                          fontFamily: "pop", fontSize: 12)),
                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text(
                                      "${checkin_out_log_list[index].checkouttime.split(':').first} : ${checkin_out_log_list[index].checkouttime.split(':').last}",
                                      style: TextStyle(
                                          fontFamily: "pop", fontSize: 12)),
                                ),
                              )
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
    );
  }

  Future<List<CheckIn_OutLogsModel>> getCheckIn_OutLogs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? user_emp_code = pref.getString('user_emp_code');
    String? token = pref.getString('user_access_token');
    print(months[selectedMonthIndex].toString().split(" ").first);
    print(selectedYear);
    var response =
        await http.post(Uri.parse('${baseurl.url}attendacelog'), body: {
      'month_number':
          '${months[selectedMonthIndex].toString().split(" ").first}',
      'year': selectedYear.toString()
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    checkin_out_log_list.clear();
    print('Attandance Log ' + response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      if (jsonObject['status'] == '1') {
        // checkin_out_log_list.clear();
        var checkInArray = jsonObject['data'];
        setState(() {
          total = jsonObject['totalattendance'];
          late = jsonObject['latecheckin'];
          absent = jsonObject['absent'];
        });

        for (var logs in checkInArray) {
          CheckIn_OutLogsModel logsModel = CheckIn_OutLogsModel(
              checkintime: logs['checkintime'],
              checkouttime: logs['checkouttime'],
              checkindate: logs['checkindate'],
              attstatus: logs['attstatus']);

          setState(() {
            checkin_out_log_list.add(logsModel);
          });
        }
      } else {
        setState(() {
          checkin_out_log_list == [];
          setState(() {
            total = jsonObject['totalattendance'];
            late = jsonObject['latecheckin'];
            absent = jsonObject['absent'];
          });
        });
      }
    } else if (response.statusCode == 401) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } else if (response.statusCode == 500) {
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    }

    return checkin_out_log_list;
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
