import 'dart:convert';
import 'package:demo/Earlygoing_latecoming/EC_LC_main.dart';
 import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EG_LC extends StatefulWidget {
  const EG_LC({super.key});

  @override
  State<EG_LC> createState() => _EG_LCState();
}

class _EG_LCState extends State<EG_LC> {
  var FromedateInput = TextEditingController(text: 'Date');
  TextEditingController _reason = TextEditingController();
  String datevalid = "";
  List<String> request_type = ["Early Going", "Late Coming"];
  String requesttype = "Early Going";
  TimeOfDay selectedTime = TimeOfDay.now();
  String tdata = '';
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                "Early Going/Late Coming Request",
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
              Text("Request Type",
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
                  value: requesttype,
                  isDense: true,
                  isExpanded: true,
                  underline: Container(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: request_type.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      requesttype = value!;
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
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2101)
                                // initialEntryMode: DatePickerEntryMode.calendar,
                                // //DateTime.now() - not to allow to choose before today.
                                // lastDate:
                                //     DateTime.now().subtract(Duration(days: 1)),
                                // firstDate: DateTime(2023),
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
                                  Text(FromedateInput.text),
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
                        Text("$requesttype Time",
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
                    if (validation()) {
                      if (count == 0) {
                        count++;
                        sendrequest();
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

  bool validation() {
    if (FromedateInput.text == 'Date') {
      _showMyDialog('Please Select date', Color(0xFF861F41), 'error');
      return false;
    } else if (selectedTime == Null) {
      _showMyDialog('Please Select time', Color(0xFF861F41), 'error');
      return false;
    } else if (_reason.text.trim() == '') {
      _showMyDialog('Please enter reason', Color(0xFF861F41), 'error');
      return false;
    }

    return true;
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

  void sendrequest() async {
    _customProgress('Please wait...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('user_access_token');
    var response = await http
        .post(Uri.parse('${baseurl.url}late-comming-earyly-going-request'), headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'type': requesttype,
      'date': '${FromedateInput.text}',
      'time': '${selectedTime.hour}:${selectedTime.minute}',
      'reason': _reason.text
    });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonObject = json.decode(response.body);
      if (jsonObject['status'] == '1') {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EGLCDash()));
        _showMyDialog(jsonObject['message'], Colors.green, 'success');
      } else if (jsonObject['status'] == '0') {
        Navigator.of(context).pop();
        count = 0;
        _showMyDialog(jsonObject['message'], Color(0xFF861F41), 'error');
      }
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
}
