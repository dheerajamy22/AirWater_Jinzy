
import 'package:flutter/material.dart';
import 'package:demo/upcoming_birthday/birthday_model.dart';

class UpComing_Birthday extends StatefulWidget {
  const UpComing_Birthday({Key? key}) : super(key: key);

  @override
  State<UpComing_Birthday> createState() => _UpComing_BirthdayState();
}

class _UpComing_BirthdayState extends State<UpComing_Birthday> {
  @override
  Widget build(BuildContext context) {
    List<BirthdayModel> birth_data = [];



    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF0054A4),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: Text(
                  'Upcoming Birthday',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'pop',
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    'assets/images/powered_by_tag.png',
                    width: 90,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        /*title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,*/

      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
