import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/team_request_access_panel/team_leave_request/module/team_leave_module.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Team_Leave_Approved_Access extends StatefulWidget {
  const Team_Leave_Approved_Access({Key? key}) : super(key: key);

  @override
  _Team_Leave_Approved_AccessState createState() =>
      _Team_Leave_Approved_AccessState();
}

class _Team_Leave_Approved_AccessState
    extends State<Team_Leave_Approved_Access> {
  @override
  Widget build(BuildContext context) {
    List<TeamLeave_Module> team_leave = [];
    Future<List<TeamLeave_Module>> getTeam_Leave_List() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? user_id = pref.getString('user_id');
      var response = await http.post(
          Uri.parse(
              'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=WORKFLOW_LEAVE_REQUEST_LIST'),
          body: {'emp_userid': user_id.toString()});

      if (response.statusCode == 200) {
        print(response.body);
      }
      var leave_json = json.decode(response.body);

      var json_array = leave_json['WFLeaveReqList'];

      for (var team_data in json_array) {
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
          if (data[i].wtxn_status == 'Approved') {
            team_leave.add(teamLeave_Module);
          }
        }

      }

      return team_leave;
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getTeam_Leave_List(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svgs/no_data_found.svg"),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'no data found',
                              style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                            ),
                          )
                        ],
                      ));
                    } else {
                      if(team_leave.length==0){
                        return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/svgs/no_data_found.svg"),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    'no data found',
                                    style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                                  ),
                                )
                              ],
                            ));
                      }else{
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: team_leave.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              team_leave[index].wtxn_requester_empid.toString(),
                                              style: TextStyle(
                                                fontFamily: 'pop',
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFF0054A4)),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  team_leave[index].lr_leave_type.toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    'Apply date',
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                     team_leave[index].lr_datetime.toString(),
                                                      style: TextStyle(
                                                          fontFamily: 'pop',
                                                          fontSize: 14),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'From date',
                                                    style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                      team_leave[index].lr_from_date.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'pop'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'To date',
                                                    style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                     team_leave[index].lr_to_date.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'pop'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                              top: 16,
                                            ),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFF00A94F)),
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                      left: 10,
                                                      right: 10),
                                                  child: Text(
                                                    team_leave[index].wtxn_status.toString(),
                                                    style: TextStyle(
                                                      color: Color(0xFF00A94F),
                                                      fontFamily: 'pop',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }

                    }
                  }))
        ],
      ),
    );
  }
}
/*

*/
