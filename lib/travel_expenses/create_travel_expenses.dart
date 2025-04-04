import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo/app_color/color_constants.dart';
import 'package:demo/main_home/mainHome.dart';
import 'package:demo/travel_expenses/create_travel_api_services.dart';
import 'package:demo/travel_expenses/create_travel_model.dart';
import 'package:demo/travel_expenses/travel_expenses_model.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Create_Travel_Activty extends StatefulWidget {
  @override
  _Create_Travel_ActivtyState createState() => _Create_Travel_ActivtyState();
}

class _Create_Travel_ActivtyState extends State<Create_Travel_Activty> {
  final _leaveApiServices = CreateTravel_ApiServices();

  TextEditingController from_date_controller = TextEditingController();
  TextEditingController to_date_controller = TextEditingController();
  TextEditingController purpose_text = TextEditingController();
  TextEditingController description_text = TextEditingController();
  TextEditingController destination_text = TextEditingController();
  TextEditingController total_estimate_text = TextEditingController();
  TextEditingController advance_payment_text = TextEditingController();
  bool isEmpty_FromDate = false,
      isEmpty_ToDate = false,
      isPurposeEmpty = false,
      isDescriptionEmpty = false;

  @override
  void initState() {
    from_date_controller.text = "";
    to_date_controller.text = "";
    purpose_text.text = "";
    description_text.text = "";
    destination_text.text = "";
    total_estimate_text.text = "";
    advance_payment_text.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF0054A4),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 32.0),
                child: const Text(
                  'Travel request',
                  style: TextStyle(fontSize: 18, fontFamily: 'pop'),
                ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 8),
                          child: TextField(
                            controller: purpose_text,
                            decoration: InputDecoration(
                                labelText: 'Purpose',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          )),
                    ),
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 24),
                          child: TextField(
                            controller: destination_text,
                            decoration: InputDecoration(
                                labelText: 'Destination',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 24),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              controller: from_date_controller,
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueAccent,
                                ), //icon of text field
                                hintText: "From date",
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
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    from_date_controller.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 24),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.blueAccent)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: to_date_controller,
                              decoration: const InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueAccent,
                                ),
                                hintText: 'To date',
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
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(pickedDate);
                                  String formateDate = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  to_date_controller.text = formateDate;
                                  print(formateDate);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 8),
                          child: TextField(
                            controller: total_estimate_text,
                            decoration: InputDecoration(
                                labelText: 'Total estimate',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            keyboardType: TextInputType.number,
                          )),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 24),
                        child: TextField(
                          controller: advance_payment_text,
                          decoration: InputDecoration(
                              labelText: 'Advance payment',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
              child: Container(
                height: 52,
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(5)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Draft',
                    style: TextStyle(fontSize: 16, fontFamily: 'pop'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: TextField(
                controller: description_text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: 'Description',
                  labelText: 'Description',
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
              child: InkWell(
                child: Container(
                  height: 52,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF0054A4)),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'pop', fontSize: 16),
                  ),
                ),
                onTap: () async {
                  setState(() {
                    isEmpty_FromDate = from_date_controller.text.isEmpty;
                    isEmpty_ToDate = to_date_controller.text.isEmpty;
                    isPurposeEmpty = purpose_text.text.isEmpty;
                    isDescriptionEmpty = description_text.text.isEmpty;
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddExpensesData_AndShowList(
                                  trvel_id: '1',
                                )));*/
                    if (validation()) {
                      CallApiForSendRequest();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validation() {
    if (isPurposeEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: 'Please enter travel purpose',
        duration: const Duration(seconds: 2),
      ).show(context);
      return false;
    } else if (isEmpty_FromDate) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: 'Please select from date',
        duration: const Duration(seconds: 2),
      ).show(context);

      return false;
    } else if (isEmpty_ToDate) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: 'Please select to date',
        duration: const Duration(seconds: 2),
      ).show(context);
      return false;
    } else if (description_text.text == '') {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: 'Please enter description',
        duration: const Duration(seconds: 2),
      ).show(context);
      return false;
    }
    return true;
  }

  void CallApiForSendRequest() async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    await progressDialog.show();
    SharedPreferences getPref = await SharedPreferences.getInstance();
    String? user_id = getPref.getString('user_id');
    CreateTravel_Model travel_model = await _leaveApiServices.sendTravelRequest(
        purpose_text.text,
        destination_text.text,
        from_date_controller.text,
        to_date_controller.text,
        total_estimate_text.text,
        advance_payment_text.text,
        description_text.text,
        'Draft',
        '${user_id}');

    if (travel_model.Status == '1') {
      progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpensesData_AndShowList(
                  trvel_id: travel_model.trav_req_id,
                  purpose: purpose_text.text,
                  destination: destination_text.text,
                  from_date: from_date_controller.text,
                  to_date: to_date_controller.text,
                  total_estimate: total_estimate_text.text,
                  advance_payment: advance_payment_text.text,
                  travel_descrip: description_text.text)));
    } else {
      progressDialog.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(travel_model.Message)));
    }
  }
}

