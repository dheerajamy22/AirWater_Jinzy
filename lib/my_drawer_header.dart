import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo/encryption_file/encrp_data.dart';
import 'package:demo/main_home/profile/_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_color/color_constants.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String? user_name = '';
  String? user_email = '';
  String? user_profile = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: MyColor.mainAppColor));
    return SafeArea(
      top: true,
      child: Column(children: [
        Container(
            color: MyColor.white_color,
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: EncryptData.decryptAES(user_profile.toString()) != "" && EncryptData.decryptAES(user_profile.toString()).isNotEmpty
                              ?Image.network(
                            EncryptData.decryptAES(user_profile.toString()),
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ):Image.network(
                          'https://via.placeholder.com/150', // Placeholder image URL
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const My_Profile()));
                      },
                    ),
                  ),
                  SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${EncryptData.decryptAES(user_name.toString())}',
                        style: const TextStyle(color: Colors.black, fontSize: 16,fontFamily: 'pop_m'),
                      ),
                      Text(
                        '${EncryptData.decryptAES(user_email.toString())}',
                        style: TextStyle(color: MyColor.grey_color, fontSize: 12,fontFamily: 'pop'),
                      ),
                    ],
                  ),

                ],
              ),
            )),
        Divider(height: 2,color: MyColor.light_gray,),
      ]),
    );
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      user_name = pref.getString('user_name');
      user_email = pref.getString('user_email');
      user_profile = pref.getString('user_profile');
    });
  }
}
