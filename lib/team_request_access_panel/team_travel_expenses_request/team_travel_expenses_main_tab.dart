import 'package:flutter/material.dart';
import 'package:demo/team_request_access_panel/team_travel_expenses_request/team_travel_decline_request.dart';
import 'package:demo/team_request_access_panel/team_travel_expenses_request/team_travel_expenses_approved.dart';
import 'package:demo/team_request_access_panel/team_travel_expenses_request/team_travel_expenses_requested.dart';

class Team_Travel_Expenses_Main_Tab extends StatefulWidget {
  const Team_Travel_Expenses_Main_Tab({Key? key}) : super(key: key);

  @override
  _Team_Travel_Expenses_Main_TabState createState() =>
      _Team_Travel_Expenses_Main_TabState();
}

class _Team_Travel_Expenses_Main_TabState
    extends State<Team_Travel_Expenses_Main_Tab>
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
        title: const Text(
          'Travel Expense request',
          style:
              TextStyle(fontSize: 16, fontFamily: 'pop', color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0054A4),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
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
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
                            padding: const EdgeInsets.all(4),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.black,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              labelStyle:
                                  const TextStyle(fontSize: 14, fontFamily: 'pop'),
                              tabs: const [
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
            children: const [
              Team_Travel_Expenses_Approved(),
              Team_Travel_Decline_Expenses(),
              Team_Travel_Requested_Expenses(),
            ],
          ))
        ],
      ),
    );
  }
}
