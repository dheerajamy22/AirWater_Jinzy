import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../_login_part/login_activity.dart';
import '../app_color/color_constants.dart';
import '../baseurl/base_url.dart';
import '../new_dashboard_2024/updated_dashboard_2024.dart';

class CreateOvertimeRequest extends StatefulWidget {
  const CreateOvertimeRequest({super.key});

  @override
  State<CreateOvertimeRequest> createState() => _CreateOvertimeRequestState();
}

class _CreateOvertimeRequestState extends State<CreateOvertimeRequest> {
  TextEditingController OverTimedateInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  bool check_status = true;
  String shiftTiming = "",
      dayType = "",
      checkIn = "",
      checkOut = "",
      totalOverTime = "",
      finalFormateOverTimeDate = "";
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  int count = 0;

  /*Future<void> pickTime({required bool isFrom}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }*/

  Future<void> pickTime({required bool isFrom}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    if (fromTime != null && toTime != null) {
      final difference = getTimeDifference(fromTime!, toTime!);
      setState(() {
        totalOverTime =
            'Total Time: ${difference.inHours}:${difference.inMinutes % 60}';
      });
    }
    return "$hour:$minute";
  }

  Duration getTimeDifference(TimeOfDay from, TimeOfDay to) {
    final now = DateTime.now();
    final fromDateTime =
        DateTime(now.year, now.month, now.day, from.hour, from.minute);
    final toDateTime =
        DateTime(now.year, now.month, now.day, to.hour, to.minute);
    final adjustedToDateTime = toDateTime.isBefore(fromDateTime)
        ? toDateTime.add(Duration(days: 1))
        : toDateTime;

    return adjustedToDateTime.difference(fromDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF0054A4),
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: const Icon(
          //       Icons.arrow_back,
          //       color: MyColor.white_color,
          //     )),
          title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

               Row(
                 children: [
                    GestureDetector(
                      onTap: () {
                         Navigator.of(context).pop();
                      },
                      child: Icon(
                      Icons.arrow_back,
                      color: MyColor.white_color,
                                   ),
                    ),

                                  Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    'Overtime Request',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                        color: MyColor.white_color),
                  )),
                 ],
               ),
             
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Overtime Date',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'pop_m',
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: OverTimedateInput,
                    //editing controller of this TextField
                    decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF0054A4),
                        ),
                        //icon of text field
                        hintText: "Overtime date",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: "pop", fontSize: 14)
                        //label text of field
                        ),
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16, fontFamily: 'pop'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(const Duration(days: 1)),
                        initialEntryMode: DatePickerEntryMode.calendar,
                        //DateTime.now() - not to allow to choose before today.
                        lastDate:
                            DateTime.now().subtract(const Duration(days: 1)),
                        firstDate: DateTime(2023),
                      );

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        String finalFormate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        fetchOverTimeRequest(
                            finalFormate); //formatted date output using intl package =>  2021-03-16

                        setState(() {
                          OverTimedateInput.text = formattedDate;
                          finalFormateOverTimeDate = finalFormate;
                        });
                      } else {}
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Visibility(
                  visible: check_status,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Shift Timing',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 12, bottom: 12),
                                      child: Text(
                                        '$shiftTiming',
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      )),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Day Type',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 12, bottom: 12),
                                      child: Text(
                                        '$dayType',
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      )),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Check in',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  // height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 12, bottom: 12),
                                      child: Text(
                                        '$checkIn',
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      )),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Check out',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  // height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 12, bottom: 12),
                                      child: Text(
                                        '$checkOut',
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      )),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'From',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  // height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 12, bottom: 12),
                                    child: InkWell(
                                      onTap: () => pickTime(isFrom: true),
                                      child: Text(
                                        formatTimeOfDay(fromTime),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'To',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'pop_m',
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  // height: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF0054A4)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 12, bottom: 12),
                                    child: InkWell(
                                      onTap: () => pickTime(isFrom: false),
                                      child: Text(
                                        formatTimeOfDay(toTime),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if (fromTime != null && toTime != null) ...[
                        Text("$totalOverTime",
                            style:
                                TextStyle(fontFamily: "pop_m", fontSize: 16)),
                      ],
                      SizedBox(
                        height: 8,
                      ),
                      const Text("Explanation for Overtime",
                          style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0054A4)),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          controller: descriptionInput,
                          decoration: const InputDecoration(
                              // labelText: 'Description',
                              border: InputBorder.none,
                              hintText: 'Enter description',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "pop",
                                  fontSize: 14)),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF0054A4)),
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'pop_m'),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (validation()) {
                            sendOverTimeRequest();
                          }
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (fromTime == null && toTime == null) {
      _showMyDialog(
          "Please select over time", MyColor.dialog_error_color, 'errror');
      return false;
    } else if (descriptionInput.text.toString().trim() == "") {
      _showMyDialog("Please enter explanation for overtime",
          MyColor.dialog_error_color, 'errror');
      return false;
    }

    return true;
  }

  void fetchOverTimeRequest(String overtime_date) async {
    _customProgress('Please wait...');

    print('ooo ${overtime_date.split(" ").first}');
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString('user_access_token');

    var response = await http.post(
        Uri.parse('http://jinzyairwater.kefify.com/api/mobile/shift-details'),
        body: {
          'overtime_date': '${overtime_date.split(" ").first}'
        },
        headers: {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2ppbnp5YWlyd2F0ZXIua2VmaWZ5LmNvbS9hcGkvbW9iaWxlL2xvZ2luIiwiaWF0IjoxNzQ0MDg0Nzk5LCJuYmYiOjE3NDQwODQ3OTksImp0aSI6InUyb0h4eFVjdWR3Z3RhSHYiLCJzdWIiOiI4NSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.rd_QsZUiz-WQdBprUwGBtwie2iYf_AHi7QHwvuA_d84'
        });

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      if (jsonObject['status'] == '1') {
        Navigator.pop(context);
        setState(() {
          checkIn = jsonObject['checkin_time'] ?? '';
          checkOut = jsonObject['checkout_time'] ?? '';
          dayType = jsonObject['workcal_day_type'] ?? '';
          shiftTiming =
              '${jsonObject['shiftCheckintime'] ?? ''}-${jsonObject['shiftCheckouttime'] ?? ''}';
          String? timeString = jsonObject['shiftCheckouttime'];
          if (timeString != null && timeString.isNotEmpty) {
            List<String> parts = timeString.split(":");
            if (parts.length >= 2) {
              fromTime = TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            }
          }
        });
      } else if (jsonObject['status'] == '0') {
        Navigator.pop(context);
        count = 0;
        _showMyDialog(jsonObject['message'], const Color(0xFF861F41), 'error');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else {
        count = 0;
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  void sendOverTimeRequest() async {
    _customProgress('Please wait...');

    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString('user_access_token');
    print('bol ${finalFormateOverTimeDate.split(" ").first}');

    var response = await http.post(
        Uri.parse(
            '${baseurl.url}overtime-request'),
        body: {
          'overtime_date': '${finalFormateOverTimeDate.split(" ").first}',
          'from_time': fromTime != null ? formatTimeOfDay(fromTime!) : '',
          'to_time': toTime != null ? formatTimeOfDay(toTime!) : '',
          'overtime_explanation': '${descriptionInput.text}'
        },
        headers: {
          'Authorization':
              'Bearer $token'
        });
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        Navigator.pop(context);
        _showMyDialog(jsonObject['message'], MyColor.green_color, 'success');
        Navigator.of(context)
        .push(MaterialPageRoute(builder: (context)=>new upcoming_dash()));
      }
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Login_Activity()));
    } else if (response.statusCode == 400) {
      Navigator.pop(context);
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else if (response.statusCode == 422) {
      Navigator.pop(context);
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else {
      Navigator.pop(context);
      _showMyDialog(
          'Something went wrong', MyColor.dialog_error_color, 'error');
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
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      msg,
                      style: const TextStyle(
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
      String msg, Color colorDynamic, String success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          if (success == 'success') ...[
            const Icon(
              Icons.check,
              color: MyColor.white_color,
            ),
          ] else ...[
            const Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
          ],
          const SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            msg,
            style: const TextStyle(color: MyColor.white_color),
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: colorDynamic,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
    ));
  }
}
