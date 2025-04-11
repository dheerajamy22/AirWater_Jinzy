import 'dart:convert';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/halfday_leave/emp_halfdayworkflowmethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class emp_halfday extends StatefulWidget {
  final String emp_code;
  const emp_halfday({super.key, required this.emp_code});

  @override
  State<emp_halfday> createState() => _emp_halfdayState();
}

class _emp_halfdayState extends State<emp_halfday> {
  String button_on = "All";
  String emp_img = "";
  String progress = "";
  List<halfworkflow> filter_list = [];
  TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    //callme();
    gethalfdaylist('All');
    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

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
              const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        gethalfdaylist('All');
                        setState(() {
                          button_on = "All";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          /*  color: button_on == "All"
                                ? MyColor.mainAppColor
                                : MyColor.white_color*/
                        ),
                        child: Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                              color: button_on == "All"
                                  ? Colors.black
                                  : Colors.black,
                              fontFamily: "pop",
                              fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        gethalfdaylist('Pending');
                        setState(() {
                          button_on = "Pending";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          /* color: button_on == "Pending"
                                ? MyColor.mainAppColor
                                : MyColor.white_color*/
                        ),
                        child: Center(
                            child: Text(
                          "Pending",
                          style: TextStyle(
                              color: button_on == "Pending"
                                  ? Colors.black
                                  : Colors.black,
                              fontFamily: "pop",
                              fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        gethalfdaylist('Approved');
                        setState(() {
                          button_on = "approved";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          /* color: button_on == "approved"
                                ? MyColor.mainAppColor
                                : MyColor.white_color*/
                        ),
                        child: Center(
                            child: Text(
                          "Approve",
                          style: TextStyle(
                              color: button_on == "approved"
                                  ? Colors.black
                                  : Colors.black,
                              fontFamily: "pop",
                              fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        gethalfdaylist('Declined');
                        setState(() {
                          button_on = "reject";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          /*    color: button_on == "reject"
                                ? MyColor.mainAppColor
                                : MyColor.white_color*/
                        ),
                        child: Center(
                            child: Text(
                          "Reject",
                          style: TextStyle(
                              color: button_on == "reject"
                                  ? Colors.black
                                  : Colors.black,
                              fontFamily: "pop",
                              fontSize: 15),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 2,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: button_on == "All"
                              ? MyColor.mainAppColor
                              : Colors.transparent),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: Container(
                      height: 2,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: button_on == "Pending"
                              ? MyColor.mainAppColor
                              : Colors.transparent),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: Container(
                      height: 2,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: button_on == "approved"
                              ? MyColor.mainAppColor
                              : Colors.transparent),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Flexible(
                    child: Container(
                      height: 2,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: button_on == "reject"
                              ? MyColor.mainAppColor
                              : Colors.transparent),
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
              else if (filter_list.isEmpty) ...[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 120),
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
                        itemCount: filter_list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () {
                                /* _viewdetailsdrawer(
                                    filter_list[index].Emp_name,
                                    filter_list[index].record_id,
                                    filter_list[index].from_date,
                                    filter_list[index].to_date,
                                    filter_list[index].req_reason,
                                    filter_list[index].totaldays,
                                    filter_list[index].status);*/
                                if (filter_list[index].status == 'Pending') {
                                  Approved_RejectDialog(
                                      filter_list[index].ReqNo,
                                      'Approved',
                                      'Approved',
                                      'assets/svgs/approve.svg');
                                }
                              },
                              child: Card(
                                elevation: 4,
                                shadowColor: MyColor.mainAppColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color,
                                    // color: (index % 2 == 0)
                                    //     ? MyColor.mainAppColor.withOpacity(0.2)
                                    //     : MyColor.light_gray.withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8, top: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Row(
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${filter_list[index].AssignDate}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'pop'),
                                                  ),
                                                  Text(
                                                    '${filter_list[index].status}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
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
                                          padding: const EdgeInsets.only(
                                              top: 4, right: 0),
                                          child: Text(
                                            "Reason:",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'pop'),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, right: 0),
                                            child: Text(
                                              '${filter_list[index].lr_reason}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'pop'),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }))
              ]
            ],
          ),
        ),
      ),
    );
  }

  void gethalfdaylist(String status) async {
    print('${widget.emp_code}');
    filter_list = [];
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    emp_img = p.getString('user_profile')!;
    var response = await http
        .post(Uri.parse("${baseurl.url}halfleave-workflow"), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      "emp_code": widget.emp_code
    });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        progress = '1';
      });
      var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        // leaverqst_details.clear();
        filter_list.clear();
        var jsonarray = jsonObject['requested_Tasks'];
        for (var i in jsonarray) {
          halfworkflow wfhdetails = halfworkflow(
              ReqNo: i['ReqNo'],
              AssignDate: i['AssignDate'],
              date: i['date'],
              status: i['status'],
              lr_reason: i['lr_reason'],
              type: i['Type']);
          // filter_list.add(leavedetails);
          List<halfworkflow> data = [];
          data.add(wfhdetails);
          if (status == 'Approved') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].status == 'Approved') {
                setState(() {
                  filter_list.add(wfhdetails);
                });
              }
            }
          } else if (status == 'Declined') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].status == 'Rejected') {
                setState(() {
                  filter_list.add(wfhdetails);
                  print('rtyuiop[');
                });
              }
            }
          } else if (status == 'Pending') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].status == 'Pending') {
                setState(() {
                  filter_list.add(wfhdetails);
                });
              }
            }
          } else if (status == 'All') {
            setState(() {
              filter_list.add(wfhdetails);
            });
          }
        }
      } else {}
    }
    else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }else{
      setState(() {
        progress = '1';
      });
    }
    // return filter_list;
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            insetPadding: const EdgeInsets.only(left: 8, right: 8),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            scrollable: true,
            content: StatefulBuilder(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 12),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                                  color: MyColor.red_color.withOpacity(0.6)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'pop',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (_comment.text == '') {
                                send_Status_Approvel(request_number, 'Rejected',
                                    '${w_status}', 'Rejected');
                              } else {
                                send_Status_Approvel(request_number, 'Rejected',
                                    _comment.text, 'Rejected');
                              }
                              Navigator.of(context).pop(context);

                              // Navigator.of(context).pop(context);
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
                                  color: MyColor.mainAppColor),
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

  void send_Status_Approvel(String wtxn_id, String wtxn_status,
      String wtxn_comments, String ccl_action) async {
    ProgressDialog pr = await ProgressDialog(context);
    _customProgress('Please wait...');

    print(
        "id ${wtxn_id} status ${wtxn_status} ccla ${ccl_action} comment ${wtxn_comments}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? token = pref.getString('user_access_token');
    var response = await http.post(Uri.parse('${baseurl.url}workflow-action'), body: {
      'request_id': '${wtxn_id}',
      'status': '${ccl_action}',
      'comment': '${wtxn_comments}',
    }, headers: {
      'Authorization': 'Bearer ${token}'
    });

    print('Approved data ' + response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      if (jsonObject['status'] == '1') {
        gethalfdaylist(button_on);

        _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
      } else {
        _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));

        // Navigator.of(context).pop(context);
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
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
}
