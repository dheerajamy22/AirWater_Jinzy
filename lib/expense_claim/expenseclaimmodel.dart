class ExpenseRequest {
  String fdate;
  String tdate;
  int businessLineId;
  int countryId;
  int departmentId;
  int entityId;
  int plantId;
  int projectId;
  String desc;
  List<Line> lines;

  ExpenseRequest({
    required this.fdate,
    required this.tdate,
    required this.businessLineId,
    required this.countryId,
    required this.departmentId,
    required this.entityId,
    required this.plantId,
    required this.projectId,
    required this.desc,
    required this.lines,
  });

  // Factory method to create an instance from JSON
  factory ExpenseRequest.fromJson(Map<String, dynamic> json) {
    var linesFromJson = json['Lines'] as List;
    List<Line> linesList = linesFromJson.map((line) => Line.fromJson(line)).toList();

    return ExpenseRequest(
      fdate: json['fdate'],
      tdate: json['tdate'],
      businessLineId: json['business_line_id'],
      countryId: json['country_id'],
      departmentId: json['department_id'],
      entityId: json['entity_id'],
      plantId: json['plant_id'],
      projectId: json['project_id'],
      desc: json['desc'],
      lines: linesList,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fdate': fdate,
      'tdate': tdate,
      'business_line_id': businessLineId,
      'country_id': countryId,
      'department_id': departmentId,
      'entity_id': entityId,
      'plant_id': plantId,
      'project_id': projectId,
      'desc': desc,
      'Lines': lines.map((line) => line.toJson()).toList(),
    };
  }
}

class Line {
  int tblExpenseCatId;
  String date;
  double amount;
  int currencyId;
  String attachement;

  Line({
    required this.tblExpenseCatId,
    required this.date,
    required this.amount,
    required this.currencyId,
    required this.attachement,
  });

  // Factory method to create an instance from JSON
  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      tblExpenseCatId: json['tbl_expense_cat_id'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      currencyId: json['currency_id'],
      attachement: json['attachement'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'tbl_expense_cat_id': tblExpenseCatId,
      'date': date,
      'amount': amount,
      'currency_id': currencyId,
      'attachement': attachement,
    };
  }
}

class ExpenseCategory{
  final String categoery_name;
  final int id;
  ExpenseCategory({
    required this.categoery_name,
    required this.id,
  });
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      categoery_name: json['categoery_name'],
      id: json['id'],
    );
  }
}
class showlines{
   String tblExpenseCatname;
  String date;
  double amount;
  String currencyname;
  String img;
showlines({
    required this.tblExpenseCatname,
    required this.date,
    required this.amount,
    required this.currencyname,
    required this.img,
  });
  
}
class currency{
  int id;
  String currency_name;
  String currency_code;
  currency({
    required this.id,
    required this.currency_name,
    required this.currency_code,
  });
}