import 'dart:convert';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class paySlip extends StatefulWidget {
  const paySlip({super.key});

  @override
  State<paySlip> createState() => _paySlipState();
}

class _paySlipState extends State<paySlip> {
  DateTime selectedDate = DateTime.now();
  int selectedMonthIndex = DateTime.now().month - 1; // Current month
  int selectedYear = DateTime.now().year;
  String url = "", name = "";
  bool _isLoading = false;
  double _progress = 0.0;
  String progress = "";
  CancelToken cancelToken = CancelToken(); // Dio cancel token

  List<String> months = [
    '01 Jan',
    '02 Feb',
    '03 Mar',
    '04 Apr',
    '05 May',
    '06 Jun',
    '07 Jul',
    '08 Aug',
    '09 Sep',
    '10 Oct',
    '11 Nov',
    '12 Dec'
  ];

  @override
  void initState() {
    super.initState();
    getSlip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
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
                    child: Icon(Icons.arrow_back, color: MyColor.white_color),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      'Pay Slip',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'pop',
                          color: MyColor.white_color),
                    ),
                  ),
                ],
              ),
              Row(
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
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 14),
                  onPressed: () {
                    setState(() {
                          progress="";
        url = '';
        name = '';
                      if (selectedMonthIndex == 0) {
                        selectedMonthIndex = months.length - 1;
                        selectedYear -= 1;
                      } else {
                        selectedMonthIndex -= 1;
                      }
                    });
                    getSlip();
                  },
                ),
                Text(
                  '${months[selectedMonthIndex].split(' ').last} ${selectedYear.toString()}',
                  style: TextStyle(fontFamily: "pop", fontSize: 14),
                ),
                Visibility(
                  visible: DateFormat("MMM yyyy").format(DateTime.now()) !=
                      '${months[selectedMonthIndex].split(' ').last} ${selectedYear.toString()}',
                  child: IconButton(
                    icon: Icon(Icons.chevron_right, size: 14),
                    onPressed: () {
                      setState(() {
                        progress = "";
                        url = '';
                        name = '';
                        if (selectedMonthIndex == months.length - 1) {
                          selectedMonthIndex = 0;
                          selectedYear += 1;
                        } else {
                          selectedMonthIndex += 1;
                        }
                      });
                      getSlip();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (progress == '')
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: MyColor.mainAppColor,
                )),
              )
            else if (url != "") ...[
              // Show file only if the URL is available
              InkWell(
                onTap: () async {
                  await downloadAndOpenFile(url);
                },
                child: Card(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColor.white_color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/pdf.png',
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name),
                                Text(
                                    '${months[selectedMonthIndex].toString().split(" ").last} Pay Slip')
                              ],
                            ),
                          ],
                        ),
                       if (_isLoading)
  Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(
      children: [
        CircularProgressIndicator(
          value: _progress / 100,  // This binds the progress to the CircularProgressIndicator
        ),
        SizedBox(height: 8),
        Text('${_progress.toStringAsFixed(0)}%'),  // Displaying the progress as an integer
      ],
    ),
  ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svgs/no_data_found.svg'),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'No data found',
                        style: TextStyle(
                            color: MyColor.mainAppColor,
                            fontSize: 16,
                            fontFamily: 'pop'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

 Future<void> downloadAndOpenFile(String url) async {
  try {
    // Request storage permission
    await _requestPermissions();

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${url.split('/').last}';

    final dio = Dio();
    // dio.options = BaseOptions(
    //   connectTimeout: Duration(seconds: 1),
    //   receiveTimeout: Duration(seconds: 1),
    // );

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Download the file with progress
    await dio.download(url, filePath, cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
      if (total != -1) {
        setState(() {
          // Update progress based on received bytes and total bytes
          _progress = (received / total) * 100;
        });
      }
    });

    // Open the file once downloaded
    final result = await OpenFile.open(filePath);
    debugPrint("OpenFile result: ${result.message}");
  } catch (e) {
    debugPrint("Error downloading or opening file: $e");
  } finally {
    setState(() {
      _isLoading = false;  // Set loading to false after the download is complete
    });
  }
} 

Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      print("Storage permission granted.");
    } else if (status.isDenied) {
      print("Storage permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("Storage permission permanently denied.");
      openAppSettings();
    }
  }

  @override
  void dispose() {
    // Cancel the ongoing download if the user presses back
    cancelToken.cancel();
    super.dispose();
  }

  void getSlip() async {
    setState(() {
      progress == '';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_access_token');
    var response = await http.post(
      Uri.parse('${baseurl.url}pay-slip'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'month': '${months[selectedMonthIndex].toString().split(" ").first}',
        'year': selectedYear.toString()
      },
    );
    var jsonObject = jsonDecode(response.body);
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        progress = "1";
        url = jsonObject['pay_slip'];
        name = jsonObject['emp_name'];
      });
    } else if (response.statusCode == 422) {
      setState(() {
        progress = "1";
        url = '';
        name = '';
      });
    }
  }
}
