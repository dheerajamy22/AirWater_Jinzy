import 'dart:convert';

import 'package:demo/leave_process/create_leave_module.dart';
import 'package:http/http.dart' as http;

class Create_Leave_ApiServices {
  @override
  Future<Create_LeaveModule> sendLeaveRequest(String from_date, String to_date,
      String leave_type, String descr,String total_day, String user_id) async {
    var response = await http.post(Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_LEAVE_REQUEST'), body: {
      'lr_from_date': from_date,
      'lr_to_date': to_date,
      'lr_leave_type': leave_type,
      'lr_leave_details': descr,
      'lr_total_days': total_day,
      'emp_userid': user_id,
    });

    var jsonData = json.decode(response.body);

    if(response.statusCode==200){
      print(response.body);
      return Create_LeaveModule(Status: jsonData['Status'], Message: jsonData['Message']);
    }else{
      print(response.body);
      return Create_LeaveModule(Status: jsonData['Status'], Message: jsonData['Message']);
    }
  }
}
