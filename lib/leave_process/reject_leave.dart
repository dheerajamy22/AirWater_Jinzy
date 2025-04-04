import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/leave_process/leave_module.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_color/color_constants.dart';
import 'create_leave_request.dart';

class Reject_Leave_Activity extends StatefulWidget {
  @override
  Reject_Leave_Activity_State createState() => Reject_Leave_Activity_State();
}

class Reject_Leave_Activity_State extends State<Reject_Leave_Activity> {
  @override
  Widget build(BuildContext context) {
    List<LeaveModule> dataLeave = [];
    Future<List<LeaveModule>> getAllList() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final String? token = pref.getString("user_access_token");
      String? user_id = pref.getString('user_id');
      var response = await http.post(
          Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_LEAVE_REQUEST_LIST'),
          body: {
            'emp_userid': user_id.toString(),
          });
      if (response.statusCode == 200) print(response.body);

      var jsonData = json.decode(response.body);

      var jsonArray = jsonData["LeaveRequestList"];

      for (var leaveData in jsonArray) {
        LeaveModule leaveModule = LeaveModule(
            lr_from_date: leaveData['lr_from_date'],
            lr_to_date: leaveData['lr_to_date'],
            lr_datetime: leaveData['lr_datetime'],
            lr_status: leaveData['lr_status'],
            lr_leave_details: leaveData['lr_leave_details']);

        List<LeaveModule> data = [];
        data.add(leaveModule);




        for (int i = 0; i < data.length; i++) {
          if(data[i].lr_status=='Declined'){
            dataLeave.add(leaveModule);
          }
        }
      }

      return dataLeave;
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            child: InkWell(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/add_icon.png",
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Create leave request",
                        style: TextStyle(color: Color(0xFF0054A4)),
                      ),
                    )
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new CreteLeaveRequest(self_select: 'Self',)));
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LeaveModule>>(
                future: getAllList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svgs/no_data_found.svg'),
                          Padding(
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
                    );
                  } else {
                    if(dataLeave.length==0){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/svgs/no_data_found.svg'),
                            Padding(
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
                      );
                    }else{
                      return ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataLeave.length,
                          itemBuilder: (context, index) {


                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        dataLeave[index].lr_leave_details.toString(),
                                        textAlign: TextAlign.end,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(
                                                  "Apply date",
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(dataLeave[index].lr_datetime.toString()),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(
                                                  "From date",
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(dataLeave[index].lr_from_date.toString()),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(
                                                  "To date",
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text(dataLeave[index].lr_to_date),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),


                                      InkWell(
                                        child: Padding(padding: EdgeInsets.only(top: 16,left: 90,right: 90,bottom: 8),
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.red),
                                              borderRadius:
                                              BorderRadius.circular(10),

                                            ),
                                            child: Center(
                                              child: Text(
                                                dataLeave[index].lr_status.toString(),
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'pop',



                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {





                                          /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainHome()),
                                        );*/
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                      );
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}
