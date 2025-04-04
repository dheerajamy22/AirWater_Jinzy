import 'package:flutter/material.dart';

import '../app_color/color_constants.dart';

class Training_Requested_Request extends StatefulWidget {
  const Training_Requested_Request({Key? key}) : super(key: key);

  @override
  _Training_Requested_RequestState createState() =>
      _Training_Requested_RequestState();
}

class _Training_Requested_RequestState
    extends State<Training_Requested_Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, left: 12, right: 12),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MyColor.mainAppColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Image.asset(
                      'assets/images/add_icon.png',
                      width: 25,
                      height: 25,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(padding: EdgeInsets.only(left: 0),
                  child: Text(
                    'Create Training request',
                    style: TextStyle(
                      color: MyColor.mainAppColor,
                      fontFamily: 'pop',
                      fontSize: 14
                    ),
                  ),),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Requisition no-',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'pop',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    'RFT0001',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'pop',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          '01/05/2023',
                          style: TextStyle(
                              color: MyColor.mainAppColor,
                              fontFamily: 'pop',
                              fontSize: 14),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                      child: Text(
                        'Software developer',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'pop',
                            color: MyColor.mainAppColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MyColor.yellow_color)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Text(
                            'Requested',
                            style: TextStyle(
                                color: MyColor.yellow_color,
                                fontSize: 14,
                                fontFamily: 'pop'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
