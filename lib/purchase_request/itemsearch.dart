import 'dart:convert';

import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/purchase_request/purchaserqstmodels.dart';
import 'package:demo/purchase_request/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class searchItem extends StatefulWidget {
  const searchItem({super.key});

  @override
  State<searchItem> createState() => _searchItemState();
}

class _searchItemState extends State<searchItem> {
  TextEditingController searchController = TextEditingController();
  List<serachItemModel> allitems = [];
  List<serachItemModel> searchitemList = [];
  List<serachItemModel> selectedItems = [];
  List<categoryModel> categoryList = [];
  List<itemgroup> itemgroupList = [];
  String? selectedcategory, selecteditem;

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
              InkWell(
                onTap: () {
                  _showSearchDialog();
                },
                child: Container(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: const Text(
                      'Search Item',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'pop',
                          color: MyColor.white_color),
                    )),
              ),
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
                        Navigator.pop(context, selectedItems);
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
                    onTap: () {
                      _showSearchDialog();
                    },
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
              if (searchitemList.isEmpty) ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ] else ...[
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: searchitemList.length,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
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
                                  : MyColor
                                      .white_color, // Change color if selected
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
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text("Filters",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'pop_m',
                                color: Colors.black)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text("Purchase Request Title",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'pop',
                              color: Colors.black)),
                      const SizedBox(height: 5),
                      CustomTextField(
                        controller: searchController,
                      ),
                      const SizedBox(height: 10),
                      Text("Category",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'pop',
                              color: Colors.black)),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0054A4)),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: DropdownButton<String>(
                          value: selectedcategory, // Use the correct variable
                          hint: Text("Select Category"),
                          isExpanded: true,
                          items: categoryList.map((line) {
                            return DropdownMenuItem<String>(
                              value: line.name,
                              child: Text(line.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedcategory = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Item Group",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'pop',
                              color: Colors.black)),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0054A4)),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: DropdownButton<String>(
                          value: selecteditem, // Use the correct variable
                          hint: Text("Select Item Group"),
                          isExpanded: true,
                          items: itemgroupList.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selecteditem = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                // Reset filters
                                setState(() {
                                  selectedcategory = null;
                                  selecteditem = null;
                                  searchController.clear();
                                  print("allitem lenght ${allitems.length}");
                                  // Optionally, you can reset the searchitemList to its original state
                                  rollback();
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors
                                        .red, // Change color for reset button
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("Reset Filters",
                                    style:
                                        TextStyle(color: MyColor.white_color)),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                applyfilters();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF0054A4),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("Apply Filters",
                                    style:
                                        TextStyle(color: MyColor.white_color)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void rollback() {
    setState(() {
      searchitemList = allitems;
      print('lenth after reset ${searchitemList.length}');
    });
  }

  void applyfilters() {
    List<serachItemModel> filteredList = allitems;

    // Check if selected category is not null or empty
    if (selectedcategory != null &&
        selectedcategory!.isNotEmpty &&
        selecteditem != null &&
        selecteditem!.isNotEmpty) {
      print(selectedcategory);
      print(selecteditem);
      filteredList = filteredList
          .where((item) =>
              item.category == selectedcategory ||
              item.itemgroup == selecteditem)
          .toList();
    }
    setState(() {
      searchitemList = filteredList;
      print(searchitemList.length); // Print the length of the filtered list
    });
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
          allitems.add(data);
        });
      }
      for (var i in jsonObject['category']) {
        categoryModel data = categoryModel(
          id: i['id'].toString(),
          name: i['name'],
        );
        setState(() {
          categoryList.add(data);
        });
      }

      for (var i in jsonObject['item_group']) {
        itemgroup data = itemgroup(name: i['name'], code: i['code']);
        setState(() {
          itemgroupList.add(data);
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
