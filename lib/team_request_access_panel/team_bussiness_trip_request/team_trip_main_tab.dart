import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/team_request_access_panel/team_bussiness_trip_request/team_trip_approved.dart';
import 'package:demo/team_request_access_panel/team_bussiness_trip_request/team_trip_decline.dart';
import 'package:demo/team_request_access_panel/team_bussiness_trip_request/team_trip_requested_requested.dart';

class Team_Business_trip_Request extends StatefulWidget {
  const Team_Business_trip_Request({Key? key}) : super(key: key);

  @override
  _Team_Business_trip_RequestState createState() =>
      _Team_Business_trip_RequestState();
}

class _Team_Business_trip_RequestState extends State<Team_Business_trip_Request>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Trip request',
            style: TextStyle(fontSize: 16, fontFamily: 'pop',color: Colors.white),

          ),
          backgroundColor: Color(0xFF0054A4),
          elevation: 0,
        ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(color: MyColor.mainAppColor),
              child: Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: SingleChildScrollView(
                      child: Container(
                        height: 56,
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: TabBar(
                                controller: _tabController,
                                labelColor: Colors.black,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                labelStyle:
                                TextStyle(fontFamily: 'pop', fontSize: 14),
                                tabs: [
                                  Tab(
                                    text: 'Approved',
                                  ),
                                  Tab(
                                    text: 'Decline',
                                  ),
                                  Tab(
                                    text: 'Requested',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                Team_Trip_Approved_Request(),
                Team_Trip_Decline_Requested(),
                Team_Trip_Request_(),

              ],
            ))
          ],
        ),
      )

    );
  }
}
/* */