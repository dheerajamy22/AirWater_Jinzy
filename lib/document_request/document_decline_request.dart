import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:http/http.dart' as http;
import 'package:demo/document_request/model/document_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Document_Decline_Request extends StatefulWidget {
  const Document_Decline_Request({Key? key}) : super(key: key);

  @override
  _Document_Decline_RequestState createState() =>
      _Document_Decline_RequestState();
}

class _Document_Decline_RequestState extends State<Document_Decline_Request> {
  @override
  Widget build(BuildContext context) {
    List<DocumentModel> doc_data = [];
    Future<List<DocumentModel>> getAllDocData() async {
      doc_data.clear();
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? user_id=pref.getString('user_id');
      var response = await http.post(
          Uri.parse(
              'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_DOCUMENT_REQUEST_LIST'),
          body: {'emp_userid': user_id.toString()});

      if (response.statusCode == 200) {
        print(response.body);
      }

      var jsonData = json.decode(response.body);

      var jsonArray = jsonData['DocumentRequestList'];

      for (var data in jsonArray) {
        DocumentModel documentModel = DocumentModel(
            rfdoc_code: data['rfdoc_code'],
            rfdoc_adddate: data['rfdoc_adddate'],
            rfdoc_note: data['rfdoc_note'],
            rfdoc_doc_type: data['rfdoc_doc_type'],
            rfdoc_status: data['rfdoc_status']);
        List<DocumentModel> doc_ = [];
        doc_.add(documentModel);
        for (int i = 0; i < doc_.length; i++) {
          if (doc_[i].rfdoc_status == 'Reject') {
            doc_data.add(documentModel);
          }
        }
      }

      return doc_data;
    }

    return Scaffold(
      body: Column(
        children: [
          /*Padding(
              padding: EdgeInsets.only(top: 8, left: 12, right: 12),
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
                          'Create Document request',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Create_Doc_Request()));
                },
              )),*/
          Expanded(
              child: FutureBuilder(
            future: getAllDocData(),
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
                              fontFamily: 'pop',
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                if(doc_data.length==0){
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
                                fontFamily: 'pop',
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  );
                }else{
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: doc_data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Req Id-',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'pop',
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 4),
                                                child: Text(
                                                  doc_data[index].rfdoc_code.toString(),
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
                                        doc_data[index].rfdoc_adddate.toString(),
                                        style: TextStyle(
                                            color: MyColor.mainAppColor,
                                            fontFamily: 'pop',
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8, left: 4, right: 4),
                                        child: Text(
                                          'Requested Document',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 4, left: 8, right: 4),
                                        child: Text(
                                          doc_data[index].rfdoc_doc_type.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: MyColor.mainAppColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: MyColor.green_color)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Text(
                                          doc_data[index].rfdoc_status.toString(),
                                          style: TextStyle(
                                              color: MyColor.green_color,
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
