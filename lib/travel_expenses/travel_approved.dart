import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/travel_expenses/create_travel_expenses.dart';
import 'package:demo/travel_expenses/travel_expnses_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_color/color_constants.dart';

class Travel_Approved extends StatefulWidget {
  @override
  _Travel_ApprovedState createState() => _Travel_ApprovedState();
}

class _Travel_ApprovedState extends State<Travel_Approved> {
  List<Travel_Exp_Model> travel_Data = [];

  Future<List<Travel_Exp_Model>> getAllTravelData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_TRAVEL_EXPENSES_REQUEST_LIST'),
        body: {
          'emp_userid': user_id.toString(),
        });

    if (response.statusCode == 200) {
      print('travel response 200 ' + response.body);
    } else {
      print('travel response 200 ' + response.body);
    }

    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['TravelExpenseRequestList'];

    for (var travelData in jsonArray) {
      Travel_Exp_Model exp_model = Travel_Exp_Model(
          trav_req_code: travelData['trav_req_code'],
          trav_req_purpose: travelData['trav_req_purpose'],
          trav_req_destination: travelData['trav_req_destination'],
          trav_req_startdate: travelData['trav_req_startdate'],
          trav_req_enddate: travelData['trav_req_enddate'],
          trav_req_status: travelData['trav_req_status'],
          trav_req_requester_name: travelData['trav_req_requester_name'],
          trav_req_estimate: travelData['trav_req_estimate']);
      List<Travel_Exp_Model> data = [];
      data.add(exp_model);

      for (int i = 0; i < data.length; i++) {
        if (data[i].trav_req_status == 'Approved') {
          travel_Data.add(exp_model);
        }
      }
    }
    return travel_Data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            child: InkWell(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/add_icon.png",
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Create travel request",
                        style: TextStyle(color: Color(0xFF0054A4)),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new Create_Travel_Activty()));
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getAllTravelData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svgs/no_data_found.svg'),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                  color: MyColor.mainAppColor,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                   if(travel_Data.length==0){
                     return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SvgPicture.asset('assets/svgs/no_data_found.svg'),
                           Padding(
                             padding: EdgeInsets.only(top: 16),
                             child: Text(
                               'No data found',
                               style: TextStyle(
                                   color: MyColor.mainAppColor,
                                   fontSize: 16,
                                   fontFamily: 'pop'),
                             ),
                           )
                         ],
                       ),
                     );
                   }else{
                     return ListView.builder(
                       // physics: NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: travel_Data.length,
                         itemBuilder: (context, index) {

                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Card(
                               child: Padding(
                                 padding: EdgeInsets.all(8),
                                 child: Column(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.stretch,
                                   children: [
                                     Text(
                                       travel_Data[index].trav_req_code,
                                       textAlign: TextAlign.end,
                                     ),
                                     Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceEvenly,
                                       children: [
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "Apply date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(travel_Data[index]
                                                   .trav_req_estimate),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "From date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(travel_Data[index]
                                                   .trav_req_startdate),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "To date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(travel_Data[index]
                                                   .trav_req_enddate),
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                     InkWell(
                                       child: Padding(
                                         padding: EdgeInsets.only(
                                             top: 16,
                                             left: 90,
                                             right: 90,
                                             bottom: 8),
                                         child: Container(
                                           width: 120,
                                           height: 40,
                                           decoration: BoxDecoration(
                                             border: Border.all(
                                                 color: Colors.green),
                                             borderRadius:
                                             BorderRadius.circular(10),
                                           ),
                                           child: Center(
                                             child: Text(
                                               travel_Data[index]
                                                   .trav_req_status,
                                               style: TextStyle(
                                                 color: Colors.green,
                                                 fontFamily: 'pop',
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       onTap: () {
                                         /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainHome()),
                                        );*/
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           );

                         });
                   }
                  }
                }),
          )
        ],
      ),
    );
  }
}
