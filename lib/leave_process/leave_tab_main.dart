import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/leave_process/approved_leave.dart';
import 'package:demo/leave_process/reject_leave.dart';
import 'package:demo/leave_process/requested_leave.dart';

class LeaveListActivity extends StatefulWidget {
  @override
  LeaveList_State createState() => LeaveList_State();
}

class LeaveList_State extends State<LeaveListActivity>
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
    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF0054A4),
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back,color: MyColor.white_color,)),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: const Text(
                    'Leave request',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'pop',color:MyColor.white_color ,
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
                                      dividerColor: Colors.transparent,
                                      indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      labelStyle: const TextStyle(
                                          fontSize: 16, fontFamily: 'pop'),
                                      tabs: const[
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
              children: [
                    Approved_leave_Tab(),
                    Reject_Leave_Activity(),
                    Requested_Leave_Activity(),
              ],
            )),
            // Create leave button

          ],
        ),
      ),
    );
  }
}
