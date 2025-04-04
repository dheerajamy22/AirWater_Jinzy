import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectUrl extends StatefulWidget {
  const SelectUrl({Key? key}) : super(key: key);

  @override
  State<SelectUrl> createState() => _SelectUrlState();
}

class _SelectUrlState extends State<SelectUrl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(onTap: () async{

            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('url', 'https://jinzyapi.kefify.com/public/api/');
            pref.commit();
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (context)=>new Login_Activity()));

          },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              color: MyColor.mainAppColor,
              child: Text('Dev Jinzy',style: TextStyle(color: MyColor.white_color),),
            ),
          ),
          SizedBox(height: 16,),
          InkWell(onTap: () async{
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('url', 'http://10.10.10.118:8080/api/');
            pref.commit();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context)=>new Login_Activity()));
          },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              color: MyColor.mainAppColor,
              child: Text('Local Jinzy',style: TextStyle(color: MyColor.white_color),),
            ),
          ),
        ],
      ),
    );
  }
}
