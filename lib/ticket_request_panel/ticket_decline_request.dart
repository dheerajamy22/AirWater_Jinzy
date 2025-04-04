import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'create_ticket_request.dart';
import 'model/ticket_model.dart';

class Ticket_Decline_Request extends StatefulWidget {
  const Ticket_Decline_Request({Key? key}) : super(key: key);

  @override
  _Ticket_Decline_RequestState createState() => _Ticket_Decline_RequestState();
}

class _Ticket_Decline_RequestState extends State<Ticket_Decline_Request> {
  @override
  Widget build(BuildContext context) {
    List<TicketModel> ticket_data = [];
    Future<List<TicketModel>> getAllData() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? user_id = pref.getString('user_id');
      var response = await http.post(
          Uri.parse(
              'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_TICKET_REQUEST_LIST'),
          body: {'emp_userid': user_id.toString()});

      if (response.statusCode == 200) {
        print('object' + response.body);
      }

      var jsonObject = json.decode(response.body);

      var jsonArray = jsonObject['TicketRequestList'];

      for (var data in jsonArray) {
        TicketModel ticketModel = TicketModel(
            rfticket_code: data['rfticket_code'],
            rfticket_adddate: data['rfticket_adddate'],
            rfticket_startdate: data['rfticket_startdate'],
            rfticket_enddate: data['rfticket_enddate'],
            rfticket_travel_mode: data['rfticket_travel_mode'],
            rfticket_status: data['rfticket_status'],
            rfticket_from_country: data['rfticket_from_country'],
            rfticket_to_country: data['rfticket_to_country']);

        List<TicketModel> t_data = [];
        t_data.add(ticketModel);

        for (int i = 0; i < t_data.length; i++) {
          if (t_data[i].rfticket_status == 'Reject') {
            ticket_data.add(ticketModel);
          }
        }
      }
      return ticket_data;
    }

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
                          'Create Ticket request',
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
                      builder: (context) => new Create_Ticket_Request()));
                },
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svgs/no_data_found.svg'),
                        Padding(padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            color: MyColor.mainAppColor,
                            fontSize: 16,
                            fontFamily: 'pop'
                          ),
                        ),)
                      ],
                    ),
                  );
                } else {
                  if(ticket_data.length==0){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svgs/no_data_found.svg'),
                          Padding(padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                  color: MyColor.mainAppColor,
                                  fontSize: 16,
                                  fontFamily: 'pop'
                              ),
                            ),)
                        ],
                      ),
                    );
                  }else{
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: ticket_data.length,
                        itemBuilder: (context, index) {

                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 8, left: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Des type -',
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12,
                                                      color:
                                                      MyColor.mainAppColor),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  ticket_data[index]
                                                      .rfticket_travel_mode
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12,
                                                      color:
                                                      MyColor.mainAppColor),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  ticket_data[index]
                                                      .rfticket_from_country
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12,
                                                      color:
                                                      MyColor.mainAppColor),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(Icons.arrow_right_alt),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  ticket_data[index]
                                                      .rfticket_to_country
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12,
                                                      color:
                                                      MyColor.mainAppColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Apply date',
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    ticket_data[index]
                                                        .rfticket_adddate
                                                        .toString()
                                                        .length >
                                                        12
                                                        ? ticket_data[index]
                                                        .rfticket_adddate
                                                        .toString()
                                                        .substring(
                                                        0, 12) +
                                                        ''
                                                        : ticket_data[index]
                                                        .rfticket_adddate,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'pop'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'From date',
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    ticket_data[index]
                                                        .rfticket_startdate
                                                        .toString()
                                                        .length >
                                                        12
                                                        ? ticket_data[index]
                                                        .rfticket_startdate
                                                        .toString()
                                                        .substring(
                                                        0, 12) +
                                                        ''
                                                        : ticket_data[index]
                                                        .rfticket_startdate
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'pop'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'To date',
                                                  style: TextStyle(
                                                      fontFamily: 'pop',
                                                      fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    ticket_data[index]
                                                        .rfticket_enddate
                                                        .toString()
                                                        .length >
                                                        12
                                                        ? ticket_data[index]
                                                        .rfticket_enddate
                                                        .toString()
                                                        .substring(
                                                        0, 12) +
                                                        ''
                                                        : ticket_data[index]
                                                        .rfticket_enddate
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'pop'),
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: MyColor.red_color),
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 20,
                                                    right: 20),
                                                child: Text(
                                                  ticket_data[index]
                                                      .rfticket_status
                                                      .toString(),
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
                            );

                        });
                  }

                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
