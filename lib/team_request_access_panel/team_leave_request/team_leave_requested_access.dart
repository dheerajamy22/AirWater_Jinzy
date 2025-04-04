import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'module/team_leave_module.dart';

class Team_Leave_Requested_Access extends StatefulWidget {
  const Team_Leave_Requested_Access({Key? key}) : super(key: key);

  @override
  _Team_Leave_Requested_Access_State createState() =>
      _Team_Leave_Requested_Access_State();
}

class _Team_Leave_Requested_Access_State
    extends State<Team_Leave_Requested_Access> {
  List<TeamLeave_Module> leave_data = [];

  Future<List<TeamLeave_Module>> getAllList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=WORKFLOW_LEAVE_REQUEST_LIST'),
        body: {
          'emp_userid': user_id.toString(),
        });

    if (response.statusCode == 200) {
      print(response.body);
    }else{
      print('obj');
    }
    var jsonData = json.decode(response.body);

    var jsonArray = jsonData['WFLeaveReqList'];

    for (var team_data in jsonArray) {
      TeamLeave_Module teamLeave_Module = TeamLeave_Module(
          wtxn_status: team_data['wtxn_status'],
          lr_requester: team_data['lr_requester'],
          lr_from_date: team_data['lr_from_date'],
          lr_to_date: team_data['lr_to_date'],
          lr_leave_details: team_data['lr_leave_details'],
          lr_leave_type: team_data['lr_leave_type'],
          lr_datetime: team_data['lr_datetime'],
          wtxn_profile_url: team_data['wtxn_profile_url'],
          wtxn_requester_empid: team_data['wtxn_requester_empid'],
          wtxn_id: team_data['wtxn_id'],
          wtxn_comments: team_data['wtxn_comments']);

      List<TeamLeave_Module> data = [];
      data.add(teamLeave_Module);

      for (int i = 0; i < data.length; i++) {
        if (data[i].wtxn_status == 'Pending') {
          leave_data.add(teamLeave_Module);
        }
      }
    }

    return leave_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [


          Expanded(
              child: FutureBuilder(
            future: getAllList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svgs/no_data_found.svg'),
                      Padding(padding: EdgeInsets.only(top: 16),
                      child: Padding(padding: EdgeInsets.only(top: 16),
                      child: Text('no data found',style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'pop'
                      ),),),)
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: leave_data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return  Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'data',
                                          style: TextStyle(fontFamily: 'pop', fontSize: 14),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Color(0xFF0054A4))
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),

                                            child: Text(
                                              'type',
                                              style: TextStyle(fontSize: 14, fontFamily: 'pop'),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Apply date',
                                                style: TextStyle(
                                                    fontSize: 14, fontFamily: 'pop'),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  '23/04/2023',
                                                  style: TextStyle(
                                                      fontSize: 14, fontFamily: 'pop'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'From date',
                                                style: TextStyle(
                                                    fontSize: 14, fontFamily: 'pop'),
                                              ),
                                              Text(
                                                '25/04/2023',
                                                style: TextStyle(
                                                    fontFamily: 'pop', fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'To date',
                                                style: TextStyle(
                                                    fontSize: 14, fontFamily: 'pop'),
                                              ),
                                              Text(
                                                '26/04/2023',
                                                style: TextStyle(
                                                    fontFamily: 'pop', fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Padding(
                                          padding: EdgeInsets.only(top: 16,right: 12),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xFF0054A4),
                                                  ),
                                                  color: Color(0xFF0054A4),
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5, left: 10, right: 10),
                                                child: Text(
                                                  'Accept',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: 'pop'),
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16,left: 12),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xFF0054A4),
                                                  ),
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5, left: 10, right: 10),
                                                child: Text(
                                                  'Reject',
                                                  style: TextStyle(
                                                      color: Color(0xFF0054A4),
                                                      fontSize: 14,
                                                      fontFamily: 'pop'),
                                                ),
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ))
        ],
      ),
    );
  }
}
