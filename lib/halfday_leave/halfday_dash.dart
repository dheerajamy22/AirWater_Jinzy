import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/halfday_leave/haldaymethod.dart';
import 'package:demo/leave_process/employee_name_method.dart';
import 'package:demo/leave_process/leave_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class halfdayDash extends StatefulWidget {
  const halfdayDash({super.key});

  @override
  State<halfdayDash> createState() => _halfdayDashState();
}

class _halfdayDashState extends State<halfdayDash> {
  List<haldaylist> halfdaylist = [];
  TextEditingController _reason = TextEditingController();
  String no_of_wfhdays = '';
  String datevalid = "";
  bool is_true = false;
  String emp_code = "", leave_code_id = "";
  var _countries = [];
  List<LeaveTypeModule> leaveTypeList = [];
  bool submit_visi = false, leave_balance_visi = false;
  String? leavecode;
  String leave_balance = "", rejoining_date = "", documentvalid = "";
  int count = 0;
  List<String> halfday_type = ["Pre Lunch", "Post Lunch"];
  String selected_haldaytype = "Pre Lunch";
  String? halfdayallowed;

  RadioGroupController myController = RadioGroupController();
  TextEditingController dateInput = TextEditingController();
  String? team_emp_name;
  var team_names = [];
  String? emp_id;
  String? reported;
  String name = "";
  String progress = "";
  List<emp_name> employee_names = [];
  bool isCountrySelected = false;

  getemplist(String type) async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? token = pr.getString('user_access_token');
    print('${token}');
    reported = pr.getString('reported_by');

    setState(() {
      name = EncryptData.decryptAES(pr.getString('user_name')!);
    });
    var response = await http.post(Uri.parse("${baseurl.url}employee-details"),
        headers: {'Authorization': 'Bearer $token'},
        body: {"req_type": 'Onbehalf'});

