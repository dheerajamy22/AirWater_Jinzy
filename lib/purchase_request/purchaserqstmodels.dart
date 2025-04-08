class projectModel {
  final String id;
  final String name;
  final String code;
  final String description;
  projectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });
  factory projectModel.fromJson(Map<String, dynamic> json) {
    return projectModel(
      id: json['id'].toString(),
      name: json['name'],
      code: json['code'],
      description: json['description'],
    );
  }
}

class departmentModel {
  final String id;
  final String dept_name;
  final String dept_code;

  departmentModel({
    required this.id,
    required this.dept_name,
    required this.dept_code,
  });
  factory departmentModel.fromJson(Map<String, dynamic> json) {
    return departmentModel(
      id: json['id'].toString(),
      dept_name: json['dept_name'],
      dept_code: json['dept_code'],
    );
  }
}

class businesslineModel {
  final String id;
  final String name;
  final String code;
  final String description;
  businesslineModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });
  factory businesslineModel.fromJson(Map<String, dynamic> json) {
    return businesslineModel(
      id: json['id'].toString(),
      name: json['name'],
      code: json['code'],
      description: json['description'],
    );
  }
}

class countryModel {
  final String id;
  final String dynamics_code;

  countryModel({
    required this.id,
    required this.dynamics_code,
  });
}

class entityModel {
  final String id;
  final String name;
  final String code;
  final String description;
  entityModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });
  factory entityModel.fromJson(Map<String, dynamic> json) {
    return entityModel(
      id: json['id'].toString(),
      name: json['name'],
      code: json['code'],
      description: json['description'],
    );
  }
}

class plantModel {
  final String id;
  final String name;
  final String code;
  final String description;
  plantModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });
  factory plantModel.fromJson(Map<String, dynamic> json) {
    return plantModel(
      id: json['id'].toString(),
      name: json['name'],
      code: json['code'],
      description: json['description'],
    );
  }
}

class categoryModel {
  final String id;
  final String name;

  categoryModel({
    required this.id,
    required this.name,
  });
  factory categoryModel.fromJson(Map<String, dynamic> json) {
    return categoryModel(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class unitsModel {
  final String id;
  final String name;

  unitsModel({
    required this.id,
    required this.name,
  });
  factory unitsModel.fromJson(Map<String, dynamic> json) {
    return unitsModel(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}


class addItemModel {
  String itemCode;
  String itemName;
  String category;
  String unit;
  String estimatePrice;
  double quantity;
  double price;

  addItemModel({
    required this.itemCode,
    required this.itemName,
    required this.category,
    required this.unit,
    required this.estimatePrice,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'item_name': itemName,
      'category': category,
      'unit': unit,
      'estimatePrice': estimatePrice,
      'quantity': quantity,
      'price': price,
    };
  }
}

class PurchaseRequest {
  String name;
  String requestedDate;
  int businessLineId;
  int countryId;
  int departmentId;
  int entityId;
  int plantId;
  int projectId;
  List<addItemModel> lines;

  PurchaseRequest({
    required this.name,
    required this.requestedDate,
    required this.businessLineId,
    required this.countryId,
    required this.departmentId,
    required this.entityId,
    required this.plantId,
    required this.projectId,
    required this.lines,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'requested_date': requestedDate,
      'business_line_id': businessLineId,
      'country_id': countryId,
      'department_id': departmentId,
      'entity_id': entityId,
      'plant_id': plantId,
      'project_id': projectId,
      'Lines': lines.map((line) => line.toJson()).toList(),
    };
  }
}

class serachItemModel{
  final int id;
  final String name;
  final String code;
  final String unit;
  final String itemgroup;
  final String category;
  serachItemModel({
    required this.id,
    required this.name,
    required this.code,
    required this.unit,
    required this.itemgroup,
    required this.category,
  });
  factory serachItemModel.fromJson(Map<String, dynamic> json) {
    return serachItemModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      unit: json['unit'],
      itemgroup: json['itemgroup'],
      category: json['category'],
    );
  }
}
