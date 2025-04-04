import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';

class My_Timeline extends StatefulWidget {
  const My_Timeline({Key? key}) : super(key: key);

  @override
  _My_TimelineState createState() => _My_TimelineState();
}

class _My_TimelineState extends State<My_Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'pop'),
        ),
        backgroundColor: MyColor.mainAppColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8, top: 16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Search for rewards',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('All'),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('Anniversary'),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('Birthday'),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Container(
                            width: 260,
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Start appreciate here...',
                              ),
                              maxLines: 3,
                              minLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: 35,
                          alignment: Alignment.bottomRight,
                          height: 80,
                          child: SvgPicture.asset(
                            'assets/svgs/send.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('Teamwork'),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('Fast delivery'),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Text('Creative'),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                  elevation: 2,
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment.start,


                            children: [

                              Container(
                                height: 55,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 8),
                                child: Container(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Dheeraj sharma was appreciated by naresh pal',
                                        maxLines: 2,),
                                      Text(
                                        '2 day ago',
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Thanks for all the hardwork'),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8),
                          child: Container(
                            height: 220,
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/svgs/firework.svg'),
                          ),),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                  elevation: 2,
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment.start,


                            children: [

                              Container(
                                height: 55,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 8),
                                child: Container(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Dheeraj sharma was appreciated by naresh pal',
                                        maxLines: 2,),
                                      Text(
                                        '2 day ago',
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Thanks for all the hardwork'),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8),
                          child: Container(
                            height: 220,
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/svgs/firework.svg'),
                          ),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
