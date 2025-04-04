import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:http/http.dart' as http;
import 'package:demo/ticket_request_panel/create_ticket_request.dart';
import 'package:demo/ticket_request_panel/model/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticket_Approved_Request extends StatefulWidget {
  const Ticket_Approved_Request({Key? key}) : super(key: key);

  @override
  State<Ticket_Approved_Request> createState() =>
      _Ticket_Approved_RequestState();
}

class _Ticket_Approved_RequestState extends State<Ticket_Approved_Request> {
  @override
  Widget build(BuildContext context) {
    List<TicketModel> ticket_model = [];

    Future<List<TicketModel>> getTicketData() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? user_id = pref.getString('user_id');
      var response = await http.post(
          Uri.parse(
              'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_TICKET_REQUEST_LIST'),
          body: {'emp_userid': user_id.toString()});

      if (response.statusCode == 200) {
        print(response.body);
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
          if (t_data[i].rfticket_status == 'Approved') {
            ticket_model.add(ticketModel);
          }
        }
      }
      return ticket_model;
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
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
                      padding: const EdgeInsets.only(right: 0),
                      child: Image.asset(
                        'assets/images/add_icon.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Padding(
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
                    builder: (context) => const Create_Ticket_Request()));
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: getTicketData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/svgs/no_data_found.svg'),
                      const Padding(
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
                if (ticket_model.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svgs/no_data_found.svg'),
                        const Padding(
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
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: ticket_model.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Des type -',
                                              style: TextStyle(
                                                  fontFamily: 'pop',
                                                  fontSize: 12,
                                                  color:
                                                      MyColor.mainAppColor),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              ticket_model[index]
                                                  .rfticket_travel_mode
                                                  .toString(),
                                              style: const TextStyle(
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
                                              ticket_model[index]
                                                  .rfticket_from_country
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'pop',
                                                  fontSize: 12,
                                                  color:
                                                      MyColor.mainAppColor),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(Icons.arrow_right_alt),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ticket_model[index]
                                                  .rfticket_to_country
                                                  .toString(),
                                              style: const TextStyle(
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
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'Apply date',
                                              style: TextStyle(
                                                  fontFamily: 'pop',
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                ticket_model[index]
                                                            .rfticket_adddate
                                                            .toString()
                                                            .length >
                                                        12
                                                    ? ticket_model[index]
                                                            .rfticket_adddate
                                                            .toString()
                                                            .substring(
                                                                0, 12) +
                                                        ''
                                                    : ticket_model[index]
                                                        .rfticket_adddate
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'pop',
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'From date',
                                              style: TextStyle(
                                                  fontFamily: 'pop',
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                ticket_model[index]
                                                            .rfticket_startdate
                                                            .toString()
                                                            .length >
                                                        12
                                                    ? ticket_model[index]
                                                            .rfticket_startdate
                                                            .toString()
                                                            .substring(
                                                                0, 12) +
                                                        ''
                                                    : ticket_model[index]
                                                        .rfticket_startdate
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'pop'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'To date',
                                              style: TextStyle(
                                                  fontFamily: 'pop',
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                ticket_model[index]
                                                            .rfticket_enddate
                                                            .toString()
                                                            .length >
                                                        12
                                                    ? ticket_model[index]
                                                            .rfticket_enddate
                                                            .toString()
                                                            .substring(
                                                                0, 12) +
                                                        ''
                                                    : ticket_model[index]
                                                        .rfticket_enddate
                                                        .toString(),
                                                style: const TextStyle(
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
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 0, right: 0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 20,
                                                right: 20),
                                            child: Text(
                                              ticket_model[index]
                                                  .rfticket_status
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: MyColor.green_color,
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
    );
  }
}
