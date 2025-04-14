import 'dart:convert';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/new_leave_page_by_Vikas_Sir/leavelist_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../new_dashboard_2024/updated_dashboard_2024.dart';

class leavelist extends StatefulWidget {
  const leavelist({
    super.key,
  });

  @override
  State<leavelist> createState() => _leavelistState();
}

class _leavelistState extends State<leavelist> {
  List<leavelistdetails> filter_list = [];
  String button_on = "all";
  String emp_img = "";
  String progress = '';

  @override
  void initState() {
   // callme();
    getleavelist('All');

    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  void getleavelist(String status) async {
    filter_list = [];
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    emp_img = p.getString('user_profile')!;
    var response = await http.post(
      Uri.parse("${baseurl.url}leave-request-list"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
       setState(() {
      progress = '1';
    });
      // var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        // leaverqst_details.clear();
        filter_list.clear();
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
          List<leavelistdetails> data = [];
          data.add(leavedetails);
          if (status == 'Approved') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'Approved') {
                setState(() {
                  filter_list.add(leavedetails);
                });
              }
            }
          } else if (status == 'Declined') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'Declined') {
                setState(() {
                  filter_list.add(leavedetails);
                  print('rtyuiop[');
                });
              }
            }
          } else if (status == 'In Review') {
            for (int i = 0; i < data.length; i++) {
              if (data[i].lr_status == 'In Review') {
                setState(() {
                  filter_list.add(leavedetails);
                });
              }
            }
          } else if (status == 'All') {
            setState(() {
              filter_list.add(leavedetails);
            });
          }
        }
      } else {}
    } else if (response.statusCode == 401) {
       setState(() {
      progress = '1';
    });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    }
    // return filter_list;
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
              const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        getleavelist('All');
                        setState(() {
                          button_on = "all";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // color: button_on == "all"
                          //     ? MyColor.mainAppColor
                          //     : MyColor.white_color
                        ),
                        child: Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                              color: button_on == "all"
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
                          button_on = "in";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // color: button_on == "in"
                          //     ? MyColor.mainAppColor
                          //     : MyColor.white_color
                        ),
                        child: Center(
                            child: Text(
                          "Pending",
                          style: TextStyle(
                              color: button_on == "in"
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
                          // color: button_on == "approved"
                          //     ? MyColor.mainAppColor
                          //     : MyColor.white_color
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
                          // color: button_on == "reject"
                          //     ? MyColor.mainAppColor
                          //     : MyColor.white_color
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
                          color: button_on == "all"
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
                          color: button_on == "in"
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
                                _viewdetailsdrawer(
                                    filter_list[index].employee_name,
                                    filter_list[index].leave_code,
                                    filter_list[index].from_date,
                                    filter_list[index].to_date,
                                    filter_list[index].reason,
                                    filter_list[index].leave_planned,
                                    filter_list[index].requesting_type,
                                    filter_list[index].created_on,
                                    filter_list[index].no_of_days,
                                    filter_list[index].lr_id);
                              },
                              child: Card(
                                color: MyColor.white_color,
                                elevation: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyColor.white_color
                                    // color: (index % 2 == 0)
                                    //     ? MyColor.mainAppColor.withOpacity(0.2)
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
                                                      EncryptData.decryptAES(
                                                          emp_img))),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  filter_list[index]
                                                      .employee_name,
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
                                                                filter_list[
                                                                        index]
                                                                    .created_on
                                                                    .toString()
                                                                    .split(" ")
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
                                        // const SizedBox(
                                        //   height: 12,
                                        // ),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(filter_list[index]
                                                  .leave_code),
                                              Text(filter_list[index].lr_status)
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
      ),
    );
  }

  void View_Details(String reason, String leave_id) async {
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
                  height: MediaQuery.of(context).size.height * 0.4,
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
                              'Reason',
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
                              const Padding(
                                padding:
                                    EdgeInsets.only(top: 8, right: 8, left: 8),
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: '${reason}',
                                          border: InputBorder.none),
                                      readOnly: true,
                                      minLines: 1,
                                      maxLines: 5,
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: 'pop'),
                                    ),
                                  ),
                                ),
                              ),

                              //Button
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 12),
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

  void deleteleave(String id) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    var response = await http
        .post(Uri.parse("${baseurl.url}delete_leave_request"), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'delete_id': id
    });
    print(response.body);
    var jsonObject = json.decode(response.body);
    if (response.statusCode == 200) {
      // var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        pr.hide();
        setState(() {
          //leaverqst_details.removeWhere((element) => element.lr_id == id);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    }
  }

  void cancelleave(String id) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    var response =
        await http.post(Uri.parse("${baseurl.url}cancel_request"), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'cancel_id': id
    });
          var jsonObject = json.decode(response.body);

    print(response.body);
    if (response.statusCode == 200) {
      // var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        pr.hide();
        setState(() {
          //  leaverqst_details.removeWhere((element) => element.lr_id == id);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    }
  }

  void Approved_RejectDialog(
    String ccl_action,
    String id,
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
            content: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      StatefulBuilder(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child:
                                    SvgPicture.asset('assets/svgs/approve.svg'),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                    color: MyColor.mainAppColor,
                                    fontFamily: 'pop',
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 4, right: 4),
                                child: Text(
                                  'Are you sure want to ${ccl_action}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'pop',
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 32, right: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 48,
                                        width: 120,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'No',
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
                                        width: 120,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: ccl_action == 'Delete'
                                                ? Colors.red
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
                                        if (ccl_action == 'Delete') {
                                          deleteleave(id);
                                        } else if (ccl_action == 'Cancel') {
                                          cancelleave(id);
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
                    ],
                  )),
            ),
          );
        });
  }

  void createleave(
      String status,
      String id,
      String leave_code_id,
      String FromedateInput,
      String TodateInput,
      String leave_behalf,
      String descriptionInput,
      String leave_plan) async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.show();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');
    String? emp_id = preferences.getString('user_id');
    var response =
        await http.post(Uri.parse("${baseurl.url}leaveRequest"), headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'lr_code': leave_code_id,
      'lrequester_id': EncryptData.decryptAES(emp_id!),
      'from_date': FromedateInput,
      'to_date': TodateInput,
      'lr_type': leave_behalf,
      'leave_description': descriptionInput,
      'status': status,
      'lr_id': id,
      'leave_planned': leave_plan
    });
    print(
        "what going on $leave_code_id $emp_id ${FromedateInput} ${TodateInput} $leave_behalf ${descriptionInput}");
    print(response.body);
          var jsonObject = json.decode(response.body);

    if (response.statusCode == 200) {
      await pr.hide();
      print(response.body);
      // var jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == "1") {
        print("rafsr " + response.body);
        print("yujikol" + status);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => upcoming_dash()));
      } else if (jsonObject['status'] == "0") {
        await pr.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      await pr.hide();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    }
  }

  Future<void> _viewdetailsdrawer(String name, leave_type, form_date, to_date,
      reason, rqst_type, rqst_for, created_on, total_days, rqst_id) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              insetPadding: EdgeInsets.all(24),
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
                ],
              ),
            );
          });
        });
  }
}

