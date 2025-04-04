import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/main_home/mainHome.dart';
import 'package:demo/ticket_request_panel/api_services/ticket_request_apiServices.dart';
import 'package:demo/ticket_request_panel/model/send_requestModel.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Create_Ticket_Request extends StatefulWidget {
  const Create_Ticket_Request({Key? key}) : super(key: key);

  @override
  _Create_Ticket_RequestState createState() => _Create_Ticket_RequestState();
}

class _Create_Ticket_RequestState extends State<Create_Ticket_Request> {
  TextEditingController req_name = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController from_date_controller = TextEditingController();
  TextEditingController to_date_controller = TextEditingController();
  TextEditingController from_country = TextEditingController();
  TextEditingController to_country = TextEditingController();
  TextEditingController from_airport = TextEditingController();
  TextEditingController to_airport = TextEditingController();
  TextEditingController travel_descrip = TextEditingController();
  final _ticket_request_api_services = Ticket_Request_ApiServces();
  String? user_name = '';
  bool statusCheck = false;
  String desti_type = '';
  var desti_item = ['One Way', 'Round Trip'];
  String purpose_type = '';
  var purpose_item = ['Business Trip', 'Client meeting', 'personal'];
  bool is_true = false;
  String travel_mode = '';
  var travel_item = ['By Air', 'By Road'];

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
    from_date_controller.text = "";
    to_date_controller.text = "";
    from_country.text = "";
    to_country.text = "";
    travel_descrip.text = "";
    from_airport.text = '';
    to_airport.text = '';

    super.initState();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket request',
          style: TextStyle(
              fontSize: 16, fontFamily: 'pop', color: MyColor.white_color),
        ),
        elevation: 0,
        backgroundColor: MyColor.mainAppColor,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Column(
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
              padding: EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: from_date_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'From date',
                        labelText: 'From date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));

                      if (pickeddate != null) {
                        String formateDate =
                            DateFormat('yyyy-MM-dd').format(pickeddate);
                        setState(() {
                          from_date_controller.text = formateDate;
                          if (from_date_controller.text != '' &&
                              to_date_controller.text != '') {
                            int no_of_day = daysBetween(
                                DateTime.parse(from_date_controller.text),
                                DateTime.parse(to_date_controller.text)) +
                                1;
                            print('number of leave ' + no_of_day.toString());
                          }
                        });
                      }
                    },
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                      child: TextField(
                    controller: to_date_controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: 'To date',
                        labelText: 'To date'),
                    readOnly: true,
                    onTap: () async {
                      String start_date='';
                      if(from_date_controller.text==''){
                        start_date=DateTime.now().toString();
                      }else{
                        start_date = from_date_controller.text;
                      }
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(start_date),
                          firstDate: DateTime.parse(start_date),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formateDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          to_date_controller.text = formateDate;
                          if (from_date_controller.text != '' &&
                              to_date_controller.text != '') {
                            int no_of_day = daysBetween(
                                    DateTime.parse(from_date_controller.text),
                                    DateTime.parse(to_date_controller.text)) +
                                1;
                            print('number of leave ' + no_of_day.toString());
                          }
                        });
                      }
                    },
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          // underline: Container(),
                          hint: Text('Destination type'),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isDense: true,
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          items: desti_item.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              desti_type = value!;
                            });
                          }),
                    ),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                      child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          // underline: Container(),
                          hint: Text('Select purpose'),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          isDense: true,
                          isExpanded: true,
                          alignment: Alignment.centerLeft,
                          items: purpose_item.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              purpose_type = value!;
                            });
                          }),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextField(
                controller: from_country,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'From country',
                    labelText: 'From country'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextField(
                controller: to_country,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'To country',
                    labelText: 'To country'),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                        // underline: Container(),
                        hint: Text('Travel mode'),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isDense: true,
                        isExpanded: true,
                        alignment: Alignment.centerLeft,
                        items: travel_item.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            travel_mode = value!;
                            if (travel_mode == 'By Air') {
                              is_true = true;
                            } else {
                              is_true = false;
                            }
                          });
                        }),
                  ),
                )),
            Visibility(
              visible: is_true,
              child: Container(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: TextField(
                      controller: from_airport,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'From airport',
                          labelText: 'From airport'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: TextField(
                      controller: to_airport,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'To airport',
                          labelText: 'To airport'),
                    ),
                  ),
                ],
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextField(
                controller: travel_descrip,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Travel description',
                    labelText: 'Travel description'),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 24),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: MyColor.mainAppColor,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'pop',
                        fontSize: 16,
                        color: MyColor.white_color,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (validation()) {
                        if (travel_mode == 'By Air') {
                          if (from_airport.text == '') {
                            Flushbar(
                              message: 'Please enter from airport',
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              duration: Duration(seconds: 2),
                            )..show(context);
                          } else if (to_airport.text == '') {
                            Flushbar(
                              message: 'Please enter to airport',
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              duration: Duration(seconds: 2),
                            )..show(context);
                          } else {
                            sendTicketRequest();
                          }
                        } else {
                          if (travel_mode == 'By Road') {
                            from_airport.text = '';
                            to_airport.text = '';
                            sendTicketRequest();
                          }
                        }
                      }
                    });
                  },
                )),
            Container(
              height: 50,
            ),
          ],
        ),
      )),
    );
  }

  void sendTicketRequest() async {
    final ProgressDialog pr = await ProgressDialog(context);
    await pr.show();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_id = pref.getString('user_id');
    SendRequest_Model request_model =
        await _ticket_request_api_services.sendTicket_Request(
            user_id.toString(),
            from_date_controller.text,
            to_date_controller.text,
            desti_type,
            purpose_type,
            from_country.text,
            to_country.text,
            from_airport.text,
            to_airport.text,
            travel_descrip.text,
            '',
            travel_mode);

    if (request_model.Status == '1') {
      pr.hide();
      Flushbar(
        message: request_model.Message,
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => new MainHome()));
    } else {
      pr.hide();
      Flushbar(
        message: request_model.Message,
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);
    }
  }

  bool validation() {
    if (from_date_controller.text == '') {
      Flushbar(
        message: 'Please selete from date',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (to_date_controller.text == '') {
      Flushbar(
        message: 'Please selete to date',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (desti_type == '') {
      Flushbar(
        message: 'Please selete to destination',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (purpose_type == '') {
      Flushbar(
        message: 'Please selete to purpose',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (from_country.text == '') {
      Flushbar(
        message: 'Please enter from country',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (to_country.text == '') {
      Flushbar(
        message: 'Please enter to country',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (travel_mode == '') {
      Flushbar(
        message: 'Please select travel mode',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    } else if (travel_descrip.text == '') {
      Flushbar(
        message: 'Please enter description',
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    }

    return true;
  }
}
