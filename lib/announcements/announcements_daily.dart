import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/announcements/announcements_model.dart';
import 'package:http/http.dart' as http;

class UpComing_Announcements extends StatefulWidget {
  const UpComing_Announcements({Key? key}) : super(key: key);

  @override
  State<UpComing_Announcements> createState() => _UpComing_AnnouncementsState();
}

class _UpComing_AnnouncementsState extends State<UpComing_Announcements> {
  List<UpComing_Announce_Model> announceList = [];

  Future<List<UpComing_Announce_Model>> getAllList() async {
    var response = await http.get(
      Uri.parse(
          'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_ANNOUNCEMENT_LIST'),
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.body);
    }
    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['AnnouncementList'];

    for (var announData in jsonArray) {
      UpComing_Announce_Model upComing_Announce_Model = UpComing_Announce_Model(
          an_name: announData['an_name'], an_desc: announData['an_desc']);

      announceList.add(upComing_Announce_Model);
    }
    return announceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF0054A4),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  'Announcement',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'pop',
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/images/powered_by_tag.png',
                    width: 90,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        /*title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,*/

      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getAllList(),
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: announceList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    announceList[index].an_name,
                                    style: TextStyle(
                                        fontFamily: 'pop',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12, top: 2),
                                    child: Text(
                                      announceList[index].an_desc,
                                      style: TextStyle(
                                          fontFamily: 'pop',
                                          fontSize: 14,
                                          color: MyColor.grey_color),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
