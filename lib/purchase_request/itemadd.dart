import 'dart:convert';

import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/purchase_request/purchaserqstmodels.dart';
import 'package:demo/purchase_request/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class addItem extends StatefulWidget {
  const addItem({
    Key? key,
  });

  @override
  State<addItem> createState() => _addItemState();
}

class _addItemState extends State<addItem> {
  TextEditingController itemcode = TextEditingController();
  TextEditingController itemname = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController estimateprice = TextEditingController();

  List<categoryModel> categoryList = [];
  List<unitsModel> UnitList = [];
  String? selectedCategory, selectedCategoryId;
  String? selectedUnit, selectedUnitId;
  String netamount = "";
  List<addItemModel> addItemList = [];

  @override
  void initState() {
    quantity.text = "1";
    getvalue();
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
                    'Add Item',
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
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              //     Text("Item Code",
              //         style: TextStyle(
              //             fontSize: 14,
              //             fontFamily: 'pop',
              //             color: Colors.black)),
              //     Text(" *",
              //         style: TextStyle(
              //             fontSize: 16,
              //             fontFamily: 'pop_m',
              //             color: Colors.red)),
              //   ],
              // ),
              // const SizedBox(
              //   height: 6,
              // ),
              // CustomTextField(
              //   controller: itemcode,
              //   hintText: "Item Code",
              //   obscureText: false,
              //   keyboardType: TextInputType.text,
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              Row(
                children: [
                  Text("Item Name",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" *",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
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
              Row(
                children: [
                  Text("Category",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" *",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedCategory, // Use the correct variable
                  hint: Text("Select Category"),
                  isExpanded: true,
                  items: categoryList.map((_country) {
                    return DropdownMenuItem<String>(
                      value: _country.name,
                      child: Text(_country.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value; // Update the correct variable
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Unit",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" *",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedUnit, // Use the correct variable
                  hint: Text("Select Unit"),
                  isExpanded: true,
                  items: UnitList.map((_country) {
                    return DropdownMenuItem<String>(
                      value: _country.name,
                      child: Text(_country.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value; // Update the correct variable
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text("Quantity",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              CustomTextField(
                controller: quantity,
                hintText: "Enter Quantity",
                obscureText: false,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text("Estimate Price(AED)",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextField(
                  controller: estimateprice,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Estimate Price",
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (estimateprice.text.isEmpty) {
                        netamount = "0.00";
                      } else {
                        netamount = (double.parse(quantity.text) *
                                double.parse(estimateprice.text))
                            .toStringAsFixed(2);
                        print(netamount);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text("Net Amount",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  Text(" ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.red)),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text(netamount,
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'pop', color: Colors.black)),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // addItemModel newItem = addItemModel(
                    //     itemcode: itemcode.text,
                    //     itemname: itemname.text,
                    //     categoryname: selectedCategory!,
                    //     unitname: selectedUnit!,
                    //     quantity: quantity.text,
                    //     estimateprice: estimateprice.text,
                    //     netamount: netamount);

                    if (validation()) {
                      addItemModel newItem = addItemModel(
                        itemCode: "",
                        itemName: itemname.text.toString().trim(),
                        category: selectedCategory!,
                        unit: selectedUnit!,
                        quantity: double.parse(quantity.text),
                        estimatePrice: estimateprice.text.isEmpty
                            ? "0"
                            : estimateprice.text,
                        price: estimateprice.text.isEmpty
                            ? double.parse("0.0")
                            : double.parse(netamount),
                      );

                      setState(() {
                        addItemList.add(newItem);
                      });

                      Navigator.pop(context, newItem);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF0054A4),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      'Submit',
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
        ),
      ),
    );
  }

  bool validation() {
    if (itemname.text.toString().trim() == "") {
      _showMyDialog(
          'Please Enter Item Name', MyColor.dialog_error_color, 'error');

      return false;
    } else if (selectedCategory == null) {
      _showMyDialog(
          'Please Select Category', MyColor.dialog_error_color, 'error');

      return false;
    } else if (selectedUnit == null) {
      _showMyDialog('Please Select Unit', MyColor.dialog_error_color, 'error');

      return false;
    }
    return true;
  }

  Future<void> _showMyDialog(
      String msg, Color color_dynamic, String success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          if (success == 'success') ...[
            Icon(
              Icons.check,
              color: MyColor.white_color,
            ),
          ] else ...[
            Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
          ],
          SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            msg,
            style: TextStyle(color: MyColor.white_color),
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: color_dynamic,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
    ));
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
