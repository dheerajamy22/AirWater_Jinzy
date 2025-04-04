import 'dart:convert';

import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/anniversary/anniversary_model.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/upcoming_birthday/birthday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class birthday_anniversary extends StatefulWidget {
  const birthday_anniversary({super.key});

  @override
  State<birthday_anniversary> createState() => _birthday_anniversaryState();
}

class _birthday_anniversaryState extends State<birthday_anniversary> {
  String button = "on";
  List<BirthdayModel> birth_data = [];
  List<UpComing_AnniversaryModel> anniver_data = [];
  @override
  void initState() {
    getAllBirthData();
    getAllAniversary();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: MyColor.new_light_gray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
            elevation: 0.0,
            backgroundColor: MyColor.white_color,
            automaticallyImplyLeading: false,
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
                  'Birthday & Annivarsary',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'pop',
                    color: Colors.black,
                  ),
                ),
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 32),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          button = "on";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            color: button == "on"
                                ? MyColor.mainAppColor
                                : MyColor.white_color,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "Birthday",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: button == "on"
                                    ? MyColor.white_color
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          button = "off";
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            color: button == "off"
                                ? MyColor.mainAppColor
                                : MyColor.white_color,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "Anniversary",
                            style: TextStyle(
                                fontFamily: "pop",
                                fontSize: 16,
                                color: button == "off"
                                    ? MyColor.white_color
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (button == "on") ...[
                if (birth_data.isEmpty) ...[
                  Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/no_data_found.svg",
                            height: 60,
                            width: 60,
                          ),
                          Text("No Data",style: TextStyle(fontFamily: "pop",fontSize: 16),)
                        ],
                      ),
                    ),
                  )
                ] else ...[
                  ListView.builder(
                      itemCount: birth_data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 12, right: 12),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColor.white_color,
                              ),
                              padding: EdgeInsets.all(10),
                              //width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipOval(
                                      child: Image.network(
                                        birth_data[index].emp_photo,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(birth_data[index].name),
                                      Text(birth_data[index].emp_birthdate)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ]
              ] else ...[
                if (anniver_data.isEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SvgPicture.asset(
                      "assets/svgs/no_data_found.svg",
                      height: 50,
                      width: 50,
                    ),
                  )
                ]else...[
                ListView.builder(
                    itemCount: anniver_data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 12, right: 12),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColor.white_color,
                            ),
                            padding: EdgeInsets.all(10),
                            //width: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  child: ClipOval(
                                    child: Image.network(
                                      anniver_data[index].profile_photo,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(anniver_data[index].emp_name),
                                    Text(anniver_data[index].emp_anidate)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    ]
              ]
            ],
          ),
        )),
      ),
    );
  }

  void getAllBirthData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? e_id = p.getString('e_id');
    String? token = p.getString('user_access_token');

    var response = await http.get(
        Uri.parse(
            '${baseurl.url}birthday_View?entity_id=${EncryptData.decryptAES(e_id.toString())}'),
        headers: {'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['BirthdayList'];

        print('bdayc  ' + response.body);
        for (var data in jsonArray) {
          BirthdayModel birthdayModel = BirthdayModel(
              name: data['name'],
              emp_birthdate: data['emp_birthdate'],
              emp_photo: data['emp_photo'],
              cake_icon: data['cake_icon'],
              emp_gender: data['emp_gender']);

          setState(() {
            birth_data.add(birthdayModel);
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

  // that's function use to Anniversary Api
  void getAllAniversary() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    String? token = p.getString('user_access_token');
    String? e_id = p.getString('e_id');
    // String? token = p.getString('user_access_token');
    var response = await http.get(
        Uri.parse(
            '${baseurl.url}anniversary_View?entity_id=${EncryptData.decryptAES(e_id.toString())}'),
        headers: {'Authorization': 'Bearer $token'});

    print('annivesary  ' + response.body);

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == "1") {
        var jsonArray = jsonData['AnniversaryList'];
        UpComing_AnniversaryModel aniData;
        for (var data in jsonArray) {
          aniData = UpComing_AnniversaryModel(
              emp_name: data['name'],
              emp_anidate: data['emp_joining_date'],
              profile_photo: data['emp_photo'],
              cake_icon: data['cake_icon'],
              emp_pos_name: data['emp_gender']);
          setState(() {
            anniver_data.add(aniData);
          });
        }
      } else {}
    } else if (response.statusCode == 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("login_check", "false");
      preferences.commit();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    }
  }
}
