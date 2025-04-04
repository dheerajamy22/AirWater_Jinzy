import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/leave_process/create_leave_request.dart';
import 'package:demo/new_leave_page_by_Vikas_Sir/leavelist.dart';

class New_leavelist_mainpage extends StatefulWidget {
  const New_leavelist_mainpage({super.key});

  @override
  State<New_leavelist_mainpage> createState() => _New_leavelist_mainpageState();
}

class _New_leavelist_mainpageState extends State<New_leavelist_mainpage> {
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
                                        'assets/svgs/Createleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Create Leave',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreteLeaveRequest(self_select: 'Self',)));
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
                                        'assets/svgs/Approveleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Approve Leave',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const leavelist(

                                    )));
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
                                        'assets/svgs/Cancelleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Cancel Leave',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const leavelist(

                                    )));
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
                                        'assets/svgs/Draftleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Draft Leave',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const leavelist(

                                    )));
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
                                        'assets/svgs/Rejectleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Rejected Leave',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const leavelist(

                                    )));
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
                                        'assets/svgs/InReviewleave.svg'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'In Review Leave',
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
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const leavelist(

                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
