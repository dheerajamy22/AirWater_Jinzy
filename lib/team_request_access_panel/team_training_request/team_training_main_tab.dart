import 'package:flutter/material.dart';
import 'package:demo/team_request_access_panel/team_training_request/team_training_approved.dart';
import 'package:demo/team_request_access_panel/team_training_request/team_training_decline.dart';
import 'package:demo/team_request_access_panel/team_training_request/team_training_requested.dart';

class Team_Training_Main_Tab extends StatefulWidget {
  final String title;

  const Team_Training_Main_Tab({Key? key, required this.title})
      : super(key: key);

  @override
  _Team_Training_Main_TabState createState() => _Team_Training_Main_TabState();
}

class _Team_Training_Main_TabState extends State<Team_Training_Main_Tab>
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
          'Training request',
          style: TextStyle(fontSize: 16, fontFamily: 'pop',color: Colors.white),

        ),
        backgroundColor: Color(0xFF0054A4),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(0),
                  ),
                  color: Color(0xFF0054A4)),
              child: Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                    child: SingleChildScrollView(
                      child: Container(
                        height: 56,
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(10)),
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
                                    TextStyle(fontSize: 14, fontFamily: 'pop'),
                                tabs: [
                                  Tab(text: 'Approved'),
                                  Tab(text: 'Decline'),
                                  Tab(text: 'Requested'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
              children: [
                Team_Training_Aprroved_Request(),
                Team_Training_Decline_Request(),
                Team_Training_Requested_Request(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
