import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/training_request/training_approved_request.dart';
import 'package:demo/training_request/open_training_request.dart';


class Training_Main_Tab extends StatefulWidget {
  const Training_Main_Tab({Key? key}) : super(key: key);

  @override
  _Training_Main_TabState createState() => _Training_Main_TabState();
}

class _Training_Main_TabState extends State<Training_Main_Tab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: const Color(0xFF0054A4),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: const Text(
                  'Training request',
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
      body: Container(
        child: Column(
          children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                color: MyColor.mainAppColor,
              ),
              child: Stack(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Container(
                      height: 56,
                      width: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white54),
                      child: Padding(padding: const EdgeInsets.all(4),
                        child: TabBar(
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          controller: _tabController,
                          labelStyle: const TextStyle(fontFamily: 'pop', fontSize: 14),
                          labelColor: Colors.black,
                          tabs: const [
                            Tab(
                              text: 'Open training',
                            ),
                            Tab(
                              text: 'Requisition',
                            ),

                          ],
                        ),),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: const [
                Training_Decline_Request(),
                Training_Approved_Request(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
