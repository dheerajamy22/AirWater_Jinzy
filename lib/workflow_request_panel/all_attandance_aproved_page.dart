import 'dart:convert';

import 'package:demo/baseurl/base_url.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../_login_part/login_activity.dart';
import '../app_color/color_constants.dart';
import '../encryption_file/encrp_data.dart';
import '../team_request_access_panel/team_request_model.dart';
import 'package:http/http.dart' as http;

class AllAttandanceApprovePage extends StatefulWidget {
  List<Workflow> work_flow_data;
  String req_no_list;
  AllAttandanceApprovePage(
      {Key? key, required this.work_flow_data, required this.req_no_list})
      : super(key: key);

  @override
  State<AllAttandanceApprovePage> createState() =>
      _AllAttandanceApprovePageState();
}

class _AllAttandanceApprovePageState extends State<AllAttandanceApprovePage> {
  bool _checkbox = false;
  TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.new_backgroundColor19Apr,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
              elevation: 0.0,
              backgroundColor: MyColor.white_color,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                        'Attendance',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _checkbox,
                        onChanged: (value) {
                          //widget.callback(value!);
                          setState(() => _checkbox = !_checkbox);

                          if (_checkbox == true) {
                            Approved_RejectDialog();
                            print('${widget.req_no_list}');
                          } else {}
                        },
                      ),
                      Text('Select All',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'pop',
                            color: Colors.black,
                          )),
                    ],
                  ),
                ],
              )),
        ),
        body: Column(
          children: [
            if (widget.work_flow_data.length == 0) ...[
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
                    itemCount: widget.work_flow_data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print("length ${widget.work_flow_data.length}");
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          elevation: 4,
                          shadowColor: MyColor.mainAppColor,
                          child: InkWell(
                            onTap: () {
                              /* _viewdetailsdrawer(
                                  EncryptData.decryptAES(
                                      work_flow_data[index].ccl_type),
                                  EncryptData.decryptAES(
                                      work_flow_data[index].checkio_reason),
                                  EncryptData.decryptAES(work_flow_data[index]
                                      .wtxn_requester_emp_name),
                                  EncryptData.decryptAES(
                                      work_flow_data[index].wtxn_ref_request_no),
                                  EncryptData.decryptAES(work_flow_data[index]
                                      .wtxn_request_datetime),
                                  EncryptData.decryptAES(
                                      work_flow_data[index].ccl_inout_ip));*/
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
                                        CircleAvatar(
                                          radius: 30,
                                          child: ClipOval(
                                            child: Image.network(
                                              '${EncryptData.decryptAES(widget.work_flow_data[index].emp_photo.toString())}',
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
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
                                              '${EncryptData.decryptAES(widget.work_flow_data[index].wtxn_requester_emp_name.toString())}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'pop'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text(
                                                '${EncryptData.decryptAES(widget.work_flow_data[index].wtxn_request_datetime.toString())}',
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
                                    child: Row(
                                      children: [
                                        Text(
                                          '${EncryptData.decryptAES(widget.work_flow_data[index].ccl_type.toString())}',
                                          style: const TextStyle(
                                              fontSize: 16, fontFamily: 'pop'),
                                        ),
                                      ],
                                    ),
                                  )
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

  void Approved_RejectDialog() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            insetPadding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            contentPadding: EdgeInsets.only(bottom: 10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: StatefulBuilder(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 16, bottom: 0, right: 16),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _checkbox = !_checkbox;
                            });
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SvgPicture.asset('assets/svgs/approve.svg'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Are you sure want to Approve?',
                        style: TextStyle(
                          color: MyColor.mainAppColor,
                          fontFamily: 'pop',
                          fontSize: 16,
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
                              hintText: 'approved',
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
                                  color: Colors.red),
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
                                AllRequestApproved('Reject');
                              } else {}
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
                                  color: Colors.green),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Approve',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'pop',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (_comment.text == '') {
                                AllRequestApproved('Approved');
                              } else {}
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

  void AllRequestApproved(String status) async {
    _customProgress('Please wait...');
    print(
        'sent on server ${widget.req_no_list.toString().replaceAll(' ', '').replaceAll('[', '').replaceAll(']', '')}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? e_id = pref.getString('e_id');
    String? emp_id = pref.getString('emp_id');
    String? token = pref.getString('user_access_token');
    var response = await http
        .post(Uri.parse('${baseurl.url}approve-all-attendence'), body: {
      'req_nos':
          '${widget.req_no_list.toString().replaceAll(' ', '').replaceAll('[', '').replaceAll(']', '')}',
      'status': '${status}',
    }, headers: {
      'Authorization': 'Bearer $token'
    });

    var jsonObject = json.decode(response.body);
    print('ff ' + response.body);

    if (response.statusCode == 200) {
      if (jsonObject['status'] == '1') {
        Navigator.of(context).pop();
        _showMyDialog(jsonObject['message'], MyColor.green_color, 'success');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => new upcoming_dash()));
      } else {
        Navigator.of(context).pop();
        _showMyDialog(
            jsonObject['message'], MyColor.dialog_error_color, 'error');
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
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
