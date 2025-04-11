import 'dart:convert';

import 'package:demo/baseurl/base_url.dart';
import 'package:demo/emp_details/emp_dashboard.dart';
import 'package:demo/myteam/team_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../_login_part/login_activity.dart';
import '../app_color/color_constants.dart';

class myteam extends StatefulWidget {
  const myteam({super.key});

  @override
  State<myteam> createState() => _myteamState();
}

class _myteamState extends State<myteam> {
  List<MyTeamModel> team_list = [];

  Future<List<MyTeamModel>> getTeamRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? emp_id = pref.getString('emp_id');
    String? e_id = pref.getString('e_id');
    String? user_emp_code = pref.getString('user_emp_code');
    String? token = pref.getString('user_access_token');

    var response = await http.get(Uri.parse('${baseurl.url}my-team'),
        headers: {'Authorization': 'Bearer $token'});
    print('Team Data ' + response.body);

    if (response.statusCode == 200) {
      setState(() {
        progress = '1';
      });
      var jsonObject = json.decode(response.body);
      if (jsonObject['status'] == '1') {
        var listJsonArray = jsonObject['team'];

        for (var listTeam in listJsonArray) {
          MyTeamModel teamModel = MyTeamModel(
              name: listTeam['name'],
              email: listTeam['email'],
              mobile: listTeam['mobile'],
              department: listTeam['department'],
              emp_code: listTeam['emp_code'],
              image: listTeam['image']);
          setState(() {
            team_list.add(teamModel);
          });
        }
      } else {}
    }
    else if (response.statusCode == 401) {
      setState(() {
        progress = '1';
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
    else {
      setState(() {
        progress = '1';
      });
    }

    return team_list;
  }

  String progress = "";

  @override
  void initState() {
   // callme();
    super.initState();
    getTeamRequest();
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
                    'My Team',
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
      body: Column(
        children: [
          if (progress == '')
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                  child: CircularProgressIndicator(
                color: MyColor.mainAppColor,
              )),
            )
          else if (team_list.length == 0) ...[
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
          ] else
            ...[
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
                  child: ListView.builder(
                      itemCount: team_list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          shadowColor: MyColor.mainAppColor,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => new EmployeeDetails(
                                    emp_code: team_list[index].emp_code,
                                    name: team_list[index].name,
                                    img: team_list[index].image,
                                  )));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 12, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColor.white_color
                                // color: (index % 2 == 0)
                                //     ? MyColor.mainAppColor.withOpacity(0.2)
                                //     : MyColor.light_gray.withOpacity(0.2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: ClipOval(
                                          child: Image.network(
                                            team_list[index].image,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${team_list[index].name}",
                                            style: TextStyle(
                                                fontSize: 14, fontFamily: 'pop'),
                                          ),
                                          Text(
                                            "${team_list[index].mobile}",
                                            style: TextStyle(
                                                fontSize: 12, fontFamily: 'pop'),
                                          ),
                                          Text(
                                            "${team_list[index].email}",
                                            style: TextStyle(
                                                fontSize: 12, fontFamily: 'pop'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],

        ],
      ),
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
