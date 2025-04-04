import 'dart:convert';

import 'package:demo/training_request/models/SendCreateTraining_Models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendRequest_ApiServices {
  Future<Training_Request_Model> sendTrainingRequest(String user_id,
      String traing_id, String specify, String justification) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('user_id');
    var response = await http.post(
        Uri.parse(
            "https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_TRAINING_REQUEST"),
        body: {
          'emp_userid': user_id,
          'rft_tm_id': traing_id,
          'rft_specify_objective': specify,
          'rft_justification': justification
        },
        headers: {
          'Authorization': ''
        });
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return Training_Request_Model(Status: jsonData['Status'], Message: jsonData['Message']);
    } else {
      print(response.body);
      return Training_Request_Model(Status: jsonData['Status'], Message: jsonData['Message']);
    }
  }
}
