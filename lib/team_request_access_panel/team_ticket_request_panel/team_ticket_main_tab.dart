import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/team_request_access_panel/team_ticket_request_panel/team_ticket_approved.dart';
import 'package:demo/team_request_access_panel/team_ticket_request_panel/team_ticket_decline.dart';
import 'package:demo/team_request_access_panel/team_ticket_request_panel/team_ticket_requested.dart';

class Team_Ticket_Main_Tab extends StatefulWidget {
  const Team_Ticket_Main_Tab({Key? key}) : super(key: key);

  @override
  _Team_Ticket_Main_TabState createState() => _Team_Ticket_Main_TabState();
}

class _Team_Ticket_Main_TabState extends State<Team_Ticket_Main_Tab>
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
          'Ticket request',
          style: TextStyle(fontSize: 16, fontFamily: 'pop',color: Colors.white),

        ),
        backgroundColor: const Color(0xFF0054A4),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 90,
            decoration: const BoxDecoration(color: MyColor.mainAppColor),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: Colors.white54,
                    borderRadius: BorderRadius.circular(10)),
      
                    child: Padding(
                      padding: const EdgeInsets.all(4),
      
                      child:  TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      labelStyle: const TextStyle(
                          fontFamily: 'pop',
                          fontSize: 14
                      ),
                      tabs: const [
                        Tab(text: 'Approved',),
                        Tab(text: 'Decline',),
                        Tab(text: 'Requested',),
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
            children: const [
              Team_Ticket_Approved(),
              Team_Ticket_Decline(),
              Team_Ticket_Requested()
            ],
          ))
        ],
      ),
    );
  }
}
