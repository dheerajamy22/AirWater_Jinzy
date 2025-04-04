import 'package:demo/document_request/model/send_doc_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class DocRequest_ApiServices {

  Future<Send_DocReq_Model> sendDocRequest(String user_id, String rfdoc_doc_id,
      String rfdoc_note, String rfdoc_id) async{

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');

    var response = await http.post(Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_DOCUMENT_REQUEST'),
    body: {
      'emp_userid':user_id.toString(),
      'rfdoc_doc_id':rfdoc_doc_id,
      'rfdoc_note':rfdoc_note,
      'rfdoc_id':rfdoc_id,
    });

    var jsonData = json.decode(response.body);

    if(response.statusCode==200){
      return Send_DocReq_Model(Status: jsonData['Status'], Message: jsonData['Message']);
    }else{
      return Send_DocReq_Model(Status: jsonData['Status'], Message: jsonData['Message']);
    }

  }
}