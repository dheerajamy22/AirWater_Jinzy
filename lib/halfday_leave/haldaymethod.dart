class haldaylist {
  final String requesting_type;
  final String employee_name;
  final String date;
  final String type;
  final String reason;
  final String lr_id;
  final String lr_status;
  final String leave_code;

  haldaylist(
      {required this.requesting_type,
      required this.employee_name,
      required this.date,
      required this.type,
      required this.reason,
      required this.lr_id,
      required this.lr_status,
      required this.leave_code});
}
