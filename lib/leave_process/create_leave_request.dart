import 'dart:convert';
import 'dart:io';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/leave_process/create_leave_api_services.dart';
import 'package:demo/leave_process/employee_name_method.dart';
import 'package:demo/leave_process/leave_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CreteLeaveRequest extends StatefulWidget {
  final String self_select;

  const CreteLeaveRequest({super.key, required this.self_select});

  @override
  _CreteLeaveRequestState createState() => _CreteLeaveRequestState();
}

class _CreteLeaveRequestState extends State<CreteLeaveRequest> {
  List<LeaveTypeModule> leaveTypeList = [];
  final _LeaveServices = Create_Leave_ApiServices();
  LeaveTypeModule? module;
  List<XFile> selecteMultiImagesList = <XFile>[];
  List<String> rejoiningDateArray=[];
  var _countries = [];
  var team_names = [];
  File? image_file;
  String _image_name = "";
  String? country;
  String? team_emp_name;
  bool isCountrySelected = false;
  String emp_code = "", leave_code_id = "";
  int no_of_leave = 0;
  String leave_balance = "", datevalid = "",rejoining_date="",documentvalid="";
  List<String> rqst_type = ["Self", "Onbehalf"];
  String leave_behalf = "Self";
  String name = "";
  List<String> leave_planned = ["Planned Leave", "Unplanned Leave", "Both"];
  String? leave_plan;
  bool submit_visi = false, leave_balance_visi = false;
  int? leave_creation_id;
  int? mindays, maxdays;
  String? reported;
  // List<String> Annual_Leave = ["Short Leave", "Long Leave"];
  // String? annualLeave;

  Future<List<LeaveTypeModule>> getAllLeaveList() async {
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
              balance: leaveType['balance']);

