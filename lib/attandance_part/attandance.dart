import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';

class MyAttandance extends StatefulWidget {
  const MyAttandance({Key? key}) : super(key: key);

  @override
  _MyAttandanceState createState() => _MyAttandanceState();
}

class _MyAttandanceState extends State<MyAttandance> {
  String tdata = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(fontSize: 16, fontFamily: 'pop'),
        ),
        elevation: 0,
        backgroundColor: MyColor.mainAppColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 16),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          child: InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(0),
                          child: Container(
                            height: 58,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              'Check-in',
                              style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          tdata = DateFormat("hh:mm a").format(DateTime.now());
                          print('${tdata}');
                          String ap = tdata.split(' ').last;
                          String dd = tdata.split(':')[0];
                          String dd1 = tdata
                              .split(':')[1]
                              .replaceAll('AM', '')
                              .replaceAll('PM', '');
                          int firstTime = int.parse(dd);
                          int secondTime = int.parse(dd1);
                          if (ap == 'AM') {
                            if (firstTime <= 09 && secondTime <= 45) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fine check in')));
                            } else {
                              check_In_Dialog('in',
                                  'Specify Reason (why are you late today?)');
                            }
                          } else if (ap == 'PM') {
                            if (firstTime >= 06 && secondTime >= 30) {
                            } else {
                              check_In_Dialog('in',
                                  'Specify Reason (why are you late today?)');
                            }
                          }
                        },
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                          child: InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(0),
                          child: Container(
                            height: 58,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              'Check-out',
                              style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          tdata = DateFormat("hh:mm a").format(DateTime.now());
                          print('${tdata}');
                          String ap = tdata.split(' ').last;
                          String dd = tdata.split(':')[0];
                          String dd1 = tdata
                              .split(':')[1]
                              .replaceAll('AM', '')
                              .replaceAll('PM', '');
                          int firstTime = int.parse(dd);
                          int secondTime = int.parse(dd1);

                          if (ap == 'AM') {
                            if (firstTime <= 09 && secondTime <= 45) {
                            } else {
                              check_In_Dialog('out',
                                  'Specify Reason (why are you leaving early today?)');
                            }
                          } else if (ap == 'PM') {
                            if (firstTime >= 06 && secondTime >= 30) {
                              print('object');
                            } else {
                              check_In_Dialog('out',
                                  'Specify Reason (why are you leaving early today?)');
                            }
                          }
                        },
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                          child: InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(0),
                          child: Container(
                            height: 58,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              'Miss check-in\n checkout',
                              style: TextStyle(fontSize: 12, fontFamily: 'pop'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {},
                      )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void check_In_Dialog(String type, String msg) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: MyColor.mainAppColor,
                            )),
                      ),
                      StatefulBuilder(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: RichText(
                                  text: TextSpan(
                                      text: '${msg}',
                                      style: TextStyle(
                                          color: MyColor.mainAppColor,
                                          fontSize: 14),
                                      children: [
                                        TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14))
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 8),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Write here ...'),
                                      maxLines: 5,
                                      minLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 24),
                                child: Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyColor.mainAppColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'pop',
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  void dialog_CheckIn_CheckOut(String type, String msg) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: MyColor.mainAppColor,
                                    )),
                              ),
                              StatefulBuilder(
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Text(
                                          '${msg}',
                                          style: TextStyle(
                                              fontSize: 14, fontFamily: 'pop'),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, right: 16, top: 8),
                                        child: Container(
                                          height: 120,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.topLeft,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 4, right: 4),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Write here ...'),
                                              maxLines: 5,
                                              minLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16, right: 16, top: 24),
                                        child: Container(
                                          height: 48,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: MyColor.mainAppColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'pop',
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
