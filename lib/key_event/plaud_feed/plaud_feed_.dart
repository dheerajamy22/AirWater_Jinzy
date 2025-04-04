import 'package:flutter/material.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/send_plaud/send_plaud_.dart';

class My_Plaud_feed extends StatefulWidget {
  const My_Plaud_feed({Key? key}) : super(key: key);

  @override
  _My_Plaud_feedState createState() => _My_Plaud_feedState();
}

class _My_Plaud_feedState extends State<My_Plaud_feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Plaud',
          style: TextStyle(fontSize: 18, fontFamily: 'pop'),
        ),
        backgroundColor: MyColor.mainAppColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plaud to',
                style: TextStyle(
                  fontFamily: 'pop_m',
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Search employee name',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  'Plaud type',
                  style: TextStyle(fontSize: 16, fontFamily: 'pop_m'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('Teamwork'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('Fast delivery'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('Creative'),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('Teamwork'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('Fast delivery'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Plaud points',
                  style: TextStyle(fontFamily: 'pop_m', fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('10 pts'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('20 pts'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('30 pts'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('50 pts'),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      child: Text('other'),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyColor.mainAppColor),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16, fontFamily: 'pop'),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new My_Send_Plaud()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
