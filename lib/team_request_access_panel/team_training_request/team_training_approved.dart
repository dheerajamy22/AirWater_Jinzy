import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/team_training_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Team_Training_Aprroved_Request extends StatefulWidget {
  const Team_Training_Aprroved_Request({Key? key}) : super(key: key);

  @override
  _Team_Training_Aprroved_RequestState createState() =>
      _Team_Training_Aprroved_RequestState();
}

class _Team_Training_Aprroved_RequestState
    extends State<Team_Training_Aprroved_Request> {
  List<TeamTraining_RequestModel> team_data = [];

  Future<List<TeamTraining_RequestModel>> getTeam_TrainingRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=WORKFLOW_TRAINING_REQUEST_LIST'),
        body: {'emp_userid': user_id.toString()},
        headers: {'Authorization': ''});

    if (response.statusCode == 200) {
      print('team training 200 ' + response.body);
    } else {
      print('team training else ' + response.body);
    }

    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['WFTrainingReqList'];

    for (var teamData in jsonArray) {
      TeamTraining_RequestModel teamTraining_RequestModel =
          TeamTraining_RequestModel(
              wtxn_id: teamData['wtxn_id'],
              wtxn_requester_empid: teamData['wtxn_requester_empid'],
              rft_requester_name: teamData['rft_requester_name'],
              wtxn_request_date: teamData['wtxn_request_date'],
              wtxn_profile_url: teamData['wtxn_profile_url'],
              wtxn_status: teamData['wtxn_status'],
              rft_tm_name: teamData['rft_tm_name'],
              rft_training_outcome: teamData['rft_training_outcome'],
              rft_startdate: teamData['rft_startdate'],
              rft_enddate: teamData['rft_enddate'],
              rft_criteria_applied_skill:
                  teamData['rft_criteria_applied_skill'],
              rft_tm_fee: teamData['rft_tm_fee']);

      List<TeamTraining_RequestModel> data = [];
      data.add(teamTraining_RequestModel);

      for (int i = 0; i < data.length; i++) {
        if (data[i].wtxn_status == 'Approved') {
          team_data.add(teamTraining_RequestModel);
        }
      }
    }

    return team_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: getTeam_TrainingRequest(),
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
                  if (team_data.length == 0) {
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
                    return ListView.builder(
                        itemCount: team_data.length,
                        shrinkWrap: true,
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
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      team_data[index].wtxn_profile_url.toString(),
                                                      fit: BoxFit.cover,
                                                      width: 80,
                                                      height: 80,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 12),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        team_data[index].wtxn_requester_empid.toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'pop',
                                                            fontSize: 14),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4,
                                                                left: 4),
                                                        child: Text(
                                                          team_data[index].rft_requester_name.toString(),
                                                          style: TextStyle(
                                                              fontFamily: 'pop',
                                                              fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Text(
                                            team_data[index].wtxn_request_date.toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'pop'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 8),
                                      child: Text(
                                        team_data[index].rft_tm_name.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'pop',
                                            color: MyColor.mainAppColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: MyColor.green_color)),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(
                                              team_data[index].wtxn_status.toString(),
                                              style: TextStyle(
                                                  color: MyColor.green_color),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
