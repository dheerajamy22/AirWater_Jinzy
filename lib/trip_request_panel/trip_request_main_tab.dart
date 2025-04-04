import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/trip_request_panel/trip_approved_request.dart';
import 'package:demo/trip_request_panel/trip_decline_request.dart';
import 'package:demo/trip_request_panel/trip_requested_request.dart';

class Trip_Request_Main_Tab extends StatefulWidget {
  const Trip_Request_Main_Tab({Key? key}) : super(key: key);

  @override
  _Trip_Request_Main_TabState createState() => _Trip_Request_Main_TabState();
}

class _Trip_Request_Main_TabState extends State<Trip_Request_Main_Tab>
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
        elevation: 0.0,
        backgroundColor: Color(0xFF0054A4),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  'Trip request',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'pop',
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/images/powered_by_tag.png',
                    width: 90,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        /*title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,*/

      ),
      body: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(color: MyColor.mainAppColor),
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 12),
              child: Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 12),
                    child: Container(
                      height: 56,
                      width: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white54),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: TabBar(
                          controller: _tabController,
                          labelStyle:
                              TextStyle(fontFamily: 'pop', fontSize: 14),
                          labelColor: Colors.black,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyColor.white_color,
                          ),
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              Trip_Approved_Request(),
              Trip_Decline_Request(),
              Trip_Requested_Request(),
            ],
          ))
        ],
      ),
    );
  }
}
