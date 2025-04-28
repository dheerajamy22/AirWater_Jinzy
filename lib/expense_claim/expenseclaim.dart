import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:demo/_login_part/login_activity.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/baseurl/base_url.dart';
import 'package:demo/expense_claim/expenseclaimmodel.dart';
import 'package:demo/expense_details.dart';
import 'package:demo/new_dashboard_2024/updated_dashboard_2024.dart';
import 'package:demo/purchase_request/purchaserqstmodels.dart';
import 'package:demo/purchase_request/textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class expenseClaim extends StatefulWidget {
  const expenseClaim({super.key});

  @override
  State<expenseClaim> createState() => _expenseClaimState();
}

class _expenseClaimState extends State<expenseClaim> {
  TextEditingController FromedateInput = TextEditingController();
  TextEditingController TodateInput = TextEditingController();
  TextEditingController description = TextEditingController();
  String datevalid = "";
  List<projectModel> projectList = [];
  List<departmentModel> departmentList = [];
  List<businesslineModel> businesslineList = [];
  List<countryModel> countryList = [];
  List<entityModel> entityList = [];
  List<plantModel> plantList = [];
  List<ExpenseCategory> ExpenseCategorylist = [];
  List<currency> currencyList = [];
  List<showlines> showlinesList = [];
  List<Line> line = [];
  String? businessLine,
      selectedProject,
      selectedDepartment,
      selectedEntity,
      selectedPlant,
      selectedCountry,
      selectedCurrency,
      selectedExpenseCategory;
  String? _businessLineId,
      _selectedProjectId,
      _selectedDepartmentId,
      _selectedEntityId,
      _selectedPlantId,
      _selectedCountryId,
      _slectedCurrencyId,
      _selectedExpenseCategoryId;

  TextEditingController amount = TextEditingController();

