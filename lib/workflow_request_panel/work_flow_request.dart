import 'dart:convert';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_profile_picture/super_profile_picture.dart';

import '../new_dashboard_2024/updated_dashboard_2024.dart';
import '../team_request_access_panel/team_request_model.dart';

class My_Work_flow_Request extends StatefulWidget {
  final String emp_code;

  My_Work_flow_Request({Key? key, required this.emp_code}) : super(key: key);

  @override
  _My_Work_flow_RequestState createState() => _My_Work_flow_RequestState();
}

class _My_Work_flow_RequestState extends State<My_Work_flow_Request> {
  TextEditingController _comment = TextEditingController();
  List<Workflow> work_flow_data = [];
  String progress = '';

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

  void send_Status_Approvel(String wtxn_id, String wtxn_status,
      String wtxn_comments, String ccl_action) async {
    ProgressDialog pr = await ProgressDialog(context);
    //  pr.show();
    _customProgress('Please wait...');
    print(
        "id ${wtxn_id} status ${wtxn_status} ccla ${ccl_action} comment ${wtxn_comments}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? token = pref.getString('user_access_token');
    var response = await http
        .post(Uri.parse('${baseurl.url}workflow-accept-reject'), body: {
      'req_no': '${wtxn_id}',
      'status': '${ccl_action}',
      'reason': '${wtxn_comments}',
    }, headers: {
      'Authorization': 'Bearer ${token}'
    });

    print('Approved data ' + response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        Navigator.pop(context);
        pr.hide();
        setState(() {
          work_flow_data.removeWhere((element) =>
              EncryptData.decryptAES(element.wtxn_ref_request_no) == wtxn_id);
        });

        if (work_flow_data.isEmpty) {
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => upcoming_dash()));
        }
        getWorkFlowRequest();
        _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
      } else {
        Navigator.pop(context);
        _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');

        // Navigator.of(context).pop(context);
      }
    } else if (response.statusCode == 401) {
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
    if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    }
  }

  void View_Details(String type, String reason, String emp_name,
      String attandance_id, String time, String ip) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            insetPadding: const EdgeInsets.only(left: 8, right: 8),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: SingleChildScrollView(
              child: Container(
                  height: 450,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'View details',
                              style:
                                  TextStyle(fontSize: 18, fontFamily: 'pop_m'),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: MyColor.mainAppColor,
                                )),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 2,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, right: 8, left: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Request Id -',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: MyColor.mainAppColor),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          '${attandance_id}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'pop',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, right: 8, left: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Employee -',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: MyColor.mainAppColor),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          '${emp_name}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'pop',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, right: 8, left: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Check Out time -',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: MyColor.mainAppColor),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          '${time}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'pop',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsets.only(top: 16, right: 8, left: 8),
                                child: Text(
                                  'Specify Reason',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'pop',
                                      color: MyColor.mainAppColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, right: 8, left: 8),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      '${reason}',
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: 'pop'),
                                    ),
                                  ),
                                ),
                              ),

                              //Button
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
                                      'Close',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'pop',
                                          color: Colors.white),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(context);
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

  void Approved_RejectDialog(
    String request_number,
    String w_status,
    String ccl_action,
    String image_url,
  ) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            insetPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
            contentPadding: EdgeInsets.only(bottom: 10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: StatefulBuilder(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SvgPicture.asset('${image_url}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Are you sure want to ${ccl_action}?',
                        style: TextStyle(
                          color: MyColor.mainAppColor,
                          fontFamily: 'pop',
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 8.0, left: 4, right: 4),
                    //   child: Text(
                    //     'Are you sure want to ${ccl_action}',
                    //     style: const TextStyle(
                    //       color: Colors.black,
                    //       fontFamily: 'pop',
                    //       fontSize: 14,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
                      child: Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: TextField(
                            controller: _comment,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '${ccl_action}',
                            ),
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, right: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'pop',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(context);
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ccl_action == 'Rejected'
                                      ? Colors.red
                                      : Colors.green),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${ccl_action}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'pop',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (_comment.text == '') {
                                send_Status_Approvel(request_number, w_status,
                                    '${w_status}', ccl_action);
                              } else {
                                send_Status_Approvel(request_number, w_status,
                                    _comment.text, ccl_action);
                              }
                              Navigator.of(context).pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  void getWorkFlowRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? e_id = pref.getString('e_id');
    String? emp_id = pref.getString('emp_id');
    String? token = pref.getString('user_access_token');
    var response = await http
        .post(Uri.parse('${baseurl.url}workflow-list-for-attendence'), body: {
      'emp_code': '${widget.emp_code}',
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    print(token);

    print('ff ' + response.body);
    print('ff ' + '${response.statusCode}');
    List<String> req_no = [];
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        progress = '1';
      });

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
          req_no.add(EncryptData.decryptAES(flow['ReqNo']));

          print('attandance ${req_no}');
          // flow.add(workflow);

          setState(() {
            work_flow_data.add(workflow);
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
    if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else {
      setState(() {
        progress = '1';
      });
    }

    // return work_flow_data;
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

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  @override
  void initState() {
    //callme();
    getWorkFlowRequest();
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
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF0054A4),
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
                          'Attendance Request',
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
        body: Column(
          children: [
            if (progress == '')
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: MyColor.mainAppColor,
                )),
              )
            else if (work_flow_data.length == 0) ...[
              // Navigator.pop(context);
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              )
            ] else ...[
              Expanded(
                child: ListView.builder(
                    itemCount: work_flow_data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          elevation: 4,
                          shadowColor: MyColor.mainAppColor,
                          child: InkWell(
                            onTap: () {
                              _viewdetailsdrawer(
                                  EncryptData.decryptAES(
                                      work_flow_data[index].ccl_type),
                                  EncryptData.decryptAES(
                                      work_flow_data[index].checkio_reason),
                                  EncryptData.decryptAES(work_flow_data[index]
                                      .wtxn_requester_emp_name),
                                  EncryptData.decryptAES(work_flow_data[index]
                                      .wtxn_ref_request_no),
                                  EncryptData.decryptAES(work_flow_data[index]
                                      .wtxn_request_datetime),
                                  EncryptData.decryptAES(
                                      work_flow_data[index].ccl_inout_ip));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColor.white_color
                                  // color: (index % 2 == 0)
                                  //     ? MyColor.mainAppColor.withOpacity(0.2)
                                  //     : MyColor.light_gray.withOpacity(0.2),
                                  ),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Row(
                                      children: [
                                        if (EncryptData.decryptAES(
                                                work_flow_data[index]
                                                    .emp_photo
                                                    .toString()) ==
                                            " ") ...[
                                          SuperProfilePicture(
                                            label: EncryptData.decryptAES(
                                                work_flow_data[index]
                                                    .wtxn_requester_emp_name
                                                    .toString()),
                                            radius: 20,
                                            textDecorationProperties:
                                                TextDecorationProperties(
                                              maxLabelLength: 3,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ] else ...[
                                          CircleAvatar(
                                            radius: 30,
                                            child: ClipOval(
                                              child: Image.network(
                                                '${EncryptData.decryptAES(work_flow_data[index].emp_photo.toString())}',
                                                fit: BoxFit.cover,
                                                width: 60,
                                                height: 60,
                                              ),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${EncryptData.decryptAES(work_flow_data[index].wtxn_requester_emp_name.toString())}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'pop'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text(
                                                '${EncryptData.decryptAES(work_flow_data[index].wtxn_request_datetime.toString())}',
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
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      '${EncryptData.decryptAES(work_flow_data[index].ccl_type.toString())}',
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: 'pop'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ]
          ],
        ));
  }

  Future<void> _viewdetailsdrawer(String type, String reason, String emp_name,
      String attandance_id, String time, String ip) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding:
                  EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attendance Details",
                        style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black26,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Request Id",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            attandance_id,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Type",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${type.split(' ').last}',
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Employee Name",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            emp_name,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Time",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${time}',
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    "Reason",
                    style: TextStyle(
                        fontFamily: "pop", fontSize: 16, color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    reason,
                    style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                            child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Approved_RejectDialog(attandance_id, 'Approved',
                                'Approved', 'assets/svgs/approve.svg');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColor.mainAppColor),
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                  color: MyColor.white_color,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Approved_RejectDialog(attandance_id, 'Rejected',
                                'Rejected', 'assets/svgs/reject.svg');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColor.red_color.withOpacity(0.6)),
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                  color: MyColor.white_color,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}
