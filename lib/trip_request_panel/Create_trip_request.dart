import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/main_home/mainHome.dart';
import 'package:demo/trip_request_panel/api_services/trip_request_services.dart';
import 'package:demo/trip_request_panel/model/send_trip_model.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:demo/trip_request_panel/trip_type_list.dart';

class Create_Trip_Request extends StatefulWidget {
  const Create_Trip_Request({Key? key}) : super(key: key);

  @override
  _Create_Trip_RequestState createState() => _Create_Trip_RequestState();
}

class _Create_Trip_RequestState extends State<Create_Trip_Request> {

  TextEditingController req_name = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController from_date_control = TextEditingController();
  TextEditingController to_date_control = TextEditingController();
  TextEditingController desti_region = TextEditingController();
  TextEditingController no_of_trip_days = TextEditingController();
  TextEditingController distance_control = TextEditingController();
  TextEditingController note_controll = TextEditingController();

  final _trip_requestServices = Trip_Request_ApiServices();
  String? user_name = '';
  List<TripTypeModel> _tripType = [];

  String desti_id = '', desti_type = '';
  bool isDestiSelected = false;

  var accomodation_provided_array = [
    "By Company",
    "By Staff",
    "By Third Party",
    "None"
  ];
  String accomodation_type = '';

  var meal_provided_array = [
    "By Company",
    "By Staff",
    "By Third Party",
    "None"
  ];

  String meal_type = '';
  var _trip_array = [];
  List<TripTypeModel> trip_data = [];
  String? _trip_type;
  var travel_with_array = ["By Company", "By Staff", "By Third Party", "None"];
  String travel_with_type = '';

  final _status = ["Yes", "No"];

  String checkBy_company_status = '';
  String daily_allownces_status = '';
  String car_rent_status = '';
  String visa_requ_status = '';

  var ticket_level = ["Economy", "Business class"];
  String ticket_type = '';

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<List<TripTypeModel>> getAllLeaveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');
    var response = await http.get(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=GET_MASTER_DESTINATION_FOR_BTRIP'),
        headers: {'Authorization': 'Bearer ${token}'});

    if (response.statusCode == 200) {
      print('leave type 200 ${response.body}');
    } else {
      print('leave type code ${response.body}');
    }

    var jsonData = json.decode(response.body);

    var jsonArray = jsonData['DestinationMasterList'];
    _trip_array = jsonData['DestinationMasterList'];

    print('count' + _trip_array.toString());

    for (var leaveType in jsonArray) {
      TripTypeModel leaveTypeModule = TripTypeModel(
          desti_id: leaveType['desti_id'],
          desti_name: leaveType['desti_name'],
          desti_type: leaveType['desti_type']);

      trip_data.add(leaveTypeModule);
    }