//old body Part
// body: Padding(
//       padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
//       child: Column(
//         children: [
//           Expanded(
//               child: FutureBuilder(
//                   future: getleavelist(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(
//                         child: CircularProgressIndicator(
//                          // semanticsLabel: 'Circular progress indicator',
//                           color: MyColor.mainAppColor,
//                         ),
//                       );
//                     } else {
//                       if (leaverqst_details.length == 0) {
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset(
//                                   'assets/svgs/no_data_found.svg'),
//                               const Padding(
//                                 padding: EdgeInsets.only(top: 16),
//                                 child: Text(
//                                   'No data found',
//                                   style: TextStyle(
//                                       color: MyColor.mainAppColor,
//                                       fontSize: 16,
//                                       fontFamily: 'pop'),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       } else {
//                         return ListView.builder(
//                             itemCount: leaverqst_details.length,
//                             shrinkWrap: true,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(0.0),
//                                 child: Card(
//                                   elevation: 2,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8, right: 8, bottom: 16),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,

//                                           children: [
//                                             Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   leaverqst_details[index]
//                                                       .employee_name,
//                                                   style: const TextStyle(
//                                                       fontSize: 14,
//                                                       fontFamily: 'pop'),
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(top: 0.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                         children: [
//                                                           Text(
//                                                             "Created: " +
//                                                                 leaverqst_details[
//                                                                 index]
//                                                                     .created_on
//                                                                     .toString()
//                                                                     .split(" ")
//                                                                     .first,
//                                                             style: const TextStyle(
//                                                                 fontSize: 14,
//                                                                 fontFamily: 'pop'),
//                                                           ),
//                                                           const SizedBox(
//                                                             width: 16,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Padding(
//                                                                 padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     top: 2.0),
//                                                                 child: Text(
//                                                                   "From: " +
//                                                                       leaverqst_details[
//                                                                       index]
//                                                                           .from_date,
//                                                                   style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                       14,
//                                                                       fontFamily:
//                                                                       'pop'),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 16,
//                                                               ),
//                                                               Padding(
//                                                                 padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     top: 2.0),
//                                                                 child: Text(
//                                                                   "To:- " +
//                                                                       leaverqst_details[
//                                                                       index]
//                                                                           .to_date,
//                                                                   style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                       14,
//                                                                       fontFamily:
//                                                                       'pop'),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           const SizedBox(
//                                                             width: 16,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Padding(
//                                                                 padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     top: 2.0),
//                                                                 child: Text(
//                                                                   "Total Days:- " +
//                                                                       leaverqst_details[
//                                                                       index]
//                                                                           .no_of_days,
//                                                                   style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                       14,
//                                                                       fontFamily:
//                                                                       'pop'),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 16,
//                                                               ),
//                                                               Padding(
//                                                                 padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     top: 2.0),
//                                                                 child: Text(
//                                                                   "Leave Code:- " +
//                                                                       leaverqst_details[
//                                                                       index]
//                                                                           .leave_code,
//                                                                   style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                       14,
//                                                                       fontFamily:
//                                                                       'pop'),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),

//                                             if (leaverqst_details[index]
//                                                 .lr_status ==
//                                                 'In Review') ...[
//                                               Container(
//                                                 alignment: Alignment.topRight,
//                                                 child: PopupMenuButton(
//                                                   icon: const Icon(
//                                                       Icons.more_vert),
//                                                   itemBuilder: (context) => [
//                                                     const PopupMenuItem(
//                                                       child: Text(
//                                                         'Reason',
//                                                         style: TextStyle(
//                                                             fontFamily: 'pop',
//                                                             fontSize: 14),
//                                                       ),
//                                                       value: 1,
//                                                     ),
//                                                     const PopupMenuItem(
//                                                       child: Text(
//                                                         'Cancel',
//                                                         style: TextStyle(
//                                                             fontFamily: 'pop',
//                                                             fontSize: 14),
//                                                       ),
//                                                       value: 2,
//                                                     ),
//                                                   ],
//                                                   onSelected: (value) {
//                                                     switch (value) {
//                                                       case 1:
//                                                         View_Details(
//                                                             leaverqst_details[
//                                                             index]
//                                                                 .reason,
//                                                             leaverqst_details[
//                                                             index]
//                                                                 .lr_id);
//                                                         break;
//                                                       case 2:
//                                                         Approved_RejectDialog(
//                                                             "Cancel",
//                                                             leaverqst_details[
//                                                             index]
//                                                                 .lr_id);
//                                                         break;
//                                                     }
//                                                   },
//                                                 ),
//                                               ),
//                                             ] else if (leaverqst_details[
//                                             index]
//                                                 .lr_status ==
//                                                 'Draft') ...[
//                                               PopupMenuButton(
//                                                 itemBuilder: (context) => [
//                                                   const PopupMenuItem(
//                                                     child: Text(
//                                                       'Reason',
//                                                       style: TextStyle(
//                                                           fontFamily: 'pop',
//                                                           fontSize: 14),
//                                                     ),
//                                                     value: 1,
//                                                   ),
//                                                   const PopupMenuItem(
//                                                     child: Text(
//                                                       'Submit For Approval',
//                                                       style: TextStyle(
//                                                           fontFamily: 'pop',
//                                                           fontSize: 14),
//                                                     ),
//                                                     value: 2,
//                                                   ),
//                                                   const PopupMenuItem(
//                                                     child: Text(
//                                                       'Delete',
//                                                       style: TextStyle(
//                                                           fontFamily: 'pop',
//                                                           fontSize: 14),
//                                                     ),
//                                                     value: 3,
//                                                   ),
//                                                 ],
//                                                 onSelected: (value) {
//                                                   switch (value) {
//                                                     case 1:
//                                                       View_Details(
//                                                           leaverqst_details[
//                                                           index]
//                                                               .reason,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .lr_id);
//                                                       break;
//                                                     case 2:
//                                                       createleave(
//                                                           "In Review",
//                                                           leaverqst_details[
//                                                           index]
//                                                               .lr_id,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .leave_code,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .from_date,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .to_date,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .requesting_type,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .reason,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .leave_planned);
//                                                       break;
//                                                     case 3:
//                                                       Approved_RejectDialog(
//                                                           "Delete",
//                                                           leaverqst_details[
//                                                           index]
//                                                               .lr_id);
//                                                       break;
//                                                   }
//                                                 },
//                                               ),
//                                             ] else ...[
//                                               PopupMenuButton(
//                                                 itemBuilder: (context) => [
//                                                   const PopupMenuItem(
//                                                     child: Text(
//                                                       'Reason',
//                                                       style: TextStyle(
//                                                           fontFamily: 'pop',
//                                                           fontSize: 14),
//                                                     ),
//                                                     value: 1,
//                                                   ),
//                                                 ],
//                                                 onSelected: (value) {
//                                                   switch (value) {
//                                                     case 1:
//                                                       View_Details(
//                                                           leaverqst_details[
//                                                           index]
//                                                               .reason,
//                                                           leaverqst_details[
//                                                           index]
//                                                               .lr_id);
//                                                       break;
//                                                   }
//                                                 },
//                                               ),
//                                             ],
//                                           ],
//                                         ),

//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             });
//                       }
//                     }
//                   }))
//         ],
//       ),
//     ),
