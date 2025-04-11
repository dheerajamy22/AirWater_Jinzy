import 'dart:convert';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/new_leave_managerdashboard/leave_workflowmethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class manager_workflow extends StatefulWidget {
  final String emp_code;
  const manager_workflow({super.key, required this.emp_code});

  @override
  State<manager_workflow> createState() => _manager_workflowState();
}

class _manager_workflowState extends State<manager_workflow> {
  List<leave_workflow> workflow_list = [];

  //List<leave_workflow> workflow_list = [];
  TextEditingController _comment = TextEditingController();
  String button_on = "All";
  String progress = "";

  callme() async {
    await Future.delayed(Duration(seconds: 3));

  }

  void getleavelist(String status) async {
    workflow_list = [];
    print(widget.emp_code);
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    var response = await http.post(
      Uri.parse("${baseurl.url}leave-request-workflow-list"),
      body: {'emp_code': '${widget.emp_code}'},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        progress = '1';
      });
      var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        // leaverqst_details.clear();
        workflow_list.clear();
        var jsonarray = jsonObject['requested_Tasks'];
        for (var array_data in jsonarray) {
          leave_workflow leave_list = leave_workflow(
            ReqNo: array_data['ReqNo'],
            AssignDate: array_data['AssignDate'],
            EmpCode: array_data['EmpCode'],
            EmpId: array_data['EmpId'],
            EmpName: array_data['EmpName'],
            Image: array_data['Image'],
            Type: array_data['Type'],
            created_at: array_data['created_at'],
            lr_from_date: array_data['lr_from_date'],
            lr_ref_no: array_data['lr_ref_no'],
            lr_status: array_data['status'],
            lr_to_date: array_data['lr_to_date'],
            lr_total_days: array_data['lr_total_days'],
            req_type: array_data['req_type'],
            requester_id: array_data['requester_id'],
            tbl_employee_id: array_data['tbl_employee_id'],
            tbl_leavecode_id: array_data['tbl_leavecode_id'],
            lr_reason: array_data['lr_reason'],
            leave_type: array_data['leave_type'],
            lr_leave_planed: "",
          );

          List<leave_workflow> data = [];
          data.add(leave_list);
          if (status == 'Approved') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'Approved') {
                setState(() {
                  workflow_list.add(leave_list);
                });
              }
            }
          } else if (status == 'Declined') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'Rejected') {
                setState(() {
                  workflow_list.add(leave_list);
                  print('rtyuiop[');
                });
              }
            }
          } else if (status == 'In Review') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'Pending') {
                setState(() {
                  workflow_list.add(leave_list);
                });
              }
            }
          } else if (status == 'All') {
            setState(() {
              workflow_list.add(leave_list);
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
    // return workflow_list;
  }

  @override
  void initState() {
   // callme();
    getleavelist('All');
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
                    'Leave History',
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
          ),),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 32),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          getleavelist('All');
                          setState(() {
                            button_on = "All";
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            /* color: button_on == "All"
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
                                fontSize: 16),
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
                          getleavelist('In Review');
                          setState(() {
                            button_on = "In Review";
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            /* color: button_on == "In Review"
                                  ? MyColor.mainAppColor
                                  : MyColor.white_color*/
                          ),
                          child: Center(
                              child: Text(
                            "Pending",
                            style: TextStyle(
                                color: button_on == "In Review"
                                    ? Colors.black
                                    : Colors.black,
                                fontFamily: "pop",
                                fontSize: 16),
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
                          getleavelist('Approved');
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
                                fontSize: 16),
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
                          getleavelist('Declined');
                          setState(() {
                            button_on = "reject";
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            /*color: button_on == "reject"
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
                                fontSize: 16),
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
                            color: button_on == "In Review"
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
                else if (workflow_list.isEmpty) ...[
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
                          itemCount: workflow_list.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () {
                                  _viewdetailsdrawer(
                                      workflow_list[index].EmpName,
                                      workflow_list[index].leave_type,
                                      workflow_list[index].lr_from_date,
                                      workflow_list[index].lr_to_date,
                                      workflow_list[index].lr_reason,
                                      workflow_list[index].lr_leave_planed,
                                      workflow_list[index].req_type,
                                      workflow_list[index].created_at,
                                      workflow_list[index].lr_total_days,
                                      workflow_list[index].ReqNo,
                                      workflow_list[index].lr_status);
                                },
                                child: Card(
                                  color: MyColor.white_color,
                                  elevation: 4,
                                  shadowColor: MyColor.mainAppColor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: MyColor.white_color
                                        // color: (index % 2 == 0)
                                        //     ? MyColor.mainAppColor
                                        //         .withOpacity(0.2)
                                        //     : MyColor.light_gray.withOpacity(0.2),
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, bottom: 8, top: 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                child: ClipOval(
                                                    child: Image.network(
                                                        '${workflow_list[index].Image}')),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    workflow_list[index]
                                                        .EmpName,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Created On: " +
                                                                  workflow_list[
                                                                          index]
                                                                      .created_at
                                                                      .toString()
                                                                      .split(
                                                                          " ")
                                                                      .first,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'pop'),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                                                left: 10, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(workflow_list[index]
                                                    .leave_type),
                                                Text(workflow_list[index]
                                                    .lr_status)
                                              ],
                                            ),
                                          )
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
        ));
  }

  Future<void> _viewdetailsdrawer(String name, leave_type, form_date, to_date,
      reason, rqst_type, rqst_for, created_on, total_days, rqst_id, lr_status) {
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
                  EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 16),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Leave Details",
                        style: TextStyle(fontFamily: "pop_m", fontSize: 20),
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
                            rqst_id,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
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
                            name,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Leave Type",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            leave_type,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "From Date",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            form_date,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Total Days",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            total_days,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Request For",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            rqst_for,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Request Type",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            rqst_type,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Created Date",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            created_on.toString().split(" ").first,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "To Date",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            to_date,
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '',
                            style: TextStyle(fontFamily: "pop_m", fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
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
                  if (lr_status == 'Pending') ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Approved_RejectDialog(rqst_id, 'Approved',
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
                              Approved_RejectDialog(rqst_id, 'Rejected',
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
                  ]
                ],
              ),
            );
          });
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
            insetPadding: const EdgeInsets.only(left: 8, right: 8),
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
                              print(
                                  '${w_status} ${ccl_action}  ${request_number}');
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
                                  color: ccl_action == 'Approved'
                                      ? Colors.green
                                      : Colors.red),
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
        getleavelist(button_on);
        _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
      } else {
        _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');

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