    print('fghj ${response.body}');
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      team_names.clear();
      if (jsonObject['status'] == "1") {
        var jsonarray = jsonObject['subordinates'];
        setState(() {
          team_names = jsonObject['subordinates'];
        });
        for (var details in jsonarray) {
          emp_name employee_details = emp_name(
              name: details['emp_name'], id: details['emp_id'].toString());
          setState(() {
            employee_names.add(employee_details);
          });
        }
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  @override
  void initState() {
    // callme();
    getleavecode();
    getlist();
    getemplist("Onbehalf");
    //s
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
                "Halfday Request",
                style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              ),
            ],
          )),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Column(
            children: [
              if (progress == '')
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: MyColor.mainAppColor,
                  )),
                )
              else if (halfdaylist.length == 0) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/svgs/no_data_found.svg"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'No data',
                          style: TextStyle(fontSize: 18, fontFamily: 'pop_m'),
                        )
                      ],
                    ),
                  ),
                )
              ] else ...[
                Expanded(
                  child: ListView.builder(
                      itemCount: halfdaylist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shadowColor: MyColor.mainAppColor,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: MyColor.new_red_color
                                          .withOpacity(0.8),
                                      radius: 25,
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/half_day.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "Date:- ${halfdaylist[index].date}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'pop'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${halfdaylist[index].leave_code}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                              Text(
                                                '${halfdaylist[index].lr_status}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text("Date:- ${halfdaylist[index].date}",
                                //         style: TextStyle(
                                //             fontFamily: "pop", fontSize: 14)),
                                //     Text("${halfdaylist[index].lr_status}",
                                //         style: TextStyle(
                                //             fontFamily: "pop", fontSize: 14)),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 4,
                                // ),
                                // Text("Type:- ${halfdaylist[index].type}",
                                //     style: TextStyle(
                                //         fontFamily: "pop", fontSize: 14)),
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
                                Text("Reason:-"),
                                Text(halfdaylist[index].reason,
                                    style: TextStyle(
                                        fontFamily: "pop", fontSize: 14))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ]
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showhalfdaydailog("Self");
        },
        child: Icon(
          Icons.add,
          color: MyColor.white_color,
        ),
        backgroundColor: MyColor.mainAppColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void getlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('user_access_token')!;
    halfdaylist.clear();
    var response = await http.get(
      Uri.parse('${baseurl.url}half-day-leave-request-list'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        progress = '1';
      });
      var jsonobject = jsonDecode(response.body);
      if (jsonobject['status'] == "1") {
        var jsonarray = jsonobject['data'];
        for (var i in jsonarray) {
          haldaylist list = haldaylist(
              requesting_type: i['requesting_type'],
              employee_name: i['employee_name'],
              date: i['date'],
              type: "",
              reason: i['reason'],
              lr_id: i['lr_id'],
              lr_status: i['lr_status'],
              leave_code: i['leave_code']);
          setState(() {
            halfdaylist.add(list);
          });
        }
      }
    } else if (response.statusCode == 401) {
      setState(() {
        progress = '1';
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } else if (response.statusCode == 500) {
      setState(() {
        progress = '1';
      });
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    } else if (response.statusCode == 404) {
      setState(() {
        progress = '1';
      });
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    }
  }

  void _showhalfdaydailog(String Type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (Type == "Self") {
      emp_id = EncryptData.decryptAES(preferences.getString('user_id')!);
      print("id is ${emp_id.toString()}");
    }
    no_of_wfhdays = "";
    showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              insetPadding: const EdgeInsets.only(left: 20, right: 20),
              contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 20),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              scrollable: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  ),
                  if (Type != 'Self') ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.06,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton<String>(
                          underline: Container(),
                          hint: Text("Select employee"),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isDense: true,
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          items: team_names.map((emp) {
                            return DropdownMenuItem<String>(
                                value: emp["emp_name"].toString(),
                                child: Text(emp["emp_name"].toString()));
                          }).toList(),
                          value: team_emp_name,
                          onChanged: (value) {
                            setState(() {
                              team_emp_name = value!;
                              // print('dropDownId ' + "YDH");

                              for (int i = 0; i < team_names.length; i++) {
                                if (team_names[i]["emp_name"] == value) {
                                  emp_id = team_names[i]["emp_id"].toString();
                                  print("vxjvjvcjhcvj  $team_emp_name");
                                  print('dropDownId ' + emp_id.toString());
                                }
                              }
                              // isCountrySelected = true;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Trans Date",
                                style: TextStyle(
                                    fontFamily: "pop_m", fontSize: 16)),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: TextField(
                                            controller: dateInput,
                                            //editing controller of this TextField
                                            decoration: const InputDecoration(
                                                focusedBorder: InputBorder.none,
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xFF0054A4),
                                                ),
                                                //icon of text field
                                                hintText: "From date",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "pop",
                                                    fontSize: 14)
                                              //label text of field
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'pop'),
                                            readOnly: true,
                                            onTap: () async {
                                              if (leave_code_id == '') {
                                                _showMyDialog('Please Select leave Code',
                                                    const Color(0xFF861F41), 'error');
                                              } else {
                                                DateTime? pickedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate:  DateTime.now(),
                                                    firstDate:  DateTime.now(),
                                                    lastDate: DateTime(2100));

                                                if (pickedDate != null) {
                                                  print(
                                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                  String formattedDate =
                                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                                                  print(
                                                      formattedDate); //formatted date output using intl package =>  2021-03-16

                                                  setState(() {
                                                   dateInput.text = formattedDate;

                                                  });
                                                } else {}
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      /*Text(DateTime.now()
                                          .toString()
                                          .split(" ")
                                          .first),
                                      Icon(Icons.calendar_month)*/
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RadioGroup(
                        controller: myController,
                        values: ["Pre-lunch", "Post-lunch"],
                        indexOfDefault: 0,
                        orientation: RadioGroupOrientation.horizontal,
                        decoration: RadioGroupDecoration(
                          spacing: 10.0,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          activeColor: MyColor.mainAppColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 52,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: DropdownButton<String>(
                          underline: Container(),
                          hint: const Text("Select Leave Code"),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: "pop",
                              fontSize: 14),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isDense: true,
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          items: _countries.map((ctry) {
                            return DropdownMenuItem<String>(
                                value: '${ctry["lc_code"]}',
                                child: Text('${ctry["lc_code"]}'));
                          }).toList(),
                          value: leavecode,
                          onChanged: submit_visi == true
                              ? null
                              : (value) {
                                  setState(() {
                                    leave_balance_visi = true;
                                    leavecode = value!;
                                    for (int i = 0;
                                        i < _countries.length;
                                        i++) {
                                      if (_countries[i]["lc_code"] == value) {
                                        if(_countries[i]['halfdayallowed']=="No"){
                                          _showMyDialog('This leave code cannot be used for a half day.',
                                              MyColor.dialog_error_color, 'error');
                                          leavecode=null;
                                        }else{
                                          halfdayallowed =
                                          _countries[i]['halfdayallowed'];
                                          leave_code_id =
                                              _countries[i]["lc_code"].toString();
                                          leave_balance =
                                          _countries[i]['balance'];
                                          print("balance $leave_balance");
                                          datevalid = _countries[i]['Validation'];
                                          documentvalid =
                                          _countries[i]['document'];


                                        }

                                      }
                                    }
                                    isCountrySelected = true;
                                  });
                                }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      controller: _reason,
                      decoration: const InputDecoration(
                        // labelText: 'Description',
                        border: InputBorder.none,
                        hintText: 'Reason..',
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (vaidation()) {
                          Navigator.pop(context);
                          // _customProgress('Please wait...');
                          sendhalfdayRequest(Type,'${dateInput.text}');
                        }
                        // Navigator.pop(context);
                        // String selected = myController.value.toString();
                        // print("select type $selected");
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
            );
          });
        });
  }

  Future<List<LeaveTypeModule>> getleavecode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');

    // emp_code = EncryptData.decryptAES(preferences.getString('emp_code')!);
    print("insan ke id $emp_code");

    var response =
        await http.post(Uri.parse('${baseurl.url}getleavecode'), headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'emp_id': EncryptData.decryptAES(preferences.getString('user_emp_code')!),
    });
    print("code ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['leave_details'];

        setState(() {
          _countries = jsonData['leave_details'];
        });

        print('count$_countries');
        for (var leaveType in jsonArray) {
          LeaveTypeModule leaveTypeModule = LeaveTypeModule(
              lc_id: leaveType['lc_id'].toString(),
              lc_name: leaveType['lc_name'],
              halfdayallowed: leaveType['halfdayallowed'],
              balance: leaveType['balance']);

          leaveTypeList.add(leaveTypeModule);
        }
      }
    } else if (response.statusCode == 401) {
      print('leave type code ${response.body}');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

    return leaveTypeList;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool vaidation() {
    if (dateInput.text.trim().toString()== '') {
      _showMyDialog('Please select trans date', Color(0xFF861F41), 'error');
      return false;
    }if (leavecode== null) {
      _showMyDialog('Please select leave code', Color(0xFF861F41), 'error');
      return false;
    } if (_reason.text.trim().toString() == '') {
      _showMyDialog('Please Enter reason', Color(0xFF861F41), 'error');
      return false;
    }
    return true;
  }

  void sendhalfdayRequest(String type,String date) async {
    _customProgress('Please wait...');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');

    print(
        " reason ${_reason.text}  req_type $type  , type ${myController.value.toString()}");
    var response = await http.post(
      Uri.parse('${baseurl.url}half-day-leave-request'),
      body: {
        'req_type': type,
        'type': myController.value.toString(),
        'reason': '${_reason.text}',
        'lrequester_id': emp_id,
        'leave_code': leavecode,
        'date': "$date"
      },
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {


      if (jsonObject['status'] == '1') {
        Navigator.pop(context);
        _reason.clear();
        dateInput.clear();
        leavecode=null;
        _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
        getlist();
      } else if (jsonObject['status'] == '0') {
        _reason.clear();
        dateInput.clear();
        leavecode=null;
        Navigator.pop(context);
        _reason.clear();
        _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');
      }
    } else if (response.statusCode == 422) {
      Navigator.pop(context);

      _reason.clear();
      dateInput.clear();
      leavecode=null;
      _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');
    }else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  Future<void> _showMyDialog(
      String msg, Color color_dynamic, String success) async {
    /*   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    ));*/
    Flushbar(
      message: '${msg}',
      duration: Duration(seconds: 3),
      // Add more styling here
      backgroundColor: color_dynamic, // Example color
      //borderRadius: 8.0, // Example border radius
      margin: EdgeInsets.all(16.0), // Example margin
      padding: EdgeInsets.symmetric(
          horizontal: 24.0, vertical: 12.0), // Example padding

      icon: success == 'success'
          ? Icon(
              Icons.check,
              color: MyColor.white_color,
            )
          : Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
    ).show(context);
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
