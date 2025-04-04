import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';

class new_leavemanagerdashboard extends StatefulWidget {
  const new_leavemanagerdashboard({super.key});

  @override
  State<new_leavemanagerdashboard> createState() =>
      _new_leavemanagerdashboardState();
}

class _new_leavemanagerdashboardState extends State<new_leavemanagerdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF0054A4),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: MyColor.white_color,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: const Text(
                    'Leave Board',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                        color: MyColor.white_color),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Image.asset(
                      'assets/images/powered_by_tag.png',
                      width: 90,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: MyColor.white_color
                              ,borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    /*decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/document.png'))),*/
                                    child: SvgPicture.asset(
                                        'assets/svgs/Approveleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Approved Leave',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                       /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const manager_workflow(type: "Approved")));*/
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: MyColor.white_color
                              ,borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    /*decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/document.png'))),*/
                                    child: SvgPicture.asset(
                                        'assets/svgs/Rejectleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Reject Leave',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                       /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const manager_workflow(type: "Rejected")));*/
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: MyColor.white_color
                              ,borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    /*decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/document.png'))),*/
                                    child: SvgPicture.asset(
                                        'assets/svgs/InReviewleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'In Review',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {

                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(4),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: MyColor.white_color
                              ,borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    alignment: Alignment.center,
                                    /*decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/document.png'))),*/
                                    child: SvgPicture.asset(
                                        'assets/svgs/Changerequest.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Change Request',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                      /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const manager_workflow(type: "Change")));*/
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
