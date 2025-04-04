import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/main_home/mainHome.dart';
import 'package:demo/training_request/api_services/send_training_request.dart';
import 'package:demo/training_request/models/SendCreateTraining_Models.dart';
import 'package:demo/training_request/models/training_type_model.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Create_Training_Request extends StatefulWidget {
  const Create_Training_Request({Key? key}) : super(key: key);

  @override
  _Create_Training_RequestState createState() =>
      _Create_Training_RequestState();
}

class _Create_Training_RequestState extends State<Create_Training_Request> {
  List<TrainingType> trainingTypeList = [];
  var _training_list = [];
  String? _training_string;
  bool is_training_selected = false;
  String? training_id = '';
  String? start_dateString = '',
      end_date_String = '',
      fee_String = '',
      skill_String = '',
      outcome_String = '';

  TrainingType? trainingType_modul;
  String? user_name = '';

  TextEditingController req_name = TextEditingController();
  TextEditingController date_controller = TextEditingController();

  Future<List<TrainingType>> getAllTrainingType() async {
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
    _training_list = jsonData['TrainingTypeList'];

    print('counte' + _training_list.toString());
    for (var training in jsonArray) {
      TrainingType trainingType = TrainingType(
          tm_id: training['tm_id'],
          tm_name: training['tm_name'],
          tm_fee: training['tm_fee'],
          tm_startdate: training['tm_startdate'],
          tm_enddate: training['tm_enddate'],
          tm_desc: training['tm_desc'],
          tm_skill_names: training['tm_skill_names']);
      trainingTypeList.add(trainingType);
    }

    return trainingTypeList;
  }

  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  TextEditingController fee = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController outcome = TextEditingController();
  TextEditingController specify_objective = TextEditingController();
  final TextEditingController _justification = TextEditingController();
  final _sendRequest_Services = SendRequest_ApiServices();

  @override
  void initState() {
    specify_objective.text = '';
    _justification.text = '';
    getAllTrainingType();
    getAllData();
    super.initState();
  }

  void getAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    user_name = sharedPreferences.getString('user_name');
    var now =  DateTime.now();
    var formatter =  DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2023-05-29
    setState(() {
      req_name.text = '$user_name';
      date_controller.text = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traning Request',
          style: TextStyle(
              fontSize: 16, fontFamily: 'pop', color: MyColor.white_color),
        ),
        elevation: 0,
        backgroundColor: MyColor.mainAppColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
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
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Training details',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'pop_m',
                      color: MyColor.mainAppColor),
                  textAlign: TextAlign.start,
                ),
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
                        hint: const Text("Select Training type"),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: _training_list.map((ctry) {
                          return DropdownMenuItem<String>(
                              value: ctry["tm_name"],
                              child: Text(ctry["tm_name"]));
                        }).toList(),
                        value: _training_string,
                        onChanged: (value) {
                          setState(() {
                            _training_string = value!;
                            for (int i = 0; i < _training_list.length; i++) {
                              if (_training_list[i]["tm_name"] == value) {
                                training_id =
                                    _training_list[i]["tm_id"].toString();
                                start_dateString = _training_list[i]
                                        ['tm_startdate']
                                    .toString();
                                end_date_String =
                                    _training_list[i]['tm_enddate'].toString();
                                outcome_String =
                                    _training_list[i]['tm_desc'].toString();
                                fee_String =
                                    _training_list[i]['tm_fee'].toString();
                                skill_String = _training_list[i]
                                        ['tm_skill_names']
                                    .toString();
                                // print('dropDown ' + training_id.toString());
                              }
                            }
                            setState(() {
                              start_date.text = start_dateString.toString();
                              end_date.text = end_date_String.toString();
                              outcome.text = outcome_String.toString();
                              fee.text = fee_String.toString();
                              skill.text = skill_String.toString();
                            });
                            is_training_selected = true;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      controller: start_date,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'Start date',
                          labelText: 'Start date'),
                      readOnly: true,
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        child: TextField(
                      controller: end_date,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'End date',
                          labelText: 'End date'),
                      readOnly: true,
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: fee,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Fee',
                        labelText: 'Fee'),
                    readOnly: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: skill,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Skill',
                        labelText: 'Skill'),
                    readOnly: true,
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Training Objective',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'pop_m',
                      color: MyColor.mainAppColor),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: outcome,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Training Outcome',
                        labelText: 'Training Outcome'),
                    readOnly: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: specify_objective,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Specify Objective',
                        labelText: 'Specify Objective'),
                    readOnly: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _justification,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Justification',
                        labelText: 'Justification'),
                    readOnly: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: InkWell(
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColor.mainAppColor),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'pop',
                            color: MyColor.white_color),
                      ),
                    ),
                    onTap: () {
                      setState(() {

                        if(validation()){
                          sendTraining_Request();
                        }

                      });
                    },
                  )),
              Container(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
bool validation(){
    if(training_id.toString()==''){
      Flushbar(
        message: 'Please select training type',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);

      return false;
    }else if(specify_objective.text==''){
      Flushbar(
        message: 'Please enter specify objective',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);

      return false;
    }else if(_justification.text==''){
      Flushbar(
        message: 'Please enter justification',
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);

      return false;
    }
    return true;
}
  void sendTraining_Request() async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
print('user_id '+user_id.toString()+' training id '+ training_id.toString()+' sep '+specify_objective.text+' jus '+_justification.text);
    Training_Request_Model training_request_model =
        await _sendRequest_Services.sendTrainingRequest(
            user_id.toString(),
            training_id.toString(),
            specify_objective.text,
            _justification.text);

    if (training_request_model.Status == '1') {
      await pr.hide();
      Flushbar(
        message: training_request_model.Message,
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  MainHome()));
    } else {
      await pr.hide();
      Flushbar(
        message: training_request_model.Message,
        duration: const Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
    }
  }
}
