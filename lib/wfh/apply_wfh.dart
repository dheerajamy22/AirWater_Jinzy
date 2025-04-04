import 'dart:convert';

import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../_login_part/login_activity.dart';

class workfromhome extends StatefulWidget {
  const workfromhome({super.key});

  @override
  State<workfromhome> createState() => _workfromhomeState();
}

class _workfromhomeState extends State<workfromhome> {
   TextEditingController FromedateInput = TextEditingController();
    TextEditingController TodateInput = TextEditingController();
    TextEditingController _reason=TextEditingController();
  String no_of_leave = '';
  String  datevalid = "";
  bool is_true = false;
  int count =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Apply WFH",style: TextStyle(fontFamily: "pop_m",fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From Date",style: TextStyle(fontFamily: "pop_m",fontSize: 16)),
                        SizedBox(height: 4,),
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
                                  fontSize: 16,
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
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    FromedateInput.text = formattedDate;
                                    if (FromedateInput.text != '' &&
                                        TodateInput.text != '') {
                                      int no_of_day = daysBetween(
                                              DateTime.parse(FromedateInput.text),
                                              DateTime.parse(TodateInput.text)) +
                                          1;
                                      is_true = true;
                                      no_of_leave = no_of_day.toString();
                        
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
                  SizedBox(width: 8,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("To Date",style: TextStyle(fontFamily: "pop_m",fontSize: 16),),
                        SizedBox(height: 4,),
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
                                hintText: "to date",
                                //label text of field
                              ),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
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
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    TodateInput.text = formattedDate;
                                    //set output date to TextField value.
                                    if (FromedateInput.text != '' &&
                                        TodateInput.text != '') {
                                      int no_of_day = daysBetween(
                                              DateTime.parse(FromedateInput.text),
                                              DateTime.parse(TodateInput.text)) +
                                          1;
                                      is_true = true;
                                      no_of_leave = no_of_day.toString();
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
              const SizedBox(height: 16,),
              Text("Total Days",style: TextStyle(fontFamily: "pop_m",fontSize: 16),),
              const SizedBox(height: 4,),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26,),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(no_of_leave),
              ),
              const SizedBox(height: 16,),
              Text("Reason",style: TextStyle(fontFamily: "pop_m",fontSize: 16),),
              const SizedBox(height: 8,),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8)
                ),
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
            const SizedBox(height: 24,),
            Align(
              alignment: Alignment.center,
              child: InkWell(
              onTap: (){
                if(vaidation()){
if(count==0){
  count++;
  sendWFHRequest();
}
                }
              },
                child: Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.height*0.06,
                  decoration: BoxDecoration(
                    color: MyColor.mainAppColor,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Center(child: Text("Confirm Request",style: TextStyle(fontFamily: "pop",color: MyColor.white_color),),),
                ),
              ),
            )
          ],
        ),
        ),
      ),
    );
  }
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool vaidation(){

    if(FromedateInput.text==''){
_showMyDialog('Please select From date');
      return false;
    }else if(TodateInput.text==''){
      _showMyDialog('Please select To date');
      return false;
    }else if(_reason.text==''){
      _showMyDialog('Please Enter reason');
      return false;
    }

    return true;
  }

  void sendWFHRequest() async{
_customProgress('Please wait...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('user_access_token');


  print("start ${FromedateInput.text}  end  ${TodateInput.text}  reason ${_reason.text} ");
    var response = await http.post(
        Uri.parse(
            '${baseurl.url}wfhrequest'),
             body: {'start_date': '${FromedateInput.text}', 'end_date': '${TodateInput.text}','reason':'${_reason.text}'},
        headers: {'Authorization': 'Bearer $token'},
       );

    print(response.statusCode);
    print(response.body);

    if(response.statusCode==200){
      var jsonObject = json.decode(response.body);

      if(jsonObject['status']=='1'){
        Navigator.pop(context);
        _SuceesFullyMyDialog(jsonObject['message'],jsonObject['Remainingbal'],);
      }else{

        Navigator.pop(context);
        setState(() {
          count=0;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      }
    }else if(response.statusCode==401){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }

  }

   Future<void> _showMyDialog(String msg) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false, // user must tap button!
       builder: (BuildContext context) {
         return AlertDialog(
           content: SingleChildScrollView(
             child: ListBody(
               children: <Widget>[
                 Text('${msg}'),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               child: const Text('Okay'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }
   Future<void> _SuceesFullyMyDialog(String msg,String reming) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false, // user must tap button!
       builder: (BuildContext context) {
         return AlertDialog(
           content: SingleChildScrollView(
             child: ListBody(
               children: <Widget>[
                 Text('${msg}'),
                 Text('Total remaining wfh request  ${reming}'),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               child: const Text('Okay'),
               onPressed: () {
                 Navigator.of(context).pop();
                 Navigator.of(context)
                 .push(MaterialPageRoute(builder: (context)=>new upcoming_dash()));
               },
             ),
           ],
         );
       },
     );
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