import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo/travel_expenses/create_travel_model.dart';

class CreateTravel_ApiServices {
  Future<CreateTravel_Model> sendTravelRequest(
      String purpose,
      String destination,
      String from_date,
      String to_date,
      String total_estimate,
      String advance_payment,
      String description,
      String status,
      String user_id) async {
    var response = await http.post(Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_TRAVEL_EXPENSES_REQUEST'), body: {
      'trav_req_purpose': purpose,
      'trav_req_destination': destination,
      'trav_req_startdate': from_date,
      'trav_req_enddate': to_date,
      'trav_advance_payment': advance_payment,
      'trav_req_desc': description,
      'emp_userid': user_id,
      'trav_req_id': '',
      'trav_req_status': status,
    });
    var travel_data = json.decode(response.body);
    if (response.statusCode == 200) {
      print('yf '+response.body);

      return CreateTravel_Model(
          Status: travel_data['Status'], Message: travel_data['Message'],trav_req_id: travel_data['trav_req_id']);
    } else {
      print('yf1 '+response.body);

      return CreateTravel_Model(
          Status: travel_data['Status'], Message: travel_data['Message'],trav_req_id: travel_data['trav_req_id']);
    }
  }
}
