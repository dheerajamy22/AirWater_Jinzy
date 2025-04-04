import 'dart:convert';

import 'package:demo/baseurl/base_url.dart';
import 'package:demo/purchase_request/models.dart';
import 'package:demo/purchase_request/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DropdownDialogContent extends StatefulWidget {
  @override
  _DropdownDialogContentState createState() => _DropdownDialogContentState();
}

class _DropdownDialogContentState extends State<DropdownDialogContent> {
  TextEditingController itemcode = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController estimateprice = TextEditingController();

  List<categoryModel> categoryList = [];
  List<unitsModel> UnitList = [];
  String? selectedCategory, selectedCategoryId;
  String? selectedUnit, selectedUnitId;

  @override
  void initState() {
    getvalue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: itemcode,
            hintText: "Item Code",
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            controller: itemname,
            hintText: "Item Name",
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0054A4)),
                borderRadius: BorderRadius.circular(5.0)),
            child: DropdownButton<String>(
              value: selectedCategory, // Use the correct variable
              hint: Text("Please Select"),
              isExpanded: true,
              items: categoryList.map((_country) {
                return DropdownMenuItem<String>(
                  value: _country.id,
                  child: Text(_country.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value; // Update the correct variable
                  for (var i in categoryList) {
                    if (i.id == value) {
                      selectedCategoryId = i.id;
                    }
                  }
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0054A4)),
                borderRadius: BorderRadius.circular(5.0)),
            child: DropdownButton<String>(
              value: selectedUnit, // Use the correct variable
              hint: Text("Please Select"),
              isExpanded: true,
              items: UnitList.map((_country) {
                return DropdownMenuItem<String>(
                  value: _country.id,
                  child: Text(_country.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value; // Update the correct variable
                  for (var i in UnitList) {
                    if (i.id == value) {
                      selectedUnitId = i.id;
                    }
                  }
                });
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            controller: quantity,
            hintText: "Enter Quantity",
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomTextField(
            controller: estimateprice,
            hintText: "Enter Estimate Price",
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  void getvalue() async {
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
      for (var i in jsonObject['category']) {
        categoryModel data = categoryModel(
          id: i['id'].toString(),
          name: i['name'],
        );
        setState(() {
          categoryList.add(data);
        });
      }
      for (var i in jsonObject['units']) {
        unitsModel data = unitsModel(
          id: i['id'].toString(),
          name: i['name'],
        );
        setState(() {
          UnitList.add(data);
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