          leaveTypeList.add(leaveTypeModule);
        }
      }
    } else if (response.statusCode == 401) {
      print('leave type code ${response.body}');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  Login_Activity()));
    }

    return leaveTypeList;
  }

  TextEditingController FromedateInput = TextEditingController();
  TextEditingController TodateInput = TextEditingController();
  TextEditingController RejoiningDate = TextEditingController();
  TextEditingController AddressInput = TextEditingController();
  // TextEditingController VisitingCountryInput = TextEditingController();
  TextEditingController Contract1Input = TextEditingController();
  // TextEditingController Contract2Input = TextEditingController();
  // TextEditingController VistingCountryContact1Input = TextEditingController();
  // TextEditingController VistingCountryContact2Input = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  bool isEmptyFromDate = false,
      isEmptyToDate = false,
      isEmptydescription = false,
      is_true = false;
  List<emp_name> employee_names = [];

  getlist(String type) async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? token = pr.getString('user_access_token');
    print('$token');
    reported = pr.getString('reported_by');

    setState(() {
      name = EncryptData.decryptAES(pr.getString('user_name')!);
    });
    var response = await http.post(
        Uri.parse("${baseurl.url}leaverequest_emp_details"),
        headers: {'Authorization': 'Bearer $token'},
        body: {"req_type": type});

    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      team_names.clear();
      if (jsonObject['status'] == "1") {
        var jsonarray = jsonObject['subordinates'];
        setState(() {
          team_names = jsonObject['subordinates'];
        });
        for (var details in jsonarray) {
          emp_name employeeDetails = emp_name(
              name: details['emp_name'], id: details['emp_id'].toString());
          setState(() {
            employee_names.add(employeeDetails);
          });
        }
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  Login_Activity()));
    }
  }

  @override
  void initState() {
    getAllLeaveList();
    leave_behalf = widget.self_select;
    print('Check status $leave_behalf');
    // getlist("Onbehalf"); //set the initial value of text field
    super.initState();
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
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: MyColor.white_color,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: const Text(
                    'Create Leave',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                        color: MyColor.white_color),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
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
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (widget.self_select != 'Self') ...[
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 0.06,
              //     alignment: Alignment.centerLeft,
              //     padding: const EdgeInsets.only(left: 8, right: 8),
              //     decoration: BoxDecoration(
              //         border: Border.all(color: MyColor.mainAppColor),
              //         borderRadius: BorderRadius.circular(5)),
              //     child: DropdownButton<String>(
              //         underline: Container(),
              //         hint: Text("Select employee"),
              //         icon: const Icon(Icons.keyboard_arrow_down),
              //         isDense: true,
              //         isExpanded: true,
              //         alignment: Alignment.centerLeft,
              //         items: team_names.map((ctry) {
              //           return DropdownMenuItem<String>(
              //               value: ctry["emp_name"].toString(),
              //               child: Text(ctry["emp_name"].toString()));
              //         }).toList(),
              //         value: team_emp_name,
              //         onChanged: (value) {
              //           setState(() {
              //             team_emp_name = value!;
              //             // print('dropDownId ' + "YDH");

              //             for (int i = 0; i < team_names.length; i++) {
              //               if (team_names[i]["emp_name"] == value) {
              //                 emp_id = team_names[i]["emp_id"].toString();
              //                 print("vxjvjvcjhcvj  $team_emp_name");
              //                 print('dropDownId ' + emp_id.toString());
              //               }
              //             }
              //             // isCountrySelected = true;
              //           });
              //         }),
              //   ),
              //   const SizedBox(
              //     height: 16,
              //   ),
              // ],

              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height * 0.06,
              //   alignment: Alignment.centerLeft,
              //   padding: const EdgeInsets.only(left: 8, right: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: MyColor.mainAppColor),
              //       borderRadius: BorderRadius.circular(5)),
              //   child: DropdownButton(
              //     value: leave_plan,
              //     hint: const Text("Requesting Type"),
              //     isDense: true,
              //     isExpanded: true,
              //     underline: Container(),
              //     icon: const Icon(Icons.keyboard_arrow_down),
              //     items: leave_planned.map((String items) {
              //       return DropdownMenuItem(
              //         value: items,
              //         child: Text(items),
              //       );
              //     }).toList(),
              //     // After selecting the desired option,it will
              //     // change button value to selected value
              //     onChanged: submit_visi == true
              //         ? null
              //         : (String? newValue) {
              //             setState(() {
              //               country = null;
              //               leave_plan = newValue!;
              //               print(leave_plan);
              //               getAllLeaveList();
              //             });
              //           },
              //   ),
              // ),
              Container(
                height: 52,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0054A4)),
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
                          color: Colors.grey, fontFamily: "pop", fontSize: 14),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      alignment: Alignment.centerLeft,
                      items: _countries.map((ctry) {
                        return DropdownMenuItem<String>(
                            value: '${ctry["lc_code"]}',
                            child: Text('${ctry["lc_code"]}'));
                      }).toList(),
                      value: country,
                      onChanged: submit_visi == true
                          ? null
                          : (value) {
                              setState(() {

                                leave_balance_visi = true;
                                country = value!;
                                for (int i = 0; i < _countries.length; i++) {
                                  if (_countries[i]["lc_code"] == value) {
                                    leave_code_id =
                                        _countries[i]["lc_code"].toString();
                                    print("leave code $leave_code_id");
                                    leave_balance = _countries[i]['balance'];
                                    print("balance $leave_balance");
                                    datevalid = _countries[i]['Validation'];
                                    documentvalid = _countries[i]['document'];
                                    mindays = _countries[i]['minimum_allowed'];
                                    maxdays = _countries[i]['maximum_allowed'];
                                    print('dropDownId $emp_code');
                                    print('dropDownId $leave_balance');
                                    print('maxdays $maxdays');
                                  }
                                }
                                isCountrySelected = true;
                                if(documentvalid!="Yes"){
                                  selecteMultiImagesList.clear();
                                }
                              });
                            }),
                ),
              ),

              Visibility(
                  visible: leave_balance_visi,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                    ),
                    child: Text(
                      'Total leave balance:- $leave_balance',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop_m',
                          color: MyColor.mainAppColor),
                    ),
                  )),
              // const SizedBox(
              //   height: 16,
              // ),

              // Visibility(
              //   visible: leave_code_id == "AL" ? true : false,
              //   child: Container(
              //     height: 52,
              //     alignment: Alignment.centerLeft,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFF0054A4)),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //         left: 10,
              //         right: 10,
              //       ),
              //       child: DropdownButton<String>(
              //           underline: Container(),
              //           hint: const Text("Select Annual Leave Type"),
              //           style: const TextStyle(
              //               color: Colors.grey,
              //               fontFamily: "pop",
              //               fontSize: 14),
              //           icon: const Icon(Icons.keyboard_arrow_down),
              //           isDense: true,
              //           isExpanded: true,
              //           alignment: Alignment.centerLeft,
              //           items: Annual_Leave.map((type) {
              //             return DropdownMenuItem<String>(
              //                 value: type, child: Text(type));
              //           }).toList(),
              //           value: annualLeave,
              //           onChanged: (value) {
              //             setState(() {
              //               annualLeave = value!;
              //             });
              //           }),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0054A4)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: FromedateInput,
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
                              _showMyDialog(
                                  'Please Select leave Code', const Color(0xFF861F41), 'error');
                            }else{
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: TodateInput == ""
                                      ? DateTime.parse(TodateInput.text)
                                      : DateTime.now(),
                                  firstDate: datevalid == "Yes"
                                      ? DateTime(2000)
                                      : DateTime.now(),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: TodateInput == ""
                                      ? DateTime.parse(TodateInput.text)
                                      : DateTime(2100));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16

                                setState(() {
                                  FromedateInput.text = formattedDate;
                                  if (FromedateInput.text != '' &&
                                      TodateInput.text != '') {
                                    int noOfDay = daysBetween(
                                        DateTime.parse(FromedateInput.text),
                                        DateTime.parse(TodateInput.text)) +
                                        1;
                                    is_true = true;
                                    no_of_leave = noOfDay;

                                    print('number of leave $noOfDay');
                                  } //set output date to TextField value.
                                });
                              } else {}
                            }

                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0054A4)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: TodateInput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0xFF0054A4),
                              ),
                              //icon of text field
                              hintText: "To date",
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
                            if (FromedateInput.text == "") {
                              _showMyDialog('Please Select From Date First',
                                  const Color(0xFF861F41), 'error');
                            } else {
                              String startDate = '';
                              if (FromedateInput.text == '') {
                                startDate = DateTime.now().toString();
                              } else {
                                startDate = FromedateInput.text;
                              }
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(startDate),
                                  firstDate: DateTime.parse(startDate),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                countdays();
                                setState(() {
                                  TodateInput.text = formattedDate;
                                  //set output date to TextField value.
                                  if (FromedateInput.text != '' &&
                                      TodateInput.text != '') {
                                    // int no_of_day = daysBetween(
                                    //         DateTime.parse(FromedateInput.text),
                                    //         DateTime.parse(TodateInput.text)) +
                                    //     1;
                                    is_true = true;
                                    // no_of_leave = no_of_day.toString();
                                    // print('Number of leave ' +
                                    //     no_of_day.toString());
                                  }
                                });
                              } else {}
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: is_true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                    ),
                    child: Text(
                      'Total leave days:- $no_of_leave',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop_m',
                          color: MyColor.mainAppColor),
                    ),
                  )),

              // leave description here
              // Padding(
              //   padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 16.0),
              //   child: TextField(
              //     controller: descriptionInput,
              //     decoration: InputDecoration(
              //       labelText: 'Description',
              //       hintText: 'Enter description',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //     ),
              //     keyboardType: TextInputType.multiline,
              //     minLines: 1,
              //     maxLines: 5,
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              const Text("Rejoining Date",
                  style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: RejoiningDate,
                  decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF0054A4),
                      ),
                      hintText: "Rejoining date",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "pop", fontSize: 14)),
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'pop'),
                  readOnly: true,
                  onTap: () async {
                    // If RejoiningDate is empty, use the current date, else parse from the current text.
                    DateTime initialDate = rejoining_date==""
                        ? DateTime.now()
                        : DateTime.parse(rejoining_date);

                    // Restrict selection to today or later
                    DateTime? _pickdate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: initialDate, // No previous dates allowed
                      lastDate: DateTime(2100), // You can set any last possible date
                      selectableDayPredicate: (date) {
                        // Format date to string
                        String dateString = DateFormat('yyyy-MM-dd').format(date);

                        // Return false if the date is in the disabledDates list (making it unselectable)
                        return !rejoiningDateArray.contains(dateString);
                      },
                    );

                    if (_pickdate != null) {
                      // Format the picked date as 'yyyy-MM-dd'
                      String formattedDate = DateFormat('yyyy-MM-dd').format(_pickdate);

                      // Update the TextField with the selected date
                      setState(() {
                        RejoiningDate.text = formattedDate;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(
                height: 16,
              ),
              const Text("Address During Leave",
                  style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: AddressInput,
                  decoration: const InputDecoration(
                      // labelText: 'Description',
                      border: InputBorder.none,
                      hintText: 'Enter Adddress',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "pop", fontSize: 14)),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const Text("Visiting Country",
              //     style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.bottomLeft,
              //   padding: const EdgeInsets.only(left: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFF0054A4)),
              //       borderRadius: BorderRadius.circular(5)),
              //   child: TextField(
              //     controller: VisitingCountryInput,
              //     decoration: const InputDecoration(
              //         // labelText: 'Description',
              //         border: InputBorder.none,
              //         hintText: 'Enter Country',
              //         hintStyle: TextStyle(
              //             color: Colors.grey, fontFamily: "pop", fontSize: 14)),
              //     keyboardType: TextInputType.multiline,
              //     minLines: 1,
              //     maxLines: 5,
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              const Text("Local Contact No.",
                  style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: Contract1Input,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      // labelText: 'Description',
                      border: InputBorder.none,
                      hintText: 'Enter Number',
                      counterText: "",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "pop", fontSize: 14)),
                  keyboardType: TextInputType.number,
                  
                ),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const Text("Contact No.2",
              //     style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.bottomLeft,
              //   padding: const EdgeInsets.only(left: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFF0054A4)),
              //       borderRadius: BorderRadius.circular(5)),
              //   child: TextField(
              //     controller: Contract2Input,
              //     decoration: const InputDecoration(
              //         // labelText: 'Description',
              //         border: InputBorder.none,
              //         hintText: 'Enter Number',
              //         hintStyle: TextStyle(
              //             color: Colors.grey, fontFamily: "pop", fontSize: 14)),
              //     keyboardType: TextInputType.multiline,
              //     minLines: 1,
              //     maxLines: 5,
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const Text("Visiting Country Contact No.1",
              //     style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.bottomLeft,
              //   padding: const EdgeInsets.only(left: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFF0054A4)),
              //       borderRadius: BorderRadius.circular(5)),
              //   child: TextField(
              //     controller: VistingCountryContact1Input,
              //     decoration: const InputDecoration(
              //         // labelText: 'Description',
              //         border: InputBorder.none,
              //         hintText: 'Enter Number',
              //         hintStyle: TextStyle(
              //             color: Colors.grey, fontFamily: "pop", fontSize: 14)),
              //     keyboardType: TextInputType.multiline,
              //     minLines: 1,
              //     maxLines: 5,
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // const Text("Visting CountryContact No.2",
              //     style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              // const SizedBox(
              //   height: 8,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.bottomLeft,
              //   padding: const EdgeInsets.only(left: 8),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: const Color(0xFF0054A4)),
              //       borderRadius: BorderRadius.circular(5)),
              //   child: TextField(
              //     controller: VistingCountryContact2Input,
              //     decoration: const InputDecoration(
              //         // labelText: 'Description',
              //         border: InputBorder.none,
              //         hintText: 'Enter Number',
              //         hintStyle: TextStyle(
              //             color: Colors.grey, fontFamily: "pop", fontSize: 14)),
              //     keyboardType: TextInputType.multiline,
              //     minLines: 1,
              //     maxLines: 5,
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              const Text("Reason for Leave",
                  style: TextStyle(fontFamily: "pop_m", fontSize: 16)),
              const SizedBox(
                height: 8,
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
                          color: Colors.grey, fontFamily: "pop", fontSize: 14)),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Visibility(
                visible: documentvalid=="Yes"?true:false,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      showCustomDialog(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0054A4),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 18,
                            color: MyColor.white_color,
                          ),
                          Text(
                            "Upload File",
                            style: TextStyle(
                                color: MyColor.white_color,
                                fontFamily: "pop_m",
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                //height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  //border: Border.all(color: Colors.black26)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selecteMultiImagesList.isEmpty)
                      ...[]
                    else ...[
                      SizedBox(
                        height: 200,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: selecteMultiImagesList.length,
                          itemBuilder: (context, index) {
                            File file =
                                File(selecteMultiImagesList[index].path);
                            String filePath = file.path;
                            String fileExtension =
                                filePath.split('.').last.toLowerCase();

                            // Supported image extensions
                            List<String> imageExtensions = [
                              'png',
                              'jpg',
                              'jpeg',
                              'gif'
                            ];

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child:
                                        imageExtensions.contains(fileExtension)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  // Open the file when tapped
                                                  // OpenFile.open(filePath);
                                                },
                                                child: Center(
                                                  child: Icon(
                                                    Icons.insert_drive_file,
                                                    size: 50,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                  ),
                                ),
                                // Optional: Add a delete icon on top-right corner
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selecteMultiImagesList.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                    ),
                    child: InkWell(
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
                          _leaveRequest();
                        }

                        // if (validation()) {
                        //   if (no_of_leave > maxdays!) {
                        //     _showMyDialog(
                        //         'Please Select maximun $maxdays and minimum $mindays only',
                        //         const Color(0xFF861F41),
                        //         'error');
                        //   } else if (no_of_leave < mindays!) {
                        //     _showMyDialog(
                        //         'Please Select  minimum $mindays and  maximun $maxdays only',
                        //         const Color(0xFF861F41),
                        //         'error');
                        //   } else {
                        //     createleave(
                        //         "In Review", leave_creation_id.toString());
                        //   }
                        // }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                    ),
                    child: InkWell(
                      child: Visibility(
                        visible: submit_visi,
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
                      ),
                      onTap: () {
                        // if (validation()) {
                        //   if (no_of_leave > maxdays!) {
                        //     _showMyDialog(
                        //         'Please Select maximun $maxdays and minimum $mindays only',
                        //         const Color(0xFF861F41),
                        //         'error');
                        //   } else if (no_of_leave < mindays!) {
                        //     _showMyDialog(
                        //         'Please Select  minimum $mindays and  maximun $maxdays only',
                        //         const Color(0xFF861F41),
                        //         'error');
                        //   } else {
                        //     createleave(
                        //         "In Review", leave_creation_id.toString());
                        //   }
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Choose an option',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.all(8),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                pickFilesAndCamera('Camera');
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: MyColor.mainAppColor,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: MyColor.white_color,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                pickFilesAndCamera('Files');
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: MyColor.mainAppColor,
                ),
                child: const Icon(
                  Icons.file_present,
                  color: MyColor.white_color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickFilesAndCamera(String choice) async {
    final ImagePicker picker = ImagePicker();
    List<XFile> cameraImages = [];
    List<File> selectedFiles = [];
    const int maxFileSizeMB = 5; // Max size in MB

    // Show options to the user
    // String? choice = await showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SimpleDialog(
    //       title: const Text('Choose an option'),
    //       children: [
    //         SimpleDialogOption(
    //           onPressed: () => Navigator.pop(context, 'Camera'),
    //           child: const Text('Take a Photo'),
    //         ),
    //         SimpleDialogOption(
    //           onPressed: () => Navigator.pop(context, 'Files'),
    //           child: Container(
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(4),
    //                   color: Colors.grey),
    //               child: const Text('Pick Files')),
    //         ),
    //       ],
    //     );
    //   },
    // );

    if (choice == 'Camera') {
      // Capture image using the camera
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        double imageSizeMB = getFileSize(File(pickedFile.path));
        if (imageSizeMB < maxFileSizeMB) {
          File originalFile = File(pickedFile.path);
          int originalSize = await originalFile.length();
          print("Original Size: ${originalSize / 1024} KB");

          final compressedFile = await FlutterImageCompress.compressAndGetFile(
            originalFile.path, // Path of original file
            '${originalFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg', // Unique destination path
            quality: 40, // Compression quality
          );
          if (compressedFile != null) {
            File finalCompressedFile =
                File(compressedFile.path); // Cast to File
            int compressedSize = await finalCompressedFile.length();
            print("Compressed Size: ${compressedSize / 1024} KB");

            setState(() {
              cameraImages.add(XFile(finalCompressedFile.path));
              image_file = finalCompressedFile;
              _image_name = image_file!.path;
            });
          } else {
            print("Compression failed.");
          }
          //cameraImages.add(pickedFile);
          print('Camera image captured: ${pickedFile.path}');
        } else {
          _showMyDialog(
            'Please select a file less than 5MB',
            MyColor.dialog_error_color,
            'error',
          );
        }
      } else {
        print('No image captured from the camera');
      }
    } else if (choice == 'Files') {
      // Pick files from device
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'HEIF'],
        allowMultiple: true,
      );
//allowedExtensions: ['pdf', 'xlsx', 'xls', 'png', 'jpg', 'jpeg'],
      if (result != null) {
        for (var path in result.paths) {
          if (path != null) {
            File file = File(path);
            double fileSizeMB = getFileSize(file);

            if (fileSizeMB < maxFileSizeMB) {
              selectedFiles.add(file);
              print('Selected file: $path');
            } else {
              _showMyDialog(
                'Please select a file less than 5MB',
                MyColor.dialog_error_color,
                'error',
              );
            }
          }
        }
      } else {
        print('No files selected');
      }
    }

    // Add files to your list and update the UI
    if (cameraImages.isNotEmpty || selectedFiles.isNotEmpty) {
      setState(() {
        if (cameraImages.isNotEmpty) {
          selecteMultiImagesList.addAll(cameraImages);
        }
        if (selectedFiles.isNotEmpty) {
          selecteMultiImagesList.addAll(
            selectedFiles.map((file) => XFile(file.path)).toList(),
          );
          //selecteMultiImagesList.addAll(selectedFiles);
        }
      });
      print('Files and images added to the list');
    }
  }

  double getFileSize(File file) {
    int bytes = file.lengthSync();
    return bytes / (1024 * 1024); // Convert bytes to MB
  }

  Future<void> _leaveRequest() async {
    _customProgress('Please wait...');
    print("leave method");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');
    String? empcode = preferences.getString('user_emp_code');
    print(selecteMultiImagesList.length);
    print(EncryptData.decryptAES(empcode!));
    print(leave_code_id);

    var request =
        http.MultipartRequest('POST', Uri.parse('${baseurl.url}leave-request'));

    // Add the parameters to the request

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['lr_code'] = leave_code_id;
    request.fields['lrequester_id'] = EncryptData.decryptAES(empcode);
    request.fields['from_date'] = FromedateInput.text;
    request.fields['to_date'] = TodateInput.text;
    request.fields['lr_type'] = 'Self';
    request.fields['leave_description'] = descriptionInput.text;
    request.fields['addressduringleave'] = AddressInput.text;
    request.fields['rejoining_date'] = RejoiningDate.text;
    // request.fields['leavetype'] = leave_code_id=='AL'?annualLeave!:"";
    request.fields['localcontact1'] = Contract1Input.text;
    // request.fields['localcontact2'] = Contract2Input.text;
    // request.fields['vcontact1'] = VistingCountryContact1Input.text;
    // request.fields['vcontact2'] = VistingCountryContact2Input.text;

    // Add files to the request
    if (selecteMultiImagesList.isEmpty) {
      request.fields['file[]'] = '';
    } else {
      for (int i = 0; i < selecteMultiImagesList.length; i++) {
        File file = File(selecteMultiImagesList[i].path);
        var pic = await http.MultipartFile.fromPath("file[]", file.path);
        print('pic output $pic');
        request.files.add(pic);
      }
    }

    // Send the request
    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      print(responseBody.body);
      print(responseBody.statusCode);
      var jsonObject = jsonDecode(responseBody.body);
      if (response.statusCode == 200) {
        if (jsonObject['status'] == "1") {
          Navigator.of(context).pop();
          _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          _showMyDialog(
              '${jsonObject['message']}', const Color(0xFF861F41), 'error');
        }
      } else if (response.statusCode == 401) {
        Navigator.of(context).pop();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("login_check", "false");
        preferences.commit();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  Login_Activity()));
      } else if (response.statusCode == 422) {
        Navigator.of(context).pop();

        preferences.commit();
        _showMyDialog(
            '${jsonObject['message']}', const Color(0xFF861F41), 'error');
      } else {
        Navigator.of(context).pop();
        _showMyDialog(
            '${jsonObject['message']}', const Color(0xFF861F41), 'error');

        print('Failed to upload files. Status code: ${response.statusCode}');
        var responseBody = await http.Response.fromStream(response);
        print('Response: ${responseBody.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // void createleave(String status, String id) async {
  //   _customProgress('Please wait...');
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? token = preferences.getString('user_access_token');
  //   var response =
  //       await http.post(Uri.parse("${baseurl.url}leaveRequest"), headers: {
  //     'Authorization': 'Bearer $token'
  //   }, body: {
  //     'lr_code': leave_code_id,
  //     'lrequester_id': emp_code,
  //     'from_date': FromedateInput.text,
  //     'to_date': TodateInput.text,
  //     'lr_type': 'Self',
  //     'leave_description': descriptionInput.text,
  //     // 'lr_id': id,
  //     'addressduringleave': '',
  //     'leavetype': '',
  //     'localcontact1': '',
  //     'localcontact2': '',
  //     'vcontact1': '',
  //     'vcontact2': '',
  //     // 'leave_planned': leave_plan
  //   });
  //   print(
  //       "$leave_code_id $emp_code ${FromedateInput.text} ${TodateInput.text} $leave_behalf ${AddressInput.text}");
  //   print("leave apply");
  //   print(response.body);
  //   print(response.statusCode);
  //   var jsonObject = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print(response.body);

  //     if (jsonObject['status'] == "1") {
  //       if (status == "") {
  //         _showMyDialog(
  //             'Record is saved succesfully. Kindly submit for approval',
  //             const Color(0xFF861F41),
  //             'error');

  //         setState(() {
  //           leave_creation_id = jsonObject['lr_id'];
  //           submit_visi = true;
  //         });
  //       } else {
  //         _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
  //         Navigator.of(context).pop();
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => const upcoming_dash()));
  //       }
  //     } else if (jsonObject['status'] == "0") {
  //       Navigator.of(context).pop();
  //       _showMyDialog(
  //           '${jsonObject['message']}', const Color(0xFF861F41), 'error');
  //     } else {
  //       Navigator.of(context).pop();
  //       _showMyDialog(
  //           '${jsonObject['message']}', const Color(0xFF861F41), 'error');
  //     }
  //   } else if (response.statusCode == 401) {
  //     Navigator.of(context).pop();
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.setString("login_check", "false");
  //     preferences.commit();

  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => Login_Activity()));
  //   } else if (response.statusCode == 422) {
  //     Navigator.of(context).pop();

  //     preferences.commit();
  //     _showMyDialog(
  //         '${jsonObject['message']}', const Color(0xFF861F41), 'error');
  //   }
  // }

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

  bool validation() {
    if (leave_code_id == '') {
      _showMyDialog(
          'Please Select leave Code', const Color(0xFF861F41), 'error');

      return false;
    }
    // else if (leave_code_id == "AL" && annualLeave==null) {
    //   // if (annualLeave == null) {
    //     _showMyDialog('Please Select Annual Leave Type',
    //         const Color(0xFF861F41), 'error');
    //     return false;
    //   // }
    // }
    else if (FromedateInput.text == '') {
      _showMyDialog(
          'Please Select from Date', const Color(0xFF861F41), 'error');

      return false;
    } else if (TodateInput.text == '') {
      _showMyDialog('Please Select To Date', const Color(0xFF861F41), 'error');

      return false;
    } else if (AddressInput.text == '') {
      _showMyDialog('Please Enter Address', const Color(0xFF861F41), 'error');

      return false;
    } else if (descriptionInput.text == '') {
      _showMyDialog('Please Enter Reason', const Color(0xFF861F41), 'error');

      return false;
    } else if (documentvalid=="Yes") {
      if (selecteMultiImagesList.isEmpty) {
        _showMyDialog('Please Upload File ', const Color(0xFF861F41), 'error');

        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void countdays() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    String? token = pr.getString('user_access_token');
    String? empCode =
        EncryptData.decryptAES(pr.getString('user_emp_code').toString());
    print(empCode);
    print(leave_code_id);
    print(FromedateInput.text);
    print(TodateInput.text);
    var response =
        await http.post(Uri.parse('${baseurl.url}leavecount'), body: {
      'frdate': FromedateInput.text,
      'todate': TodateInput.text,
      'emp_id': empCode,
      'lbc_id': leave_code_id
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    print("Response ${response.body} +${response.statusCode}");
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == "1") {
        setState(() {
          no_of_leave = jsonObject['count'];
          rejoining_date = jsonObject['rejoining_date'];
          rejoiningDateArray = List.from(jsonObject['rejoining_date_array']);
          RejoiningDate.text=rejoining_date;
        });
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
}