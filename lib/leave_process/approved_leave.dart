import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../app_color/color_constants.dart';
import 'leave_module.dart';
import 'package:demo/leave_process/create_leave_request.dart';

class Approved_leave_Tab extends StatefulWidget {
  @override
  Approved_leave_tab_State createState() => Approved_leave_tab_State();
}

class Approved_leave_tab_State extends State<Approved_leave_Tab> {
  @override
  Widget build(BuildContext context) {
    List<LeaveModule> dataLeave = [];

    //http multipart
    /* Future featchData() async {
      var headers = {
        'Authorization':
            'bearer eyj0exaioijkv1qilcjhbgcioijiuzi1nij9.eyj1c2vyx2lkijoimtizndu2nzg5iiwicm9szsi6imfhywfhywfhywfhywfhywfhysisimv4cci6mty4mdc4njczmx0.hsmw6nmzt7zpv1sd9fim46nbnmw2mwbj10bfcjvyovc',
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_LEAVE_REQUEST_LIST'));
      request.fields.addAll({'emp_userid': '17'});

      request.headers.addAll(headers);
print('df');
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }*/
    //  With dio
    /*  Future fetchData () async {
      Dio dio = new Dio();
      String url = 'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_LEAVE_REQUEST_LIST';

      final response = await dio.post(
          url,
          options: Options(
            headers: {'authorization':
            'bearer eyj0exaioijkv1qilcjhbgcioijiuzi1nij9.eyj1c2vyx2lkijoimtizndu2nzg5iiwicm9szsi6imfhywfhywfhywfhywfhywfhysisimv4cci6mty4mdc4njczmx0.hsmw6nmzt7zpv1sd9fim46nbnmw2mwbj10bfcjvyovc',},
          ),queryParameters: {
            'emp_userid':'17'
      });
          print(response.data);
    }*/
    Future<List<LeaveModule>> getAllList() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final String? token = pref.getString("user_access_token");
      String? user_id = pref.getString('user_id');
      var response = await http.post(
          Uri.parse('https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_LEAVE_REQUEST_LIST'),
          body: {
            'emp_userid': user_id.toString(),
          });

      // response.headers.addAll(he);

      if (response.statusCode == 200) {
        print('leave resp ' + response.body);
      } else {
        print('leave resp ed ' + response.body);
      }

      var jsonData = json.decode(response.body);

      var jsonArray = jsonData["LeaveRequestList"];

      for (var leaveData in jsonArray) {
        LeaveModule leaveModule = LeaveModule(
            lr_from_date: leaveData['lr_from_date'],
            lr_to_date: leaveData['lr_to_date'],
            lr_datetime: leaveData['lr_datetime'],
            lr_status: leaveData['lr_status'],
            lr_leave_details: leaveData['lr_leave_details']);

        List<LeaveModule> data = [];
        data.add(leaveModule);




        for (int i = 0; i < data.length; i++) {
          if(data[i].lr_status=='Approved'){
            dataLeave.add(leaveModule);
          }
        }

      }

      return dataLeave;
    }

    return Scaffold(
    /*  appBar: AppBar(
        title: Text(
          'Travel request',
          style: TextStyle(fontSize: 16, fontFamily: 'pop'),

        ),
        backgroundColor: Color(0xFF0054A4),
        elevation: 0,
      ),*/
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            child: InkWell(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/add_icon.png",
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Create leave request",
                        style: TextStyle(color: Color(0xFF0054A4)),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new CreteLeaveRequest(self_select: 'Self',)));
              },
            ),
          ),
          /*FutureBuilder<List<LeaveModule>>(
                future: getAllList(),*/
          Expanded(
            child: FutureBuilder(
                future: getAllList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svgs/no_data_found.svg'),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                  color: MyColor.mainAppColor,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                   if(dataLeave.length==0){
                     return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SvgPicture.asset('assets/svgs/no_data_found.svg'),
                           Padding(
                             padding: EdgeInsets.only(top: 16),
                             child: Text(
                               'No data found',
                               style: TextStyle(
                                   color: MyColor.mainAppColor,
                                   fontSize: 16,
                                   fontFamily: 'pop'),
                             ),
                           )
                         ],
                       ),
                     );
                   }else{
                     return ListView.builder(
                       // physics: NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: dataLeave.length,
                         itemBuilder: (context, index) {

                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Card(
                               child: Padding(
                                 padding: EdgeInsets.all(8),
                                 child: Column(
                                   crossAxisAlignment:
                                   CrossAxisAlignment.stretch,
                                   children: [
                                     Text(
                                       dataLeave[index]
                                           .lr_leave_details
                                           .toString(),
                                       textAlign: TextAlign.end,
                                     ),
                                     Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceEvenly,
                                       children: [
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "Apply date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(dataLeave[index]
                                                   .lr_datetime
                                                   .toString()),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "From date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(dataLeave[index]
                                                   .lr_from_date
                                                   .toString()),
                                             )
                                           ],
                                         ),
                                         Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(
                                                 "To date",
                                               ),
                                             ),
                                             Padding(
                                               padding:
                                               EdgeInsets.only(top: 8),
                                               child: Text(dataLeave[index]
                                                   .lr_to_date),
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                     InkWell(
                                       child: Padding(
                                         padding: EdgeInsets.only(
                                             top: 16,
                                             left: 90,
                                             right: 90,
                                             bottom: 8),
                                         child: Container(
                                           width: 120,
                                           height: 40,
                                           decoration: BoxDecoration(
                                             border: Border.all(
                                                 color: Colors.green),
                                             borderRadius:
                                             BorderRadius.circular(10),
                                           ),
                                           child: Center(
                                             child: Text(
                                               dataLeave[index]
                                                   .lr_status
                                                   .toString(),
                                               style: TextStyle(
                                                 color: Colors.green,
                                                 fontFamily: 'pop',
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       onTap: () {
                                         /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MainHome()),
                                        );*/
                                       },
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           );

                           /*     else {
                            return Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svgs/no_data_found.svg",
                                      width: 100,
                                      height: 100,
                                      alignment: Alignment.center,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.0),
                                      child: Text(
                                        'No record found!',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontFamily: 'pop',
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ));
                          }*/
                         });
                   }
                  }
                }),
          )
        ],
      ),
    );
  }
}
/*
*
 devide in two part horizantal and vertical
 *
 * child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          child: Image.network(
                                            dataLeave[index]
                                                .profile_image
                                                .toString(),
                                            width: 90,
                                            height: 80,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: InkWell(
                                              child: Text(dataLeave[index]
                                                  .shop_name
                                                  .toString()),
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        dataLeave[index]
                                                            .shop_name)));
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: InkWell(
                                              child: Text(dataLeave[index]
                                                  .seller_name
                                                  .toString()),
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        dataLeave[index]
                                                            .seller_name)));
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: InkWell(
                                              child: Text(dataLeave[index]
                                                  .user_id
                                                  .toString()),
                                              onTap: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        dataLeave[index]
                                                            .user_id)));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
* */
/*

// use for space evenly

Padding(padding:  EdgeInsets.only(left: 16,top: 16,right: 16),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          '1st Number',
                        ),
                      ),
                    ),
                    Text(
                      '2nd Number',
                    ),
                    Text(
                      '3nd Number',
                    ),
                  ],
                )),
          ),),


* */
