import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/new_leave_managerdashboard/new_managerleavedashboard.dart';
import 'package:demo/team_request_access_panel/team_bussiness_trip_request/team_trip_main_tab.dart';
import 'package:demo/team_request_access_panel/team_request_dashboard/team_dashboard_model/team_dashboard_model.dart';
import 'package:demo/team_request_access_panel/team_ticket_request_panel/team_ticket_main_tab.dart';
import 'package:demo/team_request_access_panel/team_training_request/team_training_main_tab.dart';
import 'package:demo/team_request_access_panel/team_travel_expenses_request/team_travel_expenses_main_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Team_main_request_access extends StatefulWidget {
  const Team_main_request_access({Key? key}) : super(key: key);

  @override
  _Team_main_request_accessState createState() =>
      _Team_main_request_accessState();
}

class _Team_main_request_accessState extends State<Team_main_request_access> {
  @override
  Widget build(BuildContext context) {
    List<Team_dashboard_Model> dashboard_data = [];

    Future<List<Team_dashboard_Model>> getAllRequest() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? user_id = sharedPreferences.getString('user_id');
      // var response = await http.post(
      //     Uri.parse(
      //         'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_WORKFLOW_REQUEST_STATISTICS'),
      //     body: {
      //       'emp_userid': '${user_id}',
      //     });
      // if (response.statusCode == 200) {
      //   print(response.body);
      // } else {
      //   print(response.body);
      // }

      // var teamData = json.decode(response.body);

      // var teamDataArray = teamData['wfStatisticsList'];

      dashboard_data.add(Team_dashboard_Model(
          request_name: "Attendance Request", request_pending: "0"));
      dashboard_data.add(Team_dashboard_Model(
          request_name: "Leave Request", request_pending: "0"));
      // dashboard_data.add(Team_dashboard_Model(
      //     request_name: "Document Request", request_pending: "0"));
      // dashboard_data.add(Team_dashboard_Model(
      //     request_name: "Ticket Request", request_pending: "0"));

      // for (teamData in teamDataArray) {
      //   Team_dashboard_Model team_dashboard_model = Team_dashboard_Model(
      //       request_name: teamData['request_name'],
      //       request_pending: teamData['request_pending']);

      //   dashboard_data.add(team_dashboard_model);
      // }

      return dashboard_data;
    }

    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: MyColor.white_color,
            )),
        title: const Text(
          'Team Request',
          style: TextStyle(
              fontSize: 16, fontFamily: 'pop', color: MyColor.white_color),
        ),
        backgroundColor: const Color(0xFF0054A4),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 130,
            color: const Color(0xFF0054A4),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 48, left: 8, right: 8),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                        future: getAllRequest(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              child: const Column(),
                            );
                          } else {
                            return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                        //childAspectRatio: 1.30,
                                        mainAxisExtent: 160),
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: dashboard_data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        margin: const EdgeInsets.all(4),
                                        child: Container(

                                          decoration: BoxDecoration(
                                              color: MyColor.white_color
                                              ,borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (dashboard_data[index]
                                                          .request_name ==
                                                      'Leave Request') ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/leave_req.png'))),
                                                    ),
                                                  ] else if (dashboard_data[
                                                              index]
                                                          .request_name ==
                                                      'Training Request') ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/training_req.png'))),
                                                    ),
                                                  ] else if (dashboard_data[
                                                              index]
                                                          .request_name ==
                                                      'Business Trip Request') ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/trip_req.png'))),
                                                    ),
                                                  ] else if (dashboard_data[
                                                              index]
                                                          .request_name ==
                                                      'Travel Expenses Request') ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/travel_req.png'))),
                                                    ),
                                                  ] else if (dashboard_data[
                                                              index]
                                                          .request_name ==
                                                      'Ticket Request') ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/ticket_req.png'))),
                                                    ),
                                                  ]else if (dashboard_data[
                                                              index]
                                                          .request_name ==
                                                      'Attendance Request') ...[
                                                    Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: SvgPicture.asset("assets/svgs/Attendancerequest.svg"),
                                                      ),
                                                    ),
                                                  ]
                                                   else ...[
                                                    Container(
                                                      height: 60,
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                        'assets/images/information_profile.png',
                                                      ))),
                                                    ),
                                                  ],
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    dashboard_data[index]
                                                        .request_name,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'pop'),
                                                  )
                                                ],
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.end,
                                              //   children: [
                                              //     Padding(
                                              //       padding:
                                              //           const EdgeInsets.only(
                                              //               top: 4, right: 8),
                                              //       child: Container(
                                              //         alignment:
                                              //             Alignment.center,
                                              //         width: 25,
                                              //         height: 25,
                                              //         decoration:
                                              //             const BoxDecoration(
                                              //           // border: Border.all(color: Colors.lightBlueAccent),
                                              //           shape: BoxShape.circle,
                                              //           color:
                                              //               Color(0XFFEEF7FF),
                                              //         ),
                                              //         child: Text(
                                              //           dashboard_data[index]
                                              //               .request_pending,
                                              //           style: const TextStyle(
                                              //               fontSize: 14,
                                              //               fontFamily: 'pop',
                                              //               color: Color(
                                              //                   0xFF0054A4)),
                                              //           textAlign:
                                              //               TextAlign.center,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (dashboard_data[index]
                                                .request_name ==
                                            'Leave Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                     new_leavemanagerdashboard()));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Training Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Team_Training_Main_Tab(
                                                          title: dashboard_data[
                                                                  index]
                                                              .request_name)));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Training Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Team_Training_Main_Tab(
                                                          title: dashboard_data[
                                                                  index]
                                                              .request_name)));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Business Trip Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Team_Business_trip_Request()));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Travel Expenses Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Team_Travel_Expenses_Main_Tab()));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Ticket Request') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Team_Ticket_Main_Tab()));
                                        } else if (dashboard_data[index]
                                                .request_name ==
                                            'Attendance Request') {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             My_Work_flow_Request()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Cooming soon')));
                                        }
                                      },
                                    ),
                                  );
                                }
                                /* else{
                            return Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svgs/no_data_found.svg",
                                      width: 100,
                                      height: 100,
                                      alignment: Alignment.center,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 0.0),
                                      child: Text(
                                        'No record found!',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontFamily: 'pop',
                                            fontStyle: FontStyle.normal
                                        ),
                                        textAlign: TextAlign.center,
                                      ),)
                                  ],
                                ));
                          }*/
                                );
                          }
                        }),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