class AddExpensesData_AndShowList extends StatefulWidget {
  final String trvel_id,
      purpose,
      destination,
      from_date,
      to_date,
      total_estimate,
      advance_payment,
      travel_descrip;

  const AddExpensesData_AndShowList({
    Key? key,
    required this.trvel_id,
    required this.purpose,
    required this.destination,
    required this.from_date,
    required this.to_date,
    required this.total_estimate,
    required this.advance_payment,
    required this.travel_descrip,
  }) : super(key: key);

  @override
  _AddExpensesData_AndShowListState createState() =>
      _AddExpensesData_AndShowListState();
}

class _AddExpensesData_AndShowListState
    extends State<AddExpensesData_AndShowList> {
  final _travel_ApiServices = CreateTravel_ApiServices();
  ScrollController? scrollController;
  List<Map<String, dynamic>> media = [];
  String encodeImage = '';
  FilePickerResult? result;
  String? filename;
  PlatformFile? pickedfile;
  File? filetodisplay;

  String statusValue = 'Draft';
  var statusItem = ['Draft', 'Submitted'];
  bool statusCheck = false;
  String expense_type = '';
  var expenses_item = ['Petrol', 'Business'];
  TextEditingController amount_dialog_edit = TextEditingController();
  TextEditingController select_date_dilog = TextEditingController();
  TextEditingController estimate_amount_dialog = TextEditingController();
  TextEditingController currency_type = TextEditingController();
  TextEditingController exchange_rate = TextEditingController();
  bool amountIsEmpty = false, date_is_empty = false, dropDown_isEmpty = false;


  List<ExpensesModel> expenseLineData = [];

  Future<List<ExpensesModel>> sendExpesesLineRequest() async {
    expenseLineData.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user_id = sharedPreferences.getString('user_id');
    var response = await http.post(
        Uri.parse(
            'https://hrm.amysoftech.com/MDDAPI/Mobapp_API?action=EMP_TRAVEL_EXPENSES_LINES_REQUEST'),
        body: {
          'emp_userid': user_id,
          'expense_trav_req_id': widget.trvel_id,
          'expense_exp_cate_id': '1',
          'expense_amount': amount_dialog_edit.text,
          'expense_estdate': select_date_dilog.text,
          'expenses_estamt': estimate_amount_dialog.text,
          'expense_currency': currency_type.text,
          'expense_exrate': exchange_rate.text,
          'expense_docs': encodeImage
        });

    if (response == 200) {
      print(response.body);
    }

    var jsonObject = json.decode(response.body);
    String status = jsonObject['Status'];
    String msg = jsonObject['Message'];
    var jsonArray = jsonObject['ExpensesList'];
    if (status == '1') {
      print('hb ' + response.body);
      Flushbar(
        message: msg,
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      ).show(context);
      for (var expensesData in jsonArray) {
        ExpensesModel model = ExpensesModel(
            expense_amount: expensesData['expense_amount'],
            expense_currency: expensesData['expense_currency'],
            expense_estdate: expensesData['expense_estdate'],
            expense_estamt: expensesData['expense_estamt'],
            expense_exrate: expensesData['expense_exrate'],
            expense_exp_cate_name: expensesData['expense_exp_cate_name']);

        setState(() {
          expenseLineData.add(model);
        });

        print('list data ss' + expenseLineData[0].expense_amount);
      }
    } else {
      Flushbar(
        message: msg,
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      ).show(context);
    }

    return expenseLineData;
  }

  @override
  void initState() {
    amount_dialog_edit.text = "";
    select_date_dilog.text = "";
    estimate_amount_dialog.text = "";
    currency_type.text = "";
    exchange_rate.text = "";
    //sendExpesesLineRequest();
    super.initState();
  }

  void CallApiForSendRequest(String status) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    await progressDialog.show();
    SharedPreferences getPref = await SharedPreferences.getInstance();
    String? user_id = getPref.getString('user_id');
    CreateTravel_Model travel_model =
        await _travel_ApiServices.sendTravelRequest(
            widget.purpose,
            widget.destination,
            widget.from_date,
            widget.to_date,
            widget.total_estimate,
            widget.advance_payment,
            widget.travel_descrip,
            status,
            '${user_id}');

    if (travel_model.Status == '1') {
      progressDialog.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainHome()));
    } else {
      progressDialog.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(travel_model.Message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("travel id " + widget.trvel_id);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expenses lines',
          style: TextStyle(fontSize: 16, fontFamily: 'pop'),
        ),
        backgroundColor: MyColor.mainAppColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: statusCheck,
                  child: InkWell(
                    child: Container(
                      width: 165,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFF0054A4)),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'pop',
                            color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      if (statusValue == 'Submitted') {
                        CallApiForSendRequest(statusValue);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Please select status draft to submitted')));
                      }
                    },
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 165,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFFD59F0F)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/add_icon.png',
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'pop',
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // addExpnsesDilog();
                    bottomDialog();
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.blueAccent)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                  // underline: Container(),
                  hint: const Text('Draft'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  isDense: true,
                  isExpanded: true,
                  alignment: Alignment.centerLeft,
                  items: statusItem.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      statusValue = newValue!;
                      if (statusValue == 'Submitted') {
                        statusCheck = true;
                      } else {
                        statusCheck = false;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: expenseLineData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Expense category",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_exp_cate_name
                                            .toString()),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text(
                                          "Currency",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_currency
                                            .toString()),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Estimated date",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_estdate
                                            .toString()),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text(
                                          "Exchange rate",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_exrate
                                            .toString()),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Amount",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_amount
                                            .toString()),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: Text(
                                          "Estimated amount",
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(expenseLineData[index]
                                            .expense_estamt
                                            .toString()),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  }))
        ],
      ),
    );
  }

  void bottomDialog() async {
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
                        padding: const EdgeInsets.only(top: 24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: currency_type,
                                    decoration: InputDecoration(
                                        isCollapsed: true,
                                        filled: true,
                                        labelText: 'Currency',
                                        hintText: "Currency",
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'pop')),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: estimate_amount_dialog,
                                    decoration: InputDecoration(
                                        isCollapsed: true,
                                        filled: true,
                                        labelText: 'Estimate Amount',
                                        hintText: "Estimate Amount",
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'pop')),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: amount_dialog_edit,
                                      decoration: InputDecoration(
                                          isCollapsed: true,
                                          filled: true,
                                          labelText: 'Amount',
                                          hintText: "Amount",
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontFamily: 'pop')),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: exchange_rate,
                                      decoration: InputDecoration(
                                          isCollapsed: true,
                                          filled: true,
                                          labelText: 'Exchange rate',
                                          hintText: "Exchange rate",
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontFamily: 'pop')),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      child: Container(
                                    height: 52,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueAccent),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10, right: 10),
                                      child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              border: InputBorder.none),
                                          // underline: Container(),
                                          hint: const Text('Expenses type'),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          isDense: true,
                                          isExpanded: true,
                                          alignment: Alignment.centerLeft,
                                          items:
                                              expenses_item.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(items));
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              expense_type = value!;
                                            });
                                          }),
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      height: 52,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: TextField(
                                          controller: select_date_dilog,
                                          decoration: const InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            hintText: 'Select Date',
                                            icon: Icon(
                                              Icons.calendar_today,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? pickeddate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100));

                                            if (pickeddate != null) {
                                              print(pickeddate);
                                              String formateDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickeddate);

                                              setState(() {
                                                select_date_dilog.text =
                                                    formateDate;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Wrap(
                                  children: [
                                    iconTextButto('Camera', Colors.orange,
                                        () async {
                                      media.clear();
                                      final images = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.camera);

                                      if (images != null) {
                                        //   for (var i = 0; i < images.length; i++) {
                                        final bytes =
                                            File(images.path).readAsBytesSync();

                                        encodeImage = base64Encode(bytes);
                                        print("Base64  " + encodeImage);
                                        File file = File(images.path);
                                        setState(() {
                                          media.add({
                                            'type': 'images',
                                            'file': file,
                                          });
                                        });
                                      }
                                    }, const Icon(Icons.camera_alt), context),
                                    // SizedBox(width: 40,),
                                    iconTextButto('Gallery', Colors.orange,
                                        () async {
                                      media.clear();
                                      final images = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);

                                      if (images != null) {
                                        final bytes =
                                            File(images.path).readAsBytesSync();

                                        encodeImage = base64Encode(bytes);
                                        print("Base64  gellary " + encodeImage);
                                        //   for (var i = 0; i < images.length; i++) {
                                        File file = File(images.path);

                                        setState(() {
                                          media.add({
                                            'type': 'images',
                                            'file': file,
                                          });
                                        });
                                        //  }
                                      }
                                    }, const Icon(Icons.photo), context),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[350]),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: media.length,
                                          itemBuilder: (context, index) {
                                            return attachmentWidget(
                                                media[index]);
                                          }),
                                    ),
                                  ),
                                ),
                                //SizedBox(height: 20,),
                              ],
                            ),
                            /* Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD59F0F),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/add_icon.png',
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'pop',
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Container(
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      fit: BoxFit.fill,
                                      width: 160,
                                      height: 150,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),*/
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 10, right: 10),
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
                                    setState(() {
                                      amountIsEmpty =
                                          amount_dialog_edit.text.isEmpty;
                                      date_is_empty =
                                          select_date_dilog.text.isEmpty;
                                      dropDown_isEmpty = expense_type.isEmpty;
                                      if (dialogValidation()) {
                                        sendExpesesLineRequest();
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  bool dialogValidation() {
    if (amount_dialog_edit.text == '') {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: "Please enter amount",
        duration: const Duration(seconds: 2),
      ).show(context);

      return false;
    } else if (expense_type == '') {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: "Please select catagory",
        duration: const Duration(seconds: 2),
      ).show(context);
      return false;
    } else if (select_date_dilog.text == '') {
      Flushbar(
        message: "Please select date",
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      ).show(context);
      return false;
    }
    /*else if (media.length == 0) {
      Flushbar(
        message: "Please select image",
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: Duration(seconds: 2),
      )..show(context);

      return false;
    }*/

    return true;
  }
}

Widget iconTextButto(String name, Color colo, Function function, Icon icon,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 0.2,
      // margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            child: icon,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colo,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(name),
        ],
      ),
    ),
  );
}

Widget attachmentWidget(Map<String, dynamic> attachFile) {
  return Container(
    child: Column(
      children: [
        Image.file(
          attachFile['file'],
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      ],
    ),
  );
}

Widget expense_line_featch(ExpensesModel expensesModel) {
  return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'expensesModel',
                    textAlign: TextAlign.end,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Apply date",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('gh'),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "From date",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('79'),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "To date",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('89'),
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 90, right: 90, bottom: 8),
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '898',
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
        )
      ],
    ),
  );
}
