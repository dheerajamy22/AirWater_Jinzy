import 'dart:convert';

import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/purchase_request/itemadd.dart';
import 'package:demo/purchase_request/models.dart';
import 'package:demo/purchase_request/purchaserqst.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class searchItem extends StatefulWidget {
  const searchItem({super.key});

  @override
  State<searchItem> createState() => _searchItemState();
}

class _searchItemState extends State<searchItem> {
  List<serachItemModel> searchitemList = [];
  List<serachItemModel> selectedItems = [];
  @override
  void initState() {
    getitem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.new_light_gray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF0054A4),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: MyColor.white_color,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: const Text(
                    'Search Item',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'pop',
                        color: MyColor.white_color),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (selectedItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 1000),
                            content: Text(
                              'Please select an item first.',
                            ),
                          ),
                        );
                      } else {
                        Navigator.pop(context,selectedItems);
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0054A4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: const Text(
                          'Get Item',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'pop_m',
                              color: MyColor.white_color),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0054A4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: const Text(
                          'Filters',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'pop_m',
                              color: MyColor.white_color),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if(searchitemList.isEmpty)...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ]else...[ ListView.builder(
                itemCount: searchitemList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = searchitemList[index];
                  final isSelected = selectedItems
                      .contains(item); // Check if the item is selected

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedItems.remove(item); // Deselect the item
                        } else {
                          selectedItems.add(item); // Select the item
                        }
                      });
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        // margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue[100]
                              : MyColor.white_color, // Change color if selected
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors
                                    .transparent, // Border color if selected
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'pop',
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.code.toString(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'pop',
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )]
             
            ],
          ),
        ),
      ),
    );
  }

  void getitem() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_access_token');
    var response = await http
        .get(Uri.parse('${baseurl.url}purchase-request-all-master'), headers: {
      'Authorization': 'Bearer $token',
    });
    print(response.statusCode);
    print(response.body);
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var i in jsonObject['items']) {
        serachItemModel data = serachItemModel(
            id: i['id'],
            name: i['name'],
            code: i['code'],
            unit: i['unit'],
            itemgroup: i['item_group'],
            category: i['category']);
        setState(() {
          searchitemList.add(data);
        });
      }
    } else if (response.statusCode == 401) {
      print("Unauthorized");
    } else if (response.statusCode == 500) {
      print("Internal Server Error");
    } else if (response.statusCode == 404) {
      print("Not Found");
    } else if (response.statusCode == 400) {
      print("Bad Request");
    } else {
      print("Unknown Error");
    }
  }
}
