import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demo/trip_request_panel/model/send_trip_model.dart';

class Trip_Request_ApiServices {
  Future<Send_TripModel> send_Trip_Request(
    String user_id,
    String rfbt_startdate,
    String rfbt_enddate,
    String rfbt_desti_id,
    String rfbt_distance,
    String rfbt_accomodation,
    String rfbt_meal,
    String rfbt_travelwith,
    String rfbt_ticket_level,
    String rfbt_companyaccomodation,
    String rfbt_note,
    String rfbt_dailyallownces,
    String rfbt_carrent,
    String rfbt_visarequired,
    String rfbt_extra_days,
    String rfbt_nod_accomodation,
    String rfbt_id,
  ) async {
    var response = await http.post(Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_BUSINESS_TRIP_REQUEST'), body: {
      'emp_userid': user_id,
      'rfbt_startdate': rfbt_startdate,
      'rfbt_enddate': rfbt_enddate,
      'rfbt_desti_id': rfbt_desti_id,
      'rfbt_distance': rfbt_distance,
      'rfbt_accomodation': rfbt_accomodation,
      'rfbt_meal': rfbt_meal,
      'rfbt_travelwith': rfbt_travelwith,
      'rfbt_ticket_level': rfbt_ticket_level,
      'rfbt_companyaccomodation': rfbt_companyaccomodation,
      'rfbt_note': rfbt_note,
      'rfbt_dailyallownces': rfbt_dailyallownces,
      'rfbt_carrent': rfbt_carrent,
      'rfbt_visarequired': rfbt_visarequired,
      'rfbt_extra_days': rfbt_extra_days,
      'rfbt_nod_accomodation': rfbt_nod_accomodation,
      'rfbt_id': rfbt_id,
    }, headers: {
      'Authorization': ''
    });

   var jsonData=json.decode(response.body);

   if(response.statusCode==200){

     print('trip 200 '+response.body);

     return Send_TripModel(Status: jsonData['Status'], Message: jsonData['Message']);

   }else{

     print('trip 201'+response.body);
     return Send_TripModel(Status: jsonData['Status'], Message: jsonData['Message']);
   }
  }
}