    return trip_data;
  }

  void getAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    user_name = sharedPreferences.getString('user_name');
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2023-05-29
    setState(() {
      req_name.text = '${user_name}';
      date_controller.text = formattedDate;
    });
  }

  @override
  void initState() {
    getAllData();
    getAllLeaveList();
    desti_region.text = '';
    distance_control.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trip Request',
          style: TextStyle(
              fontSize: 16, fontFamily: 'pop', color: MyColor.white_color),
        ),
        backgroundColor: MyColor.mainAppColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
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
                  SizedBox(
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
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: from_date_control,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'From date',
                            labelText: 'From date'),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formateDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);

                            setState(() {
                              from_date_control.text = formateDate;
                              if (from_date_control.text != '' &&
                                  to_date_control.text != '') {
                                int no_of_day = daysBetween(
                                        DateTime.parse(from_date_control.text),
                                        DateTime.parse(to_date_control.text)) +
                                    1;

                                no_of_trip_days.text = no_of_day.toString();
                                print(
                                    'number of leave ' + no_of_day.toString());
                              }
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        child: TextField(
                      controller: to_date_control,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'To date',
                          labelText: 'To date'),
                      readOnly: true,
                      onTap: () async {
                        String start_date = '';
                        if (from_date_control.text == '') {
                          start_date = DateTime.now().toString();
                        } else {
                          start_date = from_date_control.text;
                        }
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(start_date),
                            firstDate: DateTime.parse(start_date),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String todate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            to_date_control.text = todate;
                            if (from_date_control.text != '' &&
                                to_date_control.text != '') {
                              int no_of_day = daysBetween(
                                      DateTime.parse(from_date_control.text),
                                      DateTime.parse(to_date_control.text)) +
                                  1;

                              no_of_trip_days.text = no_of_day.toString();
                              print('number of leave ' + no_of_day.toString());
                            }
                          });
                        }
                      },
                    )),
                  ],
                ),
              ),
              //DropDown
              Padding(
                padding: EdgeInsets.only(top: 16, right: 0.0, left: 0.0),
                child: Container(
                  height: 52,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: DropdownButton<String>(
                        underline: Container(),
                        hint: Text("Select destination type"),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        value: _trip_type,
                        items: _trip_array.map((ctry) {
                          return DropdownMenuItem<String>(
                              value: ctry["desti_name"],
                              child: Text(ctry["desti_name"]));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _trip_type = value!;
                            for (int i = 0; i < _trip_array.length; i++) {
                              if (_trip_array[i]["desti_name"] == value) {
                                desti_region.text =
                                    _trip_array[i]["desti_type"].toString();
                                desti_id =
                                    _trip_array[i]["desti_id"].toString();
                                //  leave_type_id = _trip_array[i]["lg_id"].toString();
                                print('dropDownId ' +
                                    _trip_array[i][''].toString());
                              }
                            }

                            // is_trip_typeSelected = true;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: TextField(
                  controller: desti_region,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      hintText: 'Distance region',
                      labelText: 'Distance region'),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 52,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColor.mainAppColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                        hint: Text('Select accomodation provided'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: accomodation_provided_array.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            accomodation_type = value!;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 52,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColor.mainAppColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                        hint: Text('Select meal provided'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: meal_provided_array.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            meal_type = value!;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 52,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColor.mainAppColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                        hint: Text('Select travel with'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: travel_with_array.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            travel_with_type = value!;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: 52,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColor.mainAppColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                        hint: Text('Select ticket level'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: ticket_level.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            ticket_type = value!;
                          });
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      controller: distance_control,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'Distance',
                        labelText: 'Distance',
                      ),
                      keyboardType: TextInputType.number,
                    )),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                        child: TextField(
                      controller: no_of_trip_days,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'No. of total days',
                        labelText: 'No. of total days',
                      ),
                      readOnly: true,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Note',
                  style: TextStyle(
                      fontFamily: 'pop_m',
                      fontSize: 16,
                      color: MyColor.mainAppColor),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: TextField(
                  controller: note_controll,
                  decoration: InputDecoration(
                    hintText: 'Note',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'By company accomodation',
                  style: TextStyle(
                      fontFamily: 'pop_m', fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 40.0,
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: checkBy_company_status,
                  horizontalAlignment: MainAxisAlignment.start,
                  onChanged: (value) => setState(() {
                    checkBy_company_status = value ?? '';
                    print(checkBy_company_status);
                  }),
                  items: _status,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Daily allownces',
                  style: TextStyle(
                      fontFamily: 'pop_m', fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 40.0,
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: daily_allownces_status,
                  horizontalAlignment: MainAxisAlignment.start,
                  onChanged: (value) => setState(() {
                    daily_allownces_status = value ?? '';
                    print(daily_allownces_status);
                  }),
                  items: _status,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Car rent',
                  style: TextStyle(
                      fontFamily: 'pop_m', fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 40.0,
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: car_rent_status,
                  horizontalAlignment: MainAxisAlignment.start,
                  onChanged: (value) => setState(() {
                    car_rent_status = value ?? '';
                    print(car_rent_status);
                  }),
                  items: _status,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Visa required',
                  style: TextStyle(
                      fontFamily: 'pop_m', fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 40.0,
                child: RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: visa_requ_status,
                  horizontalAlignment: MainAxisAlignment.start,
                  onChanged: (value) => setState(() {
                    visa_requ_status = value ?? '';
                    print(visa_requ_status);
                  }),
                  items: _status,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: InkWell(
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyColor.mainAppColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop',
                          color: MyColor.white_color),
                    ),
                  ),
                  onTap: () {
                    if (validation()) {
                      send_TripRequest_Services();
                    }
                  },
                ),
              ),

              //For bottom space
              Container(
                height: 56,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    if (from_date_control.text == '') {
      Flushbar(
        message: 'Please select from date',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (to_date_control.text == '') {
      Flushbar(
        message: 'Please select to date',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (desti_region.text == '') {
      Flushbar(
        message: 'Please select Destination',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (accomodation_type == '') {
      Flushbar(
        message: 'Please select accomodation provided',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (meal_type == '') {
      Flushbar(
        message: 'Please select meal provided',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (travel_with_type == '') {
      Flushbar(
        message: 'Please select travel with',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (ticket_type == '') {
      Flushbar(
        message: 'Please select ticket level',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (distance_control.text == '') {
      Flushbar(
        message: 'Please enter distance',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (note_controll.text == '') {
      Flushbar(
        message: 'Please enter note',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (checkBy_company_status == '') {
      Flushbar(
        message: 'Please select company accomodation',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (daily_allownces_status == '') {
      Flushbar(
        message: 'Please select daily allownces',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (car_rent_status == '') {
      Flushbar(
        message: 'Please select car rent',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    } else if (visa_requ_status == '') {
      Flushbar(
        message: 'Please select visa required',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      return false;
    }
    return true;
  }

  void send_TripRequest_Services() async {
    final ProgressDialog pr = await ProgressDialog(context);
    pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    Send_TripModel trip_model = await _trip_requestServices.send_Trip_Request(
        user_id.toString(),
        from_date_control.text,
        to_date_control.text,
        desti_id.toString(),
        distance_control.text,
        accomodation_type,
        meal_type,
        travel_with_type,
        ticket_type,
        checkBy_company_status,
        note_controll.text,
        daily_allownces_status,
        car_rent_status,
        visa_requ_status,
        '0',
        '',
        '');

    if (trip_model.Status == '1') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(trip_model.Message)));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainHome()));
    } else {
      Flushbar(
        message: trip_model.Message,
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.BOTTOM,
      )..show(context);
    }
  }
}

