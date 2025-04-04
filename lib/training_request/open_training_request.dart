import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_color/color_constants.dart';
import 'models/training_type_model.dart';
import 'package:http/http.dart' as http;

class Training_Decline_Request extends StatefulWidget {
  const Training_Decline_Request({Key? key}) : super(key: key);

  @override
  _Training_Decline_RequestState createState() =>
      _Training_Decline_RequestState();
}

class _Training_Decline_RequestState extends State<Training_Decline_Request> {
  List<TrainingType> training_data = [];

  Future<List<TrainingType>> getAllTrainingType() async {
    training_data.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');
    //String? user_id = preferences.getString('user_id');
    var response = await http.get(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_TRAINING_TYPE_FOR_TRAINING'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print('training type 200 ${response.body}');
    } else {
      print('training type code ${response.body}');
    }

    var jsonData = json.decode(response.body);

    var jsonArray = jsonData['TrainingTypeList'];

    print('counte' + training_data.toString());
    for (var training in jsonArray) {
      TrainingType trainingType = TrainingType(
          tm_id: training['tm_id'],
          tm_name: training['tm_name'],
          tm_fee: training['tm_fee'],
          tm_startdate: training['tm_startdate'],
          tm_enddate: training['tm_enddate'],
          tm_desc: training['tm_desc'],
          tm_skill_names: training['tm_skill_names']);
      training_data.add(trainingType);
    }

    return training_data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getAllTrainingType(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Column(),
                );
              } else {
                if(training_data.isEmpty){
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
                }else{
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: training_data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
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
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: Text(
                                                  training_data[index].tm_name.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'pop_m',
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        training_data[index].tm_startdate.toString(),
                                        style: const TextStyle(
                                            color: MyColor.mainAppColor,
                                            fontFamily: 'pop',
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 4, right: 4),
                                    child: Text(
                                      training_data[index].tm_desc,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: MyColor.mainAppColor),
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
