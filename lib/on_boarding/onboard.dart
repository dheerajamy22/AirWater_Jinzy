import 'package:demo/new_leave_managerdashboard/manager_leaveworkflow.dart';
import 'package:demo/workflow_request_panel/work_flow_request.dart';
import 'package:flutter/material.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../app_color/color_constants.dart';
import '../new_dashboard_2024/updated_dashboard_2024.dart';

class onboarding extends StatefulWidget {
  const onboarding({super.key});

  @override
  State<onboarding> createState() => _onboardingState();
}

class _onboardingState extends State<onboarding> {
  PageController _controller = PageController();
  bool onlastpage = false;

 void check_login_status() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? login_value = preferences.getString("login_check");
    bool? fromNotification = preferences.getBool('fromNotification');
    String? screenToNavigate = preferences.getString('notification_screen');
    String? emp_code = preferences.getString('emp_code');

    // If app is opened from a notification

    if (fromNotification == true) {
      // Navigate to workfromhome

      if (screenToNavigate == "leave") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => manager_workflow(
                      emp_code: '$emp_code',
                    )));

        preferences.setString('notification_screen', "");

        preferences.setBool('fromNotification', false);
      } else if (screenToNavigate == "attendance") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => My_Work_flow_Request(
                      emp_code: '$emp_code',
                    )));

        preferences.setString('notification_screen', "");
        preferences.setBool('fromNotification', false);
      }

      // After navigating, set 'fromNotification' to false to avoid navigating again next time
    } else {
      // If user is logged in, navigate to upcoming_dash

      if (login_value == "true") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => upcoming_dash()));
      }
    }
  }

  @override
  void initState() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      check_login_status();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColor.background_light_blue,
              MyColor.white_color,
              MyColor.white_color
            ],
          )),
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onlastpage = (index == 2);
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 80),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/onboarding_1.png',
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Track real-time\nattendance',
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'ns_bold'),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Stay connected, stay accountable. Track your attendance in real-time.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ns_regular',
                                        color: MyColor.grey_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 80),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/onboarding_2.png',
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Leave Application\nand Approval',
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'ns_bold'),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Streamline leave management, on-the-go approval. Welcome to effortless leave application and approval.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ns_regular',
                                        color: MyColor.grey_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 80),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/onboarding_3.png',
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, left: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Team Management',
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'ns_bold'),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Unify, organize, succeed. Empower your team with intuitive management. Welcome to seamless Team Management.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ns_regular',
                                        color: MyColor.grey_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),

                  /* Container(height: 200, child: onboard2()),
            Container(height: 200, child: onboard1()),*/
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new Login_Activity()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 55, right: 20),
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyColor.mainAppColor),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: MyColor.white_color,
                          fontFamily: "ns_medium",
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment(0, 0.85),
                  // alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmoothPageIndicator(
                            controller: _controller,
                            count: 3,
                            effect: WormEffect(
                                dotColor: MyColor.grey_color,
                                activeDotColor: MyColor.mainAppColor,
                                spacing: 8,
                                dotHeight: 12,
                                dotWidth: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: onlastpage
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FloatingActionButton(
                    backgroundColor: MyColor.mainAppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login_Activity()));
                    }),
              )
            : null);
  }
}
