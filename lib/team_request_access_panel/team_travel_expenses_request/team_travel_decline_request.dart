import 'package:flutter/material.dart';

import '../../app_color/color_constants.dart';

class Team_Travel_Decline_Expenses extends StatefulWidget {
  const Team_Travel_Decline_Expenses({Key? key}) : super(key: key);

  @override
  _Team_Travel_Decline_ExpensesState createState() => _Team_Travel_Decline_ExpensesState();
}

class _Team_Travel_Decline_ExpensesState extends State<Team_Travel_Decline_Expenses> {
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
                                              fontFamily: 'pop', fontSize: 14),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(top: 4, left: 4),
                                          child: Text(
                                            'TRA0123',
                                            style: TextStyle(
                                                fontFamily: 'pop',
                                                fontSize: 14),
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
                            child: Text(
                              'type',
                              style: TextStyle(fontSize: 14, fontFamily: 'pop'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8),
                        child: Text(
                          'Purpose',
                          style: TextStyle(
                            fontFamily: 'pop',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2, left: 12),
                        child: Text(
                          'Purpose',
                          style: TextStyle(
                              fontFamily: 'pop',
                              fontSize: 14,
                              color: MyColor.mainAppColor),
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
                                      fontFamily: 'pop', fontSize: 14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '28/04/2023',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Advance',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '15000',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'From date',
                                  style: TextStyle(
                                      fontFamily: 'pop', fontSize: 14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '30/04/2023',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Due',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '5000',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'To date',
                                  style: TextStyle(
                                      fontFamily: 'pop', fontSize: 14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '05/05/2023',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'pop'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Total Expenses',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '20000',
                                    style: TextStyle(
                                        fontFamily: 'pop', fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Container(
                          margin: EdgeInsets.only(left: 100, right: 100),
                          decoration: BoxDecoration(
                              border: Border.all(color: MyColor.red_color),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 6,bottom: 6),
                            child: Text(
                              'Decline',style: TextStyle(
                                color: MyColor.red_color,
                                fontSize: 14,
                                fontFamily: 'pop'
                            ),
                              textAlign: TextAlign.center,

                            ),
                          ),
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
