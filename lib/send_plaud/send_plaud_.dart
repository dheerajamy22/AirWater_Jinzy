import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';

class My_Send_Plaud extends StatefulWidget {
  const My_Send_Plaud({Key? key}) : super(key: key);

  @override
  _My_Send_PlaudState createState() => _My_Send_PlaudState();
}

class _My_Send_PlaudState extends State<My_Send_Plaud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plaud feed'),
        elevation: 0,
        backgroundColor: MyColor.mainAppColor,
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
                        child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: MyColor.light_blue_color,
                            alignment: Alignment.center,
                            height: 80,
                            child: SvgPicture.asset(
                              'assets/svgs/appreciate.svg',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Text(
                          'Appreciate',
                          style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                        )
                      ],
                    )),
                    Flexible(
                        child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: MyColor.light_blue_color,
                            alignment: Alignment.center,
                            height: 80,
                            child: SvgPicture.asset(
                              'assets/svgs/trophy.svg',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Text(
                          'Nominate',
                          style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                        )
                      ],
                    )),
                    Flexible(
                        child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: MyColor.light_blue_color,
                            alignment: Alignment.center,
                            height: 80,
                            child: SvgPicture.asset(
                              'assets/svgs/leader_board.svg',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Text(
                          'Leader board',
                          style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                        )
                      ],
                    )),
                    Flexible(
                        child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: MyColor.light_blue_color,
                            alignment: Alignment.center,
                            height: 80,
                            child: SvgPicture.asset(
                              'assets/svgs/appreciate.svg',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Text(
                          'total points',
                          style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                        )
                      ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
