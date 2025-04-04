import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/team_request_access_panel/team_leave_request/module/team_leave_module.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Team_Leave_Decline extends StatefulWidget {
  const Team_Leave_Decline({Key? key}) : super(key: key);

  @override
  _Team_Leave_DeclineState createState() => _Team_Leave_DeclineState();
}

class _Team_Leave_DeclineState extends State<Team_Leave_Decline> {
  @override
  Widget build(BuildContext context) {
    List<TeamLeave_Module> leaveData = [];
    Future<List<TeamLeave_Module>> getAll_LeaveRequest() async {
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
        TeamLeave_Module teamleaveModule = TeamLeave_Module(
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
        data.add(teamleaveModule);

        for (int i = 0; i < data.length; i++) {
          if (data[i].wtxn_status == 'Declined') {
            leaveData.add(teamleaveModule);
          }
        }
      }
      return leaveData;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
              future: getAll_LeaveRequest(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svgs/no_data_found.svg"),
                          const Padding(padding: EdgeInsets.only(top: 16),
                            child: Text('no data found',style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'pop'
                            ),),)
                        ],
                      )
                  );
                }else{
                  if(leaveData.isEmpty){
                    return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/svgs/no_data_found.svg"),
                            const Padding(padding: EdgeInsets.only(top: 16),
                              child: Text('no data found',style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'pop'
                              ),),)
                          ],
                        )
                    );
                  }else{
                    return ListView.builder(
                        itemCount: leaveData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('emp id'),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFF0054A4),
                                              ),
                                              borderRadius: BorderRadius.circular(5)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text('Leave type'),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Apply date',
                                                  style: TextStyle(
                                                      fontSize: 14, fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    '23/04/2023',
                                                    style: TextStyle(
                                                        fontFamily: 'pop', fontSize: 14),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'From date',
                                                  style: TextStyle(
                                                      fontSize: 14, fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    '25/04/2023',
                                                    style: TextStyle(
                                                        fontFamily: 'pop', fontSize: 14),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'To date',
                                                  style: TextStyle(
                                                      fontSize: 14, fontFamily: 'pop'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    '26/04/2023',
                                                    style: TextStyle(
                                                        fontFamily: 'pop', fontSize: 14),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: const Color(0xFFFF0000)),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 5, left: 10, right: 10),
                                          child: Text(
                                            'Decline',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                color: Color(0xFFFF0000)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                          return null;

                        });
                  }

                }
              }),)

        ],
      ),
    );
  }
}
