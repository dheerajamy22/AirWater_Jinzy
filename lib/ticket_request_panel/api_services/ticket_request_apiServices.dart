import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo/ticket_request_panel/model/send_requestModel.dart';

class Ticket_Request_ApiServces {
  Future<SendRequest_Model> sendTicket_Request(
    String user_id,
    String rfticket_startdate,
    String rfticket_enddate,
    String rfticket_desti_type,
    String rfticket_purpose,
    String rfticket_from_country,
    String rfticket_to_country,
    String rfticket_from_desti,
    String rfticket_to_desti,
    String rfticket_desc,
    String rfticket_id,
    String rfticket_travel_mode,
  ) async {
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_TICKET_REQUEST'),
        body: {
          'emp_userid': user_id,
          'rfticket_startdate': rfticket_startdate,
          'rfticket_enddate': rfticket_enddate,
          'rfticket_desti_type': rfticket_desti_type,
          'rfticket_purpose': rfticket_purpose,
          'rfticket_from_country': rfticket_from_country,
          'rfticket_to_country': rfticket_to_country,
          'rfticket_from_desti': rfticket_from_desti,
          'rfticket_to_desti': rfticket_to_desti,
          'rfticket_desc': rfticket_desc,
          'rfticket_id': rfticket_id,
          'rfticket_travel_mode': rfticket_travel_mode,
        },
        headers: {
          'Authorization': ''
        });
    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return SendRequest_Model(
          Status: jsonData['Status'], Message: jsonData['Message']);
    } else {
      print(response.body);
      return SendRequest_Model(
          Status: jsonData['Status'], Message: jsonData['Message']);
    }
  }
}
