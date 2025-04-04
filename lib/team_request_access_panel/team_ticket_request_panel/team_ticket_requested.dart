import 'package:flutter/material.dart';

import '../../app_color/color_constants.dart';

class Team_Ticket_Requested extends StatefulWidget {
  const Team_Ticket_Requested({Key? key}) : super(key: key);

  @override
  _Team_Ticket_RequestedState createState() => _Team_Ticket_RequestedState();
}

class _Team_Ticket_RequestedState extends State<Team_Ticket_Requested> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Emp id',
                                          style: TextStyle(
                                              fontFamily: 'pop', fontSize: 12),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: 4, left: 4),
                                          child: Text(
                                            'TRA0123',
                                            style: TextStyle(
                                                fontFamily: 'pop',
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: MyColor.light_blue_color),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'travel mode',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'pop',
                                        color: MyColor.mainAppColor),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Des type -',
                                  style: TextStyle(
                                      fontFamily: 'pop',
                                      fontSize: 12,
                                      color: MyColor.mainAppColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Purpose',
                                  style: TextStyle(
                                      fontFamily: 'pop',
                                      fontSize: 12,
                                      color: MyColor.mainAppColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Delhi',
                                  style: TextStyle(
                                      fontFamily: 'pop',
                                      fontSize: 12,
                                      color: MyColor.mainAppColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.arrow_right_alt),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Shri Lanka',
                                  style: TextStyle(
                                      fontFamily: 'pop',
                                      fontSize: 12,
                                      color: MyColor.mainAppColor),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Apply date',
                                  style: TextStyle(
                                      fontFamily: 'pop', fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '28/04/2023',
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'pop'),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'From date',
                                  style: TextStyle(
                                      fontFamily: 'pop', fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '30/04/2023',
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'pop'),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'To date',
                                  style: TextStyle(
                                      fontFamily: 'pop', fontSize: 12),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '05/05/2023',
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: 'pop'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 0, right: 8),
                              decoration: BoxDecoration(
                                color: MyColor.mainAppColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 6, left: 12, right: 12),
                                child: Text(
                                  'Approved',
                                  style: TextStyle(
                                      color: MyColor.white_color,
                                      fontSize: 12,
                                      fontFamily: 'pop'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: MyColor.red_color),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 6, left: 12, right: 12),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      color: MyColor.red_color,
                                      fontSize: 12,
                                      fontFamily: 'pop'),
                                  textAlign: TextAlign.center,
                                ),
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
    );
  }
}
