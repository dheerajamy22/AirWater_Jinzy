import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/trip_request_panel/Create_trip_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demo/trip_request_panel/model/trip_requested_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trip_Approved_Request extends StatefulWidget {
  const Trip_Approved_Request({Key? key}) : super(key: key);

  @override
  _Trip_Approved_RequestState createState() => _Trip_Approved_RequestState();
}

class _Trip_Approved_RequestState extends State<Trip_Approved_Request> {
  List<Trip_Requested_ListModel> trip_data = [];

  Future<List<Trip_Requested_ListModel>> getTripRequest() async {
    trip_data.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_BUSINESS_TRIP_REQUEST_LIST'),
        body: {
          'emp_userid': user_id.toString(),
        });
    if (response.statusCode == 200) {
      print('trip response 200 ' + response.body);
    } else {
      print('trip response 201 ' + response.body);
    }
    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['BusinessTripRequestList'];

    for (var tripData in jsonArray) {
      Trip_Requested_ListModel trip_requested_listModel =
          Trip_Requested_ListModel(
              rfbt_code: tripData['rfbt_code'],
              rfbt_transdate: tripData['rfbt_transdate'],
              rfbt_startdate: tripData['rfbt_startdate'],
              rfbt_enddate: tripData['rfbt_enddate'],
              rfbt_desti_type: tripData['rfbt_desti_type'],
              rfbt_travelwith: tripData['rfbt_travelwith'],
              rfbt_ticket_level: tripData['rfbt_ticket_level'],
              rfbt_status: tripData['rfbt_status']);

      List<Trip_Requested_ListModel> data = [];
      data.add(trip_requested_listModel);



      print('trip '+trip_data.toString());
      for (int i = 0; i < data.length; i++) {
        if(data[i].rfbt_status=='Approved'){
          trip_data.add(trip_requested_listModel);
        }
      }
    }

    return trip_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8, left: 12, right: 12),
              //Create_Training_Request
              child: InkWell(
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
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          'Create Trip request',
                          style: TextStyle(
                              color: MyColor.mainAppColor,
                              fontFamily: 'pop',
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new Create_Trip_Request()));
                },
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: getTripRequest(),
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
                 if(trip_data.length==0){
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
                       itemCount: trip_data.length,
                       shrinkWrap: true,
                       itemBuilder: (context, index) {
                         print('data'+trip_data.length.toString());
                         return Padding(
                           padding: EdgeInsets.all(10),
                           child: Card(
                             elevation: 4,
                             child: Padding(
                               padding: EdgeInsets.all(10),
                               child: Column(
                                 children: [
                                   Column(
                                     crossAxisAlignment:
                                     CrossAxisAlignment.stretch,
                                     children: [
                                       Row(
                                         children: [
                                           Text(
                                             'Request id',
                                             style: TextStyle(
                                               color: Colors.black,
                                             ),
                                           ),
                                           Padding(
                                             padding: EdgeInsets.only(left: 12),
                                             child: Text(
                                               trip_data[index].rfbt_code.toString(),
                                               style: TextStyle(
                                                 color: Colors.black,
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                       Text(
                                         trip_data[index].rfbt_desti_type.toString(),
                                         textAlign: TextAlign.start,
                                         style: TextStyle(
                                             fontFamily: 'pop',
                                             fontSize: 16,
                                             color: MyColor.mainAppColor),
                                       ),
                                     ],
                                   ),
                                   Padding(
                                     padding: EdgeInsets.only(top: 8),
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceAround,
                                       children: [
                                         Column(
                                           children: [
                                             Text(
                                               'Apply date',
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontFamily: 'pop'),
                                             ),
                                             Padding(
                                               padding: EdgeInsets.only(top: 4),
                                               child: Text(
                                                 trip_data[index].rfbt_transdate.toString(),
                                                 style: TextStyle(
                                                     fontFamily: 'pop',
                                                     fontSize: 14),
                                               ),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Text(
                                               'From date',
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontFamily: 'pop'),
                                             ),
                                             Padding(
                                               padding: EdgeInsets.only(top: 4),
                                               child: Text(
                                                 trip_data[index].rfbt_startdate.toString(),
                                                 style: TextStyle(
                                                     fontSize: 14,
                                                     fontFamily: 'pop'),
                                               ),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Text(
                                               'To date',
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontFamily: 'pop'),
                                             ),
                                             Padding(
                                               padding: EdgeInsets.only(top: 4),
                                               child: Text(
                                                 trip_data[index].rfbt_enddate,
                                                 style: TextStyle(
                                                   fontFamily: 'pop',
                                                   fontSize: 14,
                                                 ),
                                               ),
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                   Padding(
                                     padding: EdgeInsets.only(top: 16),
                                     child: Container(
                                         margin:
                                         EdgeInsets.only(right: 0, left: 0),
                                         decoration: BoxDecoration(
                                             border: Border.all(
                                                 color: MyColor.green_color),
                                             borderRadius:
                                             BorderRadius.circular(10)),
                                         child: Padding(
                                           padding: EdgeInsets.only(
                                               top: 10,
                                               bottom: 10,
                                               right: 20,
                                               left: 20),
                                           child: Text(
                                             trip_data[index].rfbt_status.toString(),
                                             style: TextStyle(
                                                 fontSize: 14,
                                                 fontFamily: 'pop',
                                                 color: MyColor.green_color),
                                           ),
                                         )),
                                   )
                                 ],
                               ),
                             ),
                           ),
                         );
                       });
                 }
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
