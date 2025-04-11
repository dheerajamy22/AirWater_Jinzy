import 'dart:convert';

import 'package:demo/Earlygoing_latecoming/EG_LC.dart';
import 'package:demo/Earlygoing_latecoming/EG_LCMOdel.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EGLCDash extends StatefulWidget {
  const EGLCDash({super.key});

  @override
  State<EGLCDash> createState() => _EGLCDashState();
}

class _EGLCDashState extends State<EGLCDash> {
  String progress = "";
  List<EgLcmodel> EGLClist = [];

  @override
  void initState() {
    // TODO: implement initState
    getlist();
    // callme();
    super.initState();
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      progress = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: AppBar(
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
                    'LC/EG Request',
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
              else if (EGLClist.length == 0) ...[
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
                      itemCount: EGLClist.length,
                      shrinkWrap: true,
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
                                      backgroundColor: MyColor.mainAppColor,
                                      radius: 25,
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          'assets/new_svgs/Punch.svg',
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
                                            "Date:- ${EGLClist[index].date}",
                                            style: TextStyle(
                                                fontFamily: "pop",
                                                fontSize: 14),
                                          ),
                                          Text("Type:- ${EGLClist[index].type}",
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
                                    Text("Reason:- ${EGLClist[index].reason}",
                                        style: TextStyle(
                                            fontFamily: "pop", fontSize: 14)),
                                    Text("${EGLClist[index].status}",
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EG_LC(),
              ));
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
    print("ECLG API");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('user_access_token')!;
    EGLClist.clear();
    var response = await http.post(Uri.parse('${baseurl.url}late-comming-earyly-going-list'),
        headers: {'Authorization': 'Bearer $token'},
        // body: {'model_name': "LateCEarlyGo"}
        );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
       setState(() {
      progress = '1';
    });
      var jsonobject = jsonDecode(response.body);
      if (jsonobject['status'] == "1") {
        var jsonarray = jsonobject['data'];
        for (var i in jsonarray) {
          EgLcmodel list = EgLcmodel(
            status: i['status'],
            date: i['date'],
            reason: i['reason'],
            type: i['type'],
            code: i['code'],
            time: i['time'],
          );
          setState(() {
            EGLClist.add(list);
          });
        }
      }
    } else if (response.statusCode == 401) {
       setState(() {
      progress = '1';
    });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }else if(response.statusCode==500){
       setState(() {
      progress = '1';
    });
       _showMyDialog('Something went wrong', Color(0xFF861F41), 'error');
    }
  }

  Future<void> _showMyDialog(
      String msg, Color color_dynamic, String success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          if (success == 'success') ...[
            Icon(
              Icons.check,
              color: MyColor.white_color,
            ),
          ] else ...[
            Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
          ],
          SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            msg,
            style: TextStyle(color: MyColor.white_color),
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: color_dynamic,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
    ));
  }


}
