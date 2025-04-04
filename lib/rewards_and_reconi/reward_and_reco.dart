import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';

class My_Reward_and_Reconization extends StatefulWidget {
  const My_Reward_and_Reconization({Key? key}) : super(key: key);

  @override
  State<My_Reward_and_Reconization> createState() =>
      _My_Reward_and_ReconizationState();
}

class _My_Reward_and_ReconizationState
    extends State<My_Reward_and_Reconization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Plaud transaction',
            style: TextStyle(fontFamily: 'pop', fontSize: 18),
          ),
          elevation: 0,
          backgroundColor: MyColor.mainAppColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        child: Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '5',
                              style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Sent',
                              style: TextStyle(fontFamily: 'pop'),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Flexible(
                        child: Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '2',
                              style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Recieve',
                              style: TextStyle(fontFamily: 'pop'),
                            ),
                          ],
                        ),
                      ),
                    )),
                    Flexible(
                        child: Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '63',
                              style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Redeem point',
                              style: TextStyle(fontFamily: 'pop'),
                                textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),
                    Flexible(
                        child: Card(
                      elevation: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '52',
                              style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Total  points',
                              style: TextStyle(fontFamily: 'pop'),textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
               Padding(padding: EdgeInsets.only(top: 16),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),
               Padding(padding: EdgeInsets.only(top: 8),
               child: Card(
                 elevation: 2,
                 child: Padding(padding: EdgeInsets.all(8.0),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                   child: Column(
                     children: [

                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Assigned to: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           Text('14/07/2023',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                         ],
                       ),
                       Padding(padding: EdgeInsets.only(top: 8),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Received by: Dheeraj sharma',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                             Text('points: 450',style: TextStyle(fontSize: 14,fontFamily: 'pop'),),
                           ],
                         ),
                       ),

                     ],
                   ),
                 ),),
               ),),

              ],
            ),
          ),
        ));
  }
}
