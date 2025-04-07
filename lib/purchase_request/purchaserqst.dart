import 'dart:convert';

import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/purchase_request/itemadd.dart';
import 'package:demo/purchase_request/itemsearch.dart';
import 'package:demo/purchase_request/models.dart';
import 'package:demo/purchase_request/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class purchaseRequest extends StatefulWidget {
  const purchaseRequest({super.key});

  @override
  State<purchaseRequest> createState() => _purchaseRequestState();
}

class _purchaseRequestState extends State<purchaseRequest> {
  TextEditingController purchaseRequestTitle = TextEditingController();
  String _total = "";
  List<projectModel> projectList = [];
  List<departmentModel> departmentList = [];
  List<businesslineModel> businesslineList = [];
  List<countryModel> countryList = [];
  List<entityModel> entityList = [];
  List<plantModel> plantList = [];
  List<addItemModel> additemlist = [];
  String? businessLine,
      selectedProject,
      selectedDepartment,
      selectedEntity,
      selectedPlant,
      selectedCountry;
  String? _businessLineId,
      _selectedProjectId,
      _selectedDepartmentId,
      _selectedEntityId,
      _selectedPlantId,
      _selectedCountryId;
  @override
  void initState() {
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
                    'Purchase Request',
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
            children: [
              Text("Purchase Request",
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'pop_m', color: Colors.black)),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Purchase Request Title",
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
                controller: purchaseRequestTitle,
                hintText: "Enter Purchase Request Title",
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Requested Date",
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
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF0054A4)),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                              DateTime.now().toString().split(" ").first,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'pop',
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Total",
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
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF0054A4)),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(_total,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'pop',
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text("Financial Dimension",
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'pop_m', color: Colors.black)),
              const SizedBox(
                height: 16,
              ),
              // Business Line Dropdown
              Row(
                children: [
                  Text("Business Line",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: businessLine, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: businesslineList.map((line) {
                    return DropdownMenuItem<String>(
                      value: line.id,
                      child: Text(line.description),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      businessLine = value; // Update the correct variable
                      for (var i in businesslineList) {
                        if (i.id == value) {
                          _businessLineId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Country Dropdown
              Row(
                children: [
                  Text("Country",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedCountry, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: countryList.map((_country) {
                    return DropdownMenuItem<String>(
                      value: _country.id,
                      child: Text(_country.dynamics_code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value; // Update the correct variable
                      for (var i in countryList) {
                        if (i.id == value) {
                          _selectedCountryId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Department Dropdown
              Row(
                children: [
                  Text("Department",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedDepartment, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: departmentList.map((depart) {
                    return DropdownMenuItem<String>(
                      value: depart.id,
                      child: Text(depart.dept_name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value; // Update the correct variable
                      for (var i in departmentList) {
                        if (i.id == value) {
                          _selectedDepartmentId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Entity Dropdown
              Row(
                children: [
                  Text("Entity",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedEntity, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: entityList.map((_entity) {
                    return DropdownMenuItem<String>(
                      value: _entity.id,
                      child: Text(_entity.description),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEntity = value; // Update the correct variable
                      for (var i in entityList) {
                        if (i.id == value) {
                          _selectedEntityId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Facility Dropdown
              Row(
                children: [
                  Text("Facility",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedPlant, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: plantList.map((fac) {
                    return DropdownMenuItem<String>(
                      value: fac.id,
                      child: Text(fac.description),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlant = value; // Update the correct variable
                      for (var i in plantList) {
                        if (i.id == value) {
                          _selectedPlantId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Project Dropdown
              Row(
                children: [
                  Text("Project",
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
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF0054A4)),
                    borderRadius: BorderRadius.circular(5.0)),
                child: DropdownButton<String>(
                  value: selectedProject, // Use the correct variable
                  hint: Text("Please Select"),
                  isExpanded: true,
                  items: projectList.map((project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProject = value; // Update the correct variable
                      for (var i in projectList) {
                        if (i.id == value) {
                          _selectedProjectId = i.id;
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      addItemModel newItem = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addItem()),
                      );

                      setState(() {
                        additemlist.add(newItem);
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0054A4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: MyColor.white_color, size: 16),
                          const Text(
                            'Item',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'pop_m',
                                color: MyColor.white_color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      List<serachItemModel> data = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => searchItem()),
                      );
                      setState(() {
                        for (var item in data) {
                          // addItemModel array = addItemModel(
                          //   itemname: item.name,
                          //   itemcode: item.code,
                          //   categoryname: item.category,
                          //   unitname: item.unit,
                          //   quantity: "1",
                          //   estimateprice: "0", // Provide a default value
                          //   netamount: "",
                          // );

                          addItemModel array = addItemModel(
                            itemCode: item.code,
                            itemName: item.name,
                            category: item.category,
                            unit: item.unit,
                            quantity: 1,
                            estimatePrice: "0",
                            price: 0.0,
                          );
                          additemlist.add(array);
                        }
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0054A4),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search,
                              color: MyColor.white_color, size: 16),
                          const Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'pop_m',
                                color: MyColor.white_color),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              if (additemlist.isEmpty)
                ...[

              ]else ...[
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.3, // Set a specific height
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: MyColor.white_color,
                      borderRadius: BorderRadius.circular(5)),
                  child: ListView.builder(
                    itemCount: additemlist.length,
                    itemBuilder: (context, index) {
                      TextEditingController quantityController =
                          TextEditingController(
                              text: additemlist[index].quantity.toString());
                      quantityController.text =
                          additemlist[index].quantity.toString();
                      TextEditingController estimatepriceController =
                          TextEditingController(
                              text:
                                  additemlist[index].estimatePrice.toString());
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: MyColor.background_light_blue),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          additemlist.removeAt(index);
                                        });
                                      },
                                      child: Icon(Icons.delete,
                                          color: MyColor.red_color, size: 16),
                                    ),
                                  ),
                                  Text(
                                      'Item Name: ${additemlist[index].itemName}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: Colors.black)),
                                  Text(
                                      'Item Code: ${additemlist[index].itemCode}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: Colors.black)),
                                  Text(
                                      'Category: ${additemlist[index].category}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: Colors.black)),
                                  Text('Unit: ${additemlist[index].unit}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: Colors.black)),
                                  Row(
                                    children: [
                                      Text("Quantity:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black)),
                                      Expanded(
                                        child: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          // decoration: InputDecoration(
                                          //   border: InputBorder.none
                                          // ),
                                          onChanged: (value) {
                                            setState(() {
                                              additemlist[index].quantity =
                                                  double.parse(value);
                                              if (estimatepriceController
                                                  .text.isNotEmpty) {
                                                additemlist[index]
                                                    .price = (double.parse(
                                                        estimatepriceController
                                                            .text) *
                                                    double.parse(value));
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Estimate Price:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black)),
                                      Expanded(
                                        child: TextField(
                                          controller: estimatepriceController,
                                          keyboardType: TextInputType.number,
                                          // decoration: InputDecoration(
                                          //   border: InputBorder.none
                                          // ),
                                          onChanged: (value) {
                                            setState(() {
                                              additemlist[index].estimatePrice =
                                                  value.toString();
                                              if (quantityController
                                                  .text.isNotEmpty) {
                                                additemlist[index].price =
                                                    (double.parse(
                                                            quantityController
                                                                .text) *
                                                        double.parse(value));
                                              }
                                              _total=_total+
                                                  additemlist[index].price
                                                      .toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      'Net Amount: ${additemlist[index].price}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'pop',
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    if (validation()) {
                      _sendPurchaseRequestData();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFF0054A4),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text("Save",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'pop_m',
                              color: MyColor.white_color)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendPurchaseRequestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_access_token');

    int businessLineId = _businessLineId != null ? int.parse(_businessLineId!) : 0; // or handle it appropriately
int countryId = _selectedCountryId != null ? int.parse(_selectedCountryId!) : 0; // or handle it appropriately
int departmentId = _selectedDepartmentId != null ? int.parse(_selectedDepartmentId!) : 0; // or handle it appropriately
int entityId = _selectedEntityId != null ? int.parse(_selectedEntityId!) : 0; // or handle it appropriately
int plantId = _selectedPlantId != null ? int.parse(_selectedPlantId!) : 0; // or handle it appropriately
int projectId = _selectedProjectId != null ? int.parse(_selectedProjectId!) : 0; // or handle it appropriately

  PurchaseRequest purchaseRequest = PurchaseRequest(
    name: purchaseRequestTitle.text,
    requestedDate: DateTime.now().toString().split(" ").first,
    businessLineId: businessLineId,
    countryId: countryId,
    departmentId: departmentId,
    entityId: entityId,
    plantId: plantId,
    projectId:  projectId,
    lines: additemlist,
  );


    var response = await http
        .post(Uri.parse('${baseurl.url}purchase-request-store'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    }, body: jsonEncode(purchaseRequest.toJson()),);
  
  print(response.statusCode);
  print(response.body);
  }

  bool validation() {
    if (purchaseRequestTitle.text.isEmpty) {
      _showMyDialog('Please Enter Title', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_businessLineId == "") {
      _showMyDialog(
          'Please Select Business Line', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedCountryId == "") {
      _showMyDialog(
          'Please Select Country', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedDepartmentId == "") {
      _showMyDialog(
          'Please Select Department', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedEntityId == "") {
      _showMyDialog(
          'Please Select Entity', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedPlantId == "") {
      _showMyDialog(
          'Please Select Facility', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedProjectId == "") {
      _showMyDialog(
          'Please Select Project', MyColor.dialog_error_color, 'error');
      return false;
    } else if (additemlist.isEmpty) {
      _showMyDialog('Please Add Items', MyColor.dialog_error_color, 'error');
      return false;
    }
    return true;
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
      for (var i in jsonObject['project']) {
        projectModel data = projectModel(
          id: i['id'].toString(),
          name: i['name'],
          code: i['code'],
          description: i['description'],
        );
        setState(() {
          projectList.add(data);
        });
      }

      for (var i in jsonObject['department']) {
        departmentModel data = departmentModel(
          id: i['id'].toString(),
          dept_name: i['dept_name'],
          dept_code: i['dept_code'],
        );
        setState(() {
          departmentList.add(data);
        });
      }
      for (var i in jsonObject['business_line']) {
        businesslineModel data = businesslineModel(
          id: i['id'].toString(),
          name: i['name'],
          code: i['code'],
          description: i['description'],
        );
        setState(() {
          businesslineList.add(data);
        });
      }
      for (var i in jsonObject['country']) {
        countryModel data = countryModel(
          id: i['id'].toString(),
          dynamics_code: i['dynamics_code'],
        );
        setState(() {
          countryList.add(data);
        });
      }
      for (var i in jsonObject['entity']) {
        entityModel data = entityModel(
          id: i['id'].toString(),
          name: i['name'],
          code: i['code'],
          description: i['description'],
        );
        setState(() {
          entityList.add(data);
        });
      }
      for (var i in jsonObject['plant']) {
        plantModel data = plantModel(
          id: i['id'].toString(),
          name: i['name'],
          code: i['code'],
          description: i['description'],
        );
        setState(() {
          plantList.add(data);
        });
      }
    } else if (response.statusCode == 401) {
      print("Unauthorized");
    } else if (response.statusCode == 500) {
      print("Internal Server Error");
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    } else if (response.statusCode == 404) {
      print("Not Found");
    } else if (response.statusCode == 400) {
      print("Bad Request");
    } else {
      print("Unknown Error");
    }
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
}
