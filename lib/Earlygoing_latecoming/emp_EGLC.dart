import 'package:demo/Earlygoing_latecoming/EG_LCMOdel.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class employee_EGLC extends StatefulWidget {
  final String emp_code;
  const employee_EGLC({super.key,required this.emp_code});

  @override
  State<employee_EGLC> createState() => _employee_EGLCState();
}

class _employee_EGLCState extends State<employee_EGLC> {
  List<EgLcmodel> EGLClist = [];
  @override
  void initState() {
   getlist();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
             elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0054A4),
         title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

               Row(
                 children: [
                    GestureDetector(
                      onTap: () {
                         Navigator.of(context).pop();
                      },
                      child: Icon(
                      Icons.arrow_back,
                      color: MyColor.white_color,
                                   ),
                    ),

                                  Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    'EG/LC Request',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                        color: MyColor.white_color),
                  )),
                 ],
               ),
             
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Image.asset(
                      'assets/images/powered_by_tag.png',
                      width: 90,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),),
        ),
    );
  }


void getlist()async{
    print('${widget.emp_code}');
  SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('user_access_token')!;
    EGLClist.clear();
    var response = await http.post(Uri.parse('${baseurl.url}'),
        headers: {'Authorization': 'Bearer $token'},
       body: {'emp_code': '${widget.emp_code}'},
        );
}



}