import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/wfh/emp_wfh_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class main_wfh extends StatefulWidget {
  const main_wfh({super.key});

  @override
  State<main_wfh> createState() => _main_wfhState();
}

class _main_wfhState extends State<main_wfh> {
  List<emp_wfhmodel> wfhlist = [];
  TextEditingController FromedateInput = TextEditingController();
  TextEditingController TodateInput = TextEditingController();
  TextEditingController _reason = TextEditingController();
  String no_of_wfhdays = '';
  String datevalid = "";
  String progress = "";
  bool is_true = false;
  int count = 0;
  @override
  void initState() {
    callme();
    getlist();
    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: MyColor.white_color,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              SizedBox(
                width: 8,
              ),
              Text(
                "WFH Request",
                style: TextStyle(fontFamily: "pop_m", fontSize: 16),
              ),
            ],
          )),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Column(
            children: [
              if (progress == '')
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: MyColor.mainAppColor,
                  )),
                )
              else if (wfhlist.length == 0) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/svgs/no_data_found.svg"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'No data',
                          style: TextStyle(fontSize: 18, fontFamily: 'pop_m'),
                        )
                      ],
                    ),
                  ),
                )
              ] else ...[
                Expanded(
                  child: ListView.builder(
                      itemCount: wfhlist.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shadowColor: MyColor.mainAppColor,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: MyColor.new_yellow_color,
                                      radius: 25,
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/ApplyWFH.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "From:- ${wfhlist[index].from_date}",
                                            style: TextStyle(
                                                fontFamily: "pop",
                                                fontSize: 14),
                                          ),
                                          Text("To:- ${wfhlist[index].to_date}",
                                              style: TextStyle(
                                                  fontFamily: "pop",
                                                  fontSize: 14)),

                                          //   Text(
                                          //   '${halfdaylist[index].type}',
                                          //   style: const TextStyle(
                                          //       fontSize: 14,
                                          //       fontFamily: 'pop'),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //   MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       "From:- ${wfhlist[index].from_date}",
                                //       style: TextStyle(
                                //           fontFamily: "pop", fontSize: 14),
                                //     ),
                                //     Text(
                                //         "To:- ${wfhlist[index].to_date}",
                                //         style: TextStyle(
                                //             fontFamily: "pop", fontSize: 14)),
                                //   ],
                                // ),
                                // const SizedBox(height: 4,),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //         "Created at:- ${wfhlist[index].AssignDate.toString().split("T").first}",
                                //         style: TextStyle(
                                //             fontFamily: "pop", fontSize: 14)),
                                //     Text(
                                //         "${wfhlist[index].status.toString().split("T").first}",
                                //         style: TextStyle(
                                //             fontFamily: "pop", fontSize: 14)),

                                //   ],
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 2,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Created at:- ${wfhlist[index].AssignDate.toString().split("T").first}",
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14)),
                                    Text(
                                        "${wfhlist[index].status.toString().split("T").first}",
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14)),
                                  ],
                                ),
                                // Text("Reason:-"),
                                // Text(wfhlist[index].req_reason,
                                //     style: TextStyle(
                                //         fontFamily: "pop", fontSize: 14))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ]
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showwfhdailog();
        },
        child: Icon(
          Icons.add,
          color: MyColor.white_color,
        ),
        backgroundColor: MyColor.mainAppColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  void getlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('user_access_token')!;
    String emp_code = EncryptData.decryptAES(pref.getString('user_emp_code')!);
    wfhlist.clear();
    var response = await http.post(Uri.parse('${baseurl.url}wfhrequestview'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'emp_code': emp_code});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonobject = jsonDecode(response.body);
      if (jsonobject['status'] == "1") {
        var jsonarray = jsonobject['records'];
        for (var i in jsonarray) {
          emp_wfhmodel list = emp_wfhmodel(
              from_date: i['fdate'],
              to_date: i['tdate'],
              totaldays: i['totalday'],
              Emp_name: i['Emp_name'],
              AssignDate: i['created_at'],
              record_id: i['wfh_refcode'].toString(),
              req_reason: "",
              emp_photo: "",
              status: i['status'],
              position: "");
          setState(() {
            wfhlist.add(list);
          });
        }
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }

  void _showwfhdailog() {
    FromedateInput.clear();
    TodateInput.clear();
    _reason.clear();
    no_of_wfhdays = "";
    showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              insetPadding: const EdgeInsets.only(left: 20, right: 20),
              contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 20),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              scrollable: true,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From Date",
                                style: TextStyle(
                                    fontFamily: "pop_m", fontSize: 16)),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: FromedateInput,
                                  //editing controller of this TextField
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      color: MyColor.mainAppColor,
                                    ),
                                    //icon of text field
                                    hintText: "From date",
                                    //label text of field
                                  ),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'pop'),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: datevalid == "Yes"
                                            ? DateTime(2000)
                                            : DateTime.now(),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        FromedateInput.text = formattedDate;
                                        if (FromedateInput.text != '' &&
                                            TodateInput.text != '') {
                                          int no_of_day = daysBetween(
                                                  DateTime.parse(
                                                      FromedateInput.text),
                                                  DateTime.parse(
                                                      TodateInput.text)) +
                                              1;
                                          is_true = true;
                                          no_of_wfhdays = no_of_day.toString();

                                          print('number of leave ' +
                                              no_of_day.toString());
                                        } //set output date to TextField value.
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "To Date",
                              style:
                                  TextStyle(fontFamily: "pop_m", fontSize: 16),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  controller: TodateInput,
                                  //editing controller of this TextField
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      color: MyColor.mainAppColor,
                                    ),
                                    //icon of text field
                                    hintText: "To date",
                                    //label text of field
                                  ),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'pop'),
                                  readOnly: true,
                                  onTap: () async {
                                    String start_date = '';
                                    if (FromedateInput.text == '') {
                                      start_date = DateTime.now().toString();
                                    } else {
                                      start_date = FromedateInput.text;
                                    }
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(start_date),
                                        firstDate: DateTime.parse(start_date),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        TodateInput.text = formattedDate;
                                        //set output date to TextField value.
                                        if (FromedateInput.text != '' &&
                                            TodateInput.text != '') {
                                          int no_of_day = daysBetween(
                                                  DateTime.parse(
                                                      FromedateInput.text),
                                                  DateTime.parse(
                                                      TodateInput.text)) +
                                              1;
                                          is_true = true;
                                          no_of_wfhdays = no_of_day.toString();
                                          print('Number of leave ' +
                                              no_of_day.toString());
                                        }
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                      visible: no_of_wfhdays == "" ? false : true,
                      child: Text(
                        "Total Days $no_of_wfhdays",
                        style: TextStyle(
                            fontFamily: "pop_m",
                            fontSize: 16,
                            color: MyColor.mainAppColor),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Reason",
                    style: TextStyle(fontFamily: "pop_m", fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: _reason,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Reason..",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (vaidation()) {
                          if (count == 0) {
                            Navigator.of(context).pop();
                            count++;
                            sendWFHRequest();
                          }
                        }
                        //  Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            color: MyColor.mainAppColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            "Confirm Request",
                            style: TextStyle(
                                fontFamily: "pop", color: MyColor.white_color),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool vaidation() {
    if (FromedateInput.text == '') {
      _showMyDialog('Please select From date', Color(0xFF861F41), 'error');
      return false;
    } else if (TodateInput.text == '') {
      _showMyDialog('Please select To date', Color(0xFF861F41), 'error');
      return false;
    } else if (_reason.text == '') {
      _showMyDialog('Please Enter reason', Color(0xFF861F41), 'error');
      return false;
    }

    return true;
  }

  void sendWFHRequest() async {
    _customProgress('Please wait...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');

    print(
        "start ${FromedateInput.text}  end  ${TodateInput.text}  reason ${_reason.text} ");
    var response = await http.post(
      Uri.parse('${baseurl.url}wfhrequest'),
      body: {
        'start_date': '${FromedateInput.text}',
        'end_date': '${TodateInput.text}',
        'reason': '${_reason.text}'
      },
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      if (jsonObject['status'] == '1') {
        Navigator.of(context).pop();
        _showMyDialog('${jsonObject['message']}', Colors.green, 'success');
      } else {
        Navigator.of(context).pop();
        setState(() {
          count = 0;
        });
        _showMyDialog('${jsonObject['message']}', Color(0xFF861F41), 'error');
      }
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }else if (response.statusCode == 500) {
     
      Navigator.of(context).pop();
       _showMyDialog('Something went Wrong', Color(0xFF861F41), 'error');
    }
  }

  Future<void> _showMyDialog(
      String msg, Color color_dynamic, String success) async {
    /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
       children: [
         if(success=='success')...[
          Icon(Icons.check,color: MyColor.white_color,),
         ]else...[
Icon(Icons.error,color: MyColor.white_color,),
         ],
         SizedBox(width: 8,),
         Flexible(child: Text(msg,style: TextStyle(color: MyColor.white_color),maxLines: 2,))
       ],
     ),backgroundColor: color_dynamic,
    behavior: SnackBarBehavior.floating,
    elevation: 3,));*/
    Flushbar(
      message: '${msg}',
      duration: Duration(seconds: 3),
      // Add more styling here
      backgroundColor: color_dynamic, // Example color
      //borderRadius: 8.0, // Example border radius
      margin: EdgeInsets.all(16.0), // Example margin
      padding: EdgeInsets.symmetric(
          horizontal: 24.0, vertical: 12.0), // Example padding

      icon: success == 'success'
          ? Icon(
              Icons.check,
              color: MyColor.white_color,
            )
          : Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
    ).show(context);
  }

  Future<void> _customProgress(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      '${msg}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