  bool amountIsEmpty = false, date_is_empty = false, dropDown_isEmpty = false;
  List<Map<String, dynamic>> media = [];
  String encodeImage = '';
  FilePickerResult? result;
  String? filename;
  PlatformFile? pickedfile;
  File? filetodisplay;
  bool _isLoading = false;
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
                    child: Icon(
                      Icons.arrow_back,
                      color: MyColor.white_color,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: const Text(
                        'Expense Claim',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'pop',
                            color: MyColor.white_color),
                      )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 16, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF0054A4)),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                                controller: FromedateInput,
                                //editing controller of this TextField
                                decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFF0054A4),
                                    ),
                                    //icon of text field
                                    hintText: "From date",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "pop",
                                        fontSize: 14)
                                    //label text of field
                                    ),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'pop'),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: TodateInput == ""
                                          ? DateTime.parse(TodateInput.text)
                                          : DateTime.now()
                                              .subtract(Duration(days: 1)),
                                      firstDate: DateTime(2000),

                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: TodateInput == ""
                                          ? DateTime.parse(TodateInput.text)
                                          : DateTime.now()
                                              .subtract(Duration(days: 1)));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16

                                    setState(() {
                                      FromedateInput.text = formattedDate;
                                      if (FromedateInput.text != '' &&
                                          TodateInput.text !=
                                              '') {} //set output date to TextField value.
                                    });
                                  } else {}
                                }),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF0054A4)),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: TodateInput,
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF0054A4),
                                  ),
                                  //icon of text field
                                  hintText: "To date",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "pop",
                                      fontSize: 14)
                                  //label text of field
                                  ),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                              readOnly: true,
                              onTap: () async {
                                if (FromedateInput.text == "") {
                                  _showMyDialog('Please Select From Date First',
                                      const Color(0xFF861F41), 'error');
                                } else {
                                  String startDate = '';
                                  if (FromedateInput.text == '') {
                                    startDate = DateTime.now().toString();
                                  } else {
                                    startDate = FromedateInput.text;
                                  }
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.parse(startDate),
                                      firstDate: DateTime(2000),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime.now()
                                          .subtract(Duration(days: 1)));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16

                                    setState(() {
                                      TodateInput.text = formattedDate;
                                    });
                                  } else {}
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text("Description",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'pop',
                          color: Colors.black)),
                  const SizedBox(
                    height: 6,
                  ),
                  CustomTextField(
                    controller: description,
                    hintText: "Enter Description",
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text("Financial Dimension",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop_m',
                          color: Colors.black)),
                  const SizedBox(
                    height: 16,
                  ),
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
                          selectedCountry =
                              value; // Update the correct variable
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
                          selectedDepartment =
                              value; // Update the correct variable
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
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedProject,
                        hint: Text("Please Select"),
                        isExpanded: true,
                        items: projectList.map((project) {
                          return DropdownMenuItem<String>(
                            value: project.description,
                            child: Text(project.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProject = value;
                            for (var project in projectList) {
                              if (project.description == value) {
                                _selectedProjectId = project.id;
                                print(
                                    'Selected project ID: $_selectedProjectId');
                              }
                            }
                          });
                        },
                        underline: SizedBox
                            .shrink(), // Remove the underline by setting this
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        bottomDialog();
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.25,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0054A4),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text("Create",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'pop_m',
                                color: MyColor.white_color)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (line.isEmpty)
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
                        itemCount: showlinesList.length,
                        itemBuilder: (context, index) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              showlinesList.removeAt(index);
                                            });
                                          },
                                          child: Icon(Icons.delete,
                                              color: MyColor.red_color,
                                              size: 16),
                                        ),
                                      ),
                                      Text(
                                          'Expense Category: ${showlinesList[index].tblExpenseCatname}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black)),
                                      Text('Date: ${showlinesList[index].date}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black)),
                                      Text(
                                          'Amount: ${showlinesList[index].amount}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'pop',
                                              color: Colors.black)),
                                      Text(
                                          'Currency: ${showlinesList[index].currencyname}',
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
                          _sendClaimData();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0054A4),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text("Submit",
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
          if (_isLoading) // Step 3: Conditionally render the loading widget
            Center(
              child: SpinKitWave(
                size: 50,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColor.mainAppColor,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  bool validation() {
    if (FromedateInput.text.isEmpty) {
      _showMyDialog(
          'Please Select From Date', MyColor.dialog_error_color, 'error');
      return false;
    } else if (TodateInput.text.isEmpty) {
      _showMyDialog(
          'Please Select To Date', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_businessLineId == null) {
      _showMyDialog(
          'Please Select Business Line', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedCountryId == null) {
      _showMyDialog(
          'Please Select Country', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedDepartmentId == null) {
      _showMyDialog(
          'Please Select Department', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedEntityId == null) {
      _showMyDialog(
          'Please Select Entity', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedPlantId == null) {
      _showMyDialog(
          'Please Select Facility', MyColor.dialog_error_color, 'error');
      return false;
    } else if (_selectedProjectId == null) {
      _showMyDialog(
          'Please Select Project', MyColor.dialog_error_color, 'error');
      return false;
    } else if (line.isEmpty) {
      _showMyDialog('Please Add Lines', MyColor.dialog_error_color, 'error');
      return false;
    }
    return true;
  }

  void _sendClaimData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_access_token');

    int businessLineId = _businessLineId != null
        ? int.parse(_businessLineId!)
        : 0; // or handle it appropriately
    int countryId = _selectedCountryId != null
        ? int.parse(_selectedCountryId!)
        : 0; // or handle it appropriately
    int departmentId = _selectedDepartmentId != null
        ? int.parse(_selectedDepartmentId!)
        : 0; // or handle it appropriately
    int entityId = _selectedEntityId != null
        ? int.parse(_selectedEntityId!)
        : 0; // or handle it appropriately
    int plantId = _selectedPlantId != null
        ? int.parse(_selectedPlantId!)
        : 0; // or handle it appropriately
    int projectId = _selectedProjectId != null
        ? int.parse(_selectedProjectId!)
        : 0; // or handle it appropriately

    ExpenseRequest expenseClaim = ExpenseRequest(
      fdate: FromedateInput.text.toString(),
      tdate: TodateInput.text.toString(),
      desc: description.text.toString(),
      businessLineId: businessLineId,
      countryId: countryId,
      departmentId: departmentId,
      entityId: entityId,
      plantId: plantId,
      projectId: projectId,
      lines: line,
    );
    print(expenseClaim.toJson());

    var response = await http.post(
      Uri.parse('${baseurl.url}expense-request'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(expenseClaim.toJson()),
    );
    setState(() {
      _isLoading = false; // Stop loading
    });
    print(response.statusCode);
    print(response.body);
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showMyDialog(jsonObject['message'], MyColor.new_light_green, 'success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => upcoming_dash()));
    } else if (response.statusCode == 401) {
      print("Unauthorized");
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login_Activity()));
    } else if (response.statusCode == 500) {
      print("Internal Server Error");
      _showMyDialog('Something Went Wrong', Color(0xFF861F41), 'error');
    } else if (response.statusCode == 404) {
      print("Not Found");
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else if (response.statusCode == 400) {
      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
      print("Bad Request");
    }
    if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else {
      print("Unknown Error");
    }
  }

  void bottomDialog() async {
    // Clear previous data
    media.clear();
    amount.clear();
    selectedCurrency = null;
    selectedExpenseCategory = null;
    encodeImage = "";

    // Show the bottom sheet and handle the result using .then()
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.only(top: 16.0, left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Expense",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'pop_m',
                        color: Colors.black)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: DropdownButton<String>(
                            value: selectedExpenseCategory,
                            hint: Text("Please Select"),
                            isExpanded: true,
                            items: ExpenseCategorylist.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.categoery_name,
                                child: Text(category.categoery_name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedExpenseCategory = value;
                                // Update the corresponding ID
                                _selectedExpenseCategoryId =
                                    ExpenseCategorylist.firstWhere((cat) =>
                                            cat.categoery_name == value)
                                        .id
                                        .toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0054A4)),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextField(
                            controller: FromedateInput,
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.calendar_today,
                                color: Color(0xFF0054A4),
                              ),
                              hintText: "From date",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "pop",
                                  fontSize: 14),
                            ),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'pop'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  FromedateInput.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 10),
                          Flexible(
                            child: CustomTextField(
                              controller: amount,
                              hintText: "Amount",
                              obscureText: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton<String>(
                                  value: selectedCurrency,
                                  hint: Text("Currency"),
                                  isExpanded: true,
                                  items: currencyList.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category.currency_name,
                                      child: Text(category.currency_name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCurrency = value;
                                      _slectedCurrencyId = currencyList
                                          .firstWhere((curr) =>
                                              curr.currency_name == value)
                                          .id
                                          .toString();
                                          print("id oye $_slectedCurrencyId");
                                    });
                                  },
                                ),
                                // child: Text("UAE Dirham",style: TextStyle(fontFamily: "pop_m",fontSize: 14),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Wrap(
                            children: [
                              iconTextButto('Camera', Color(0xFF0054A4),
                                  () async {
                                final images = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (images != null) {
                                  final bytes =
                                      File(images.path).readAsBytesSync();
                                  encodeImage = base64Encode(bytes);
                                  File file = File(images.path);
                                  setState(() {
                                    media.add({'type': 'images', 'file': file});
                                  });
                                }
                              },
                                  const Icon(Icons.camera_alt,
                                      color: MyColor.white_color),
                                  context),
                              iconTextButto('Gallery', Color(0xFF0054A4),
                                  () async {
                                final images = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (images != null) {
                                  final bytes =
                                      File(images.path).readAsBytesSync();
                                  encodeImage = base64Encode(bytes);
                                  File file = File(images.path);
                                  setState(() {
                                    media.add({'type': 'images', 'file': file});
                                  });
                                }
                              },
                                  const Icon(Icons.photo,
                                      color: MyColor.white_color),
                                  context),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                alignment: Alignment.center,
                                height: 120,
                                width: 120,
                                decoration:
                                    BoxDecoration(color: Colors.grey[350]),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: media.length,
                                  itemBuilder: (context, index) {
                                    return attachmentWidget(media[index]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 10, right: 10),
                        child: InkWell(
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0054A4),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'pop'),
                            ),
                          ),
                          onTap: () {
                            if (dialogValidation()) {
                              // Create a new Line object with the provided data
                              Line data = Line(
                                tblExpenseCatId:
                                    int.parse(_selectedExpenseCategoryId!),
                                date: FromedateInput.text.toString(),
                                amount: double.parse(amount.text),
                                currencyId: int.parse(_slectedCurrencyId!),
                                attachement: encodeImage,
                              );

                              // Close the dialog and return the created data
                              Navigator.pop(context,
                                  data); // Pass the data back when dialog closes
                            } else {
                              print("Please fill all fields.");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).then((result) {
      if (result != null) {
        try {
          double parsedAmount =
              double.parse(amount.text); // Ensure it's a valid number

          // If everything is valid, continue with adding the result
          setState(() {
            line.add(result); // Add the result data
            showlines array = showlines(
              tblExpenseCatname: selectedExpenseCategory!,
              date: FromedateInput.text.toString(),
              amount: parsedAmount, // Use the validated amount
              currencyname: selectedCurrency!,
              img: encodeImage,
            );
            showlinesList.add(array); // Add to showlinesList
          });

          print("Data saved successfully!");
          print("Line count: ${line.length}");
          print("Show Line count: ${showlinesList.length}");
        } catch (e) {
          print("Error: Invalid amount format");
          // Show an error or handle invalid format
        }
      } else {
        print("No data was returned from the dialog.");
      }
    });
  }

  bool dialogValidation() {
    if (selectedExpenseCategory == null) {
      Flushbar(
        message: 'Please Select Expense Category',
        backgroundColor: MyColor.dialog_error_color,
        duration: Duration(milliseconds: 1000),
      ).show(context);
      return false;
    } else if (FromedateInput.text.isEmpty) {
      Flushbar(
        message: 'Please Select Date',
        backgroundColor: MyColor.dialog_error_color,
        duration: Duration(milliseconds: 1000),
      ).show(context);
      return false;
    } else if (amount.text.isEmpty) {
      Flushbar(
        message: 'Please Enter Amount',
        backgroundColor: MyColor.dialog_error_color,
        duration: Duration(milliseconds: 1000),
      ).show(context);
      return false;
    } else if (selectedCurrency == null) {
      Flushbar(
        message: 'Please Select Currency',
        backgroundColor: MyColor.dialog_error_color,
        duration: Duration(milliseconds: 1000),
      ).show(context);
      return false;
    }
    return true;
  }

  Future<void> _showMyDialog(
      String msg, Color colorDynamic, String success) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          if (success == 'success') ...[
            const Icon(
              Icons.check,
              color: MyColor.white_color,
            ),
          ] else ...[
            const Icon(
              Icons.error,
              color: MyColor.white_color,
            ),
          ],
          const SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            msg,
            style: const TextStyle(color: MyColor.white_color),
            maxLines: 2,
          ))
        ],
      ),
      backgroundColor: colorDynamic,
      behavior: SnackBarBehavior.floating,
      elevation: 3,
    ));
  }

  void getvalue() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_access_token');
    var response =
        await http.get(Uri.parse('${baseurl.url}expense-master'), headers: {
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
      for (var i in jsonObject['expcategory']) {
        ExpenseCategory data =
            ExpenseCategory(id: i['id'], categoery_name: i['categoery_name']);
        setState(() {
          ExpenseCategorylist.add(data);
        });
      }
      for (var i in jsonObject['currency']) {
        if(i['currency_name']=="UAE Dirham"){
  currency data = currency(
          id: i['id'],
          currency_name: i['currency_name'],
          currency_code: i['currency_code'],
        );
         setState(() {
          currencyList.add(data);
        });
        }
      
       
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
    }
    if (response.statusCode == 422) {
      Navigator.of(context).pop();

      _showMyDialog(jsonObject['message'], MyColor.dialog_error_color, 'error');
    } else {
      print("Unknown Error");
    }
  }
}
