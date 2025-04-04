class ListModule{

  final String status;

  ListModule({required this.status});

  factory ListModule.fromJson(Map<String, dynamic> json) {
    return ListModule(
      status: json['Status'],

    );
  }
}