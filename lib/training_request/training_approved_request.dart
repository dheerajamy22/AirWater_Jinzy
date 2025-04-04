import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/training_request/create_training_request.dart';
import 'package:demo/training_request/models/Training_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Training_Approved_Request extends StatefulWidget {
  const Training_Approved_Request({Key? key}) : super(key: key);

  @override
  _Training_Approved_RequestState createState() =>
      _Training_Approved_RequestState();
}

class _Training_Approved_RequestState extends State<Training_Approved_Request> {
  List<Training_model> training_data = [];

  Future<List<Training_model>> getAllTraining_Request() async {
    training_data.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_TRAINING_REQUEST_LIST'),
        body: {'emp_userid': user_id.toString()},
        headers: {'Authorization': ''});

    var jsonData = json.decode(response.body);
    var jsonArray = jsonData['TrainingRequestList'];

    for (var training in jsonArray) {

      Training_model training_model = Training_model(
          rft_tm_name: training['rft_tm_name'],
          rft_req_date: training['rft_req_date'],
          rft_status: training['rft_status'],
          rft_code: training['rft_code']);

      training_data.add(training_model);
    }

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('data not found');
    }

    return training_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        'Create Training request',
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
                    builder: (context) => new Create_Training_Request()));
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: getAllTraining_Request(),
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
                    if(training_data.length==0){
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
                          shrinkWrap: true,
                          itemCount: training_data.length,
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
                                                      training_data[index].rft_code.toString(),
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
                                            training_data[index].rft_req_date.toString(),
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
                                          training_data[index].rft_tm_name.toString(),
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
                                              border: Border.all(color: MyColor.green_color)),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20, top: 10, bottom: 10),
                                            child: Text(
                                              training_data[index].rft_status.toString(),
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
              )),
        ],
      ),
    );
  }
}
/*


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
                            border: Border.all(color: MyColor.green_color)),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Text(
                            'Approved',
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
          )

* */
