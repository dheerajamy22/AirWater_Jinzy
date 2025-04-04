import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../new_dashboard_2024/updated_dashboard_2024.dart';

class My_Profile extends StatefulWidget {
  const My_Profile({Key? key}) : super(key: key);

  @override
  _My_ProfileState createState() => _My_ProfileState();
}

class _My_ProfileState extends State<My_Profile> {
  String? user_emp_code;
  String? user_name;
  String? user_email;
  String? emp_joining_date;
  String? emp_pos_name;
  String? emp_notice_period;
  String? emp_probation_period;
  String? user_profile;

  getAllSharedData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_emp_code = pref.getString('user_emp_code');
      user_name = pref.getString('user_name');
      user_email = pref.getString('user_email');
      emp_joining_date = pref.getString('emp_joining_date');
      emp_pos_name = pref.getString('emp_pos_name');
      emp_notice_period = pref.getString('emp_notice_period');
      emp_probation_period = pref.getString('emp_probation_period');
      user_profile = pref.getString('user_profile');
    });
    print('name $user_name');
  }

  @override
  void initState() {
    getAllSharedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white_color,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor.mainAppColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            
          onPressed: (() {
            Navigator.of(context).pop();
          }), icon: const Icon(
            Icons.arrow_back,
            color: MyColor.white_color,
          )
          ),
          title:  const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                    fontSize: 18, fontFamily: 'pop', color: Colors.white),
              ),
              ],
          )),
      body: Stack(
        children: [


          SingleChildScrollView(
           reverse: false,
            child: Padding(
              padding:  const EdgeInsets.only(top: 130.0),
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        color: MyColor.white_color,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${EncryptData.decryptAES(user_name.toString())}',
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: 'pop_m'),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Emp code',
                                          style: TextStyle(
                                              fontSize: 16, fontFamily: 'pop'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 52,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text('${EncryptData.decryptAES(user_emp_code.toString())}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'pop')),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('D.O.J',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'pop')),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 52,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  emp_joining_date.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'pop')),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding:  EdgeInsets.only(top: 8.0),
                                child: Text('Email id',style: TextStyle(fontSize: 16,fontFamily: 'pop')),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    height: 52,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          '${EncryptData.decryptAES(user_email.toString())}',style: const TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                    ),
                                  )),
                              const Padding(
                                padding:  EdgeInsets.only(top: 8.0),
                                child: Text('Designation',style: TextStyle(fontSize: 16,fontFamily: 'pop'),),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    height: 52,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          '${EncryptData.decryptAES(emp_pos_name.toString())}',style: const TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Notice period',style: TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                            Padding(
                                              padding:  const EdgeInsets.only(top:4.0),
                                              child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 52,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                      child: Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 8.0),
                                              child: Text('$emp_notice_period',style: const TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                      ),
                                    ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Probation period',style: TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                            Padding(
                                              padding:  const EdgeInsets.only(top: 4.0),
                                              child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 52,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                                border:
                                                    Border.all(color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                      child: Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 8.0),
                                              child: Text(emp_probation_period.toString(),style: const TextStyle(fontSize: 16,fontFamily: 'pop'),),
                                      ),
                                    ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: InkWell(
                                  child: Container(
                                    height: 52,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: MyColor.mainAppColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'pop'),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 upcoming_dash()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Container(
            height: 90,
            color: MyColor.mainAppColor,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:  const EdgeInsets.only(top:16.0),
              child: Container(
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black)
                ),
                child: Stack(

                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        child: ClipOval(
                          child: InkWell(
                            child: Image.network(
                              '${EncryptData.decryptAES(user_profile.toString())}',
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                            onTap: () {

                            },
                          ),
                        ),
                      ),
                    ),
                    /*const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:  EdgeInsets.only(right: 0.0),
                          child: Icon(Icons.camera_alt,size: 35,color: MyColor.mainAppColor,),
                        ))*/
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
