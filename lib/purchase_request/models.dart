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

class categoryModel{
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
class unitsModel{
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
