import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/team_request_access_panel/team_leave_request/team_leave_approved_access.dart';
import 'package:demo/team_request_access_panel/team_leave_request/team_leave_decline_access.dart';
import 'package:demo/team_request_access_panel/team_leave_request/team_leave_requested_access.dart';

class Team_Leave_Request extends StatefulWidget {
  final String title;
  const Team_Leave_Request({Key? key,required this.title}) : super(key: key);

  @override
  _Team_Leave_RequestState createState() => _Team_Leave_RequestState();
}

class _Team_Leave_RequestState extends State<Team_Leave_Request>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: MyColor.mainAppColor,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon:const Icon(Icons.arrow_back,color: MyColor.white_color,)),
        title: const Text(
          "Leave request",
          style:
              TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'pop'),
        ),
            elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(0),
                  ),
                  color: Color(0xFF0054A4)),
              child: Stack(
                children: [

                  // Create for three tab
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              height: 56,
                              width: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: TabBar(
                                      controller: tabController,
                                      labelColor: Colors.black,
                                       indicatorSize: TabBarIndicatorSize.tab,
                                      indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      labelStyle: const TextStyle(
                                          fontSize: 14, fontFamily: 'pop'),
                                      tabs:const [
                                         Tab(
                                          text: "Approved",
                                        ),
                                         Tab(
                                          text: "Decline",
                                        ),
                                         Tab(
                                          text: "Requested",
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Use for tab action
            Expanded(
                child: TabBarView(
              controller: tabController,
              children:const [
                 Team_Leave_Approved_Access(),
                 Team_Leave_Decline(),
                 Team_Leave_Requested_Access(),
              ],
            )),
            // Create leave button
          ],
        ),
      ),
    );
  }
}
