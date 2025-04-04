import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/document_request/doc_api_services/create_doc_api_services.dart';
import 'package:demo/document_request/model/create_doc_type_model.dart';
import 'package:demo/document_request/model/send_doc_model.dart';
import 'package:demo/main_home/mainHome.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Create_Doc_Request extends StatefulWidget {
  const Create_Doc_Request({Key? key}) : super(key: key);

  @override
  _Create_Doc_RequestState createState() => _Create_Doc_RequestState();
}

class _Create_Doc_RequestState extends State<Create_Doc_Request> {
  final _sendDoc_Services = DocRequest_ApiServices();
  TextEditingController req_name = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController note_controller = TextEditingController();
  List<Create_DocModel> docTypeModel = [];
  var _doc_list = [];
  String? _create_doc_string;
  bool is_doc_selected = false;
  String? doc_id = '';
  Create_DocModel? create_docModel;

  @override
  void initState() {
    getAllData();
    getAllDocReq();
    note_controller.text = '';
    super.initState();
  }

  Future<List<Create_DocModel>> getAllDocReq() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');
    //String? user_id = preferences.getString('user_id');
    var response = await http.get(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_MASTER_DOCUMENT_TYPE_FOR_DOCREQ'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print('doc type 200 ${response.body}');
    } else {
      print('doc type code ${response.body}');
    }

    var jsonData = json.decode(response.body);

    var jsonArray = jsonData['DocTypeList'];
    _doc_list = jsonData['DocTypeList'];

    print('countes' + docTypeModel.toString());
    for (var doc_Type in jsonArray) {
      Create_DocModel trainingType = Create_DocModel(
          doc_id: doc_Type['doc_id'], doc_name: doc_Type['doc_name']);

      docTypeModel.add(trainingType);
    }

    return docTypeModel;
  }

  void getAllData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_name = preferences.getString('user_name');
    var now = DateTime.now();
    var formetter = DateFormat('yyyy-MM-dd');
    String formettedDate = formetter.format(now);

    print(formettedDate);
    setState(() {
      req_name.text = '$user_name';
      date_controller.text = formettedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: MyColor.white_color,
            )),
        title: const Text(
          'Document request',
          style: TextStyle(
              fontSize: 16, fontFamily: 'pop', color: MyColor.white_color),
        ),
        elevation: 0,
        backgroundColor: MyColor.mainAppColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextField(
                      controller: req_name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'Requester name',
                          labelText: 'Requester name'),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                      child: TextField(
                    controller: date_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Request date',
                        labelText: 'Request date'),
                    readOnly: true,
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 0.0, left: 0.0),
                child: Container(
                  height: 52,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: DropdownButton<String>(
                        underline: Container(),
                        hint: const Text("Select Document type"),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: _doc_list.map((ctry) {
                          return DropdownMenuItem<String>(
                              value: ctry["doc_name"],
                              child: Text(ctry["doc_name"]));
                        }).toList(),
                        value: _create_doc_string,
                        onChanged: (value) {
                          setState(() {
                            _create_doc_string = value!;
                            for (int i = 0; i < _doc_list.length; i++) {
                              if (_doc_list[i]["doc_name"] == value) {
                                doc_id = _doc_list[i]["doc_id"].toString();
                                print('dropDown ' + doc_id.toString());
                              }
                            }
                            setState(() {});
                            is_doc_selected = true;
                          });
                        }),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Note',
                  style: TextStyle(
                      fontFamily: 'pop',
                      fontSize: 16,
                      color: MyColor.mainAppColor),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      controller: note_controller,
                      decoration: const InputDecoration(
                        // labelText: 'Description',
                        border: InputBorder.none,
                        hintText: 'Note',
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColor.mainAppColor),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: MyColor.white_color,
                            fontFamily: 'pop',
                            fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (validation()) {
                          send_DocRequest();
                        }
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (doc_id.toString() == '') {
      Flushbar(
        message: 'Please select document type',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);

      return false;
    } else if (note_controller.text == '') {
      Flushbar(
        message: 'Please enter note',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);

      return false;
    }
    return true;
  }

  void send_DocRequest() async {
    final ProgressDialog pr = await ProgressDialog(context);
    pr.show();
    SharedPreferences prf = await SharedPreferences.getInstance();
    String? user_id = prf.getString('user_id');

    Send_DocReq_Model send_docReq_Model =
        await _sendDoc_Services.sendDocRequest(
            user_id.toString(), doc_id.toString(), note_controller.text, '');

    if (send_docReq_Model.Status == '1') {
      pr.hide();
      Flushbar(
        message: send_docReq_Model.Message,
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => new MainHome()));
    } else {
      pr.hide();
      Flushbar(
        message: send_docReq_Model.Message,
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
    }
  }
}
