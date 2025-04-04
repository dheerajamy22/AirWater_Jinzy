import 'package:flutter/material.dart';
import 'package:demo/team_request_access_panel/team_bussiness_trip_request/model/team_trip_request_model.dart';

import '../../app_color/color_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
class Team_Trip_Decline_Requested extends StatefulWidget {
  const Team_Trip_Decline_Requested({Key? key}) : super(key: key);

  @override
  _Team_Trip_Decline_Requested createState() => _Team_Trip_Decline_Requested();
}

class _Team_Trip_Decline_Requested extends State<Team_Trip_Decline_Requested> {
  List<Team_Trip_RequestModel> tripData = [];

  Future<List<Team_Trip_RequestModel>> getTrip_RequestModel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');

    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=WORKFLOW_BUSINESS_TRIP_REQUEST_LIST'),
        body: {'emp_userid': user_id.toString()},
        headers: {'Authorization': ''});
    if (response.statusCode == 200) {
      print('response 200 ' + response.body);
    } else {
      print('trip else ' + response.body);
    }

    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['WFBizztripReqList'];

    for (var trip in jsonArray) {
      Team_Trip_RequestModel team_trip_requestModel = Team_Trip_RequestModel(
          wtxn_id: trip['wtxn_id'],
          wtxn_status: trip['wtxn_status'],
          wtxn_requester_empid: trip['wtxn_requester_empid'],
          wtxn_profile_url: trip['wtxn_profile_url'],
          wtxn_request_date: trip['wtxn_request_date'],
          rfbt_startdate: trip['rfbt_startdate'],
          rfbt_enddate: trip['rfbt_enddate'],
          rfbt_desti_type: trip['rfbt_desti_type'],
          rfbt_accomodation: trip['rfbt_accomodation'],
          rfbt_meal: trip['rfbt_meal'],
          rfbt_travelwith: trip['rfbt_travelwith'],
          rfbt_ticket_level: trip['rfbt_ticket_level'],
          wtxn_request_type: trip['wtxn_request_type'],
          rfbt_requester_name: trip['rfbt_requester_name']);

      List<Team_Trip_RequestModel> data = [];
      data.add(team_trip_requestModel);

      for (int i = 0; i < data.length; i++) {
        if (data[i].wtxn_status == 'Declined') {
          tripData.add(team_trip_requestModel);
        }
      }
    }

    return tripData;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                  future: getTrip_RequestModel(),
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
                      if (tripData.length == 0) {
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
                            shrinkWrap: true,
                            itemCount: tripData.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                                          tripData[index]
                                                              .wtxn_profile_url
                                                              .toString(),
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
                                                            tripData[index].wtxn_requester_empid.toString(),
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
                                                              tripData[index].rfbt_requester_name.toString(),
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
                                                tripData[index].wtxn_request_date.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'pop'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 8),
                                          child: Text(
                                            'Purpose',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'pop',
                                                color: MyColor.mainAppColor),
                                          ),
                                        ),
                                        Text(
                                          tripData[index].rfbt_desti_type.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: 'pop',
                                              fontSize: 16,
                                              color: MyColor.mainAppColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    'Apply date',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                      tripData[index].wtxn_request_date.toString(),
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
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                      tripData[index].rfbt_startdate.toString(),
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
                                                        fontSize: 14,
                                                        fontFamily: 'pop'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(top: 4),
                                                    child: Text(
                                                      tripData[index].rfbt_enddate.toString(),
                                                      style: TextStyle(
                                                        fontFamily: 'pop',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  right: 0, left: 0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: MyColor.red_color),
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 20,
                                                    left: 20),
                                                child: Text(
                                                  tripData[index].wtxn_status.toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'pop',
                                                      color: MyColor.red_color),
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

