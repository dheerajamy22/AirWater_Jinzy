import 'package:flutter/material.dart';
import 'package:demo/travel_expenses/travel_approved.dart';
import 'package:demo/travel_expenses/travel_decline.dart';
import 'package:demo/travel_expenses/travel_request.dart';

class TravelMainTab extends StatefulWidget {
  @override
  _TravelMainTabState createState() => _TravelMainTabState();
}

class _TravelMainTabState extends State<TravelMainTab>
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
    // final double widht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF0054A4),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: const Text(
                  'Travel request',
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
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0),
                ),
                color: Color(0xFF0054A4),
              ),
              child: Stack(
                children: [
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: TabBar(
                                      controller: tabController,
                                      labelColor: Colors.black,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      labelStyle: const TextStyle(fontSize: 16.0),
                                      tabs:const [
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
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [
                Travel_Approved(),
                Travel_Decline(),
                Travel_Requested(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
