class leavelistdetails {
  final String from_date;
  final String to_date;
  final String no_of_days;
  final String employee_name;
  final String leave_code;
  final String ref_no;
  final String created_on;
  final String lr_id;
  final String reason;
  final String requesting_type;
  final String leave_planned;
  final String lr_status;

  leavelistdetails(
      {required this.ref_no,
      required this.leave_code,
      required this.from_date,
      required this.to_date,
      required this.no_of_days,
      required this.employee_name,
      required this.created_on,
      required this.lr_status,
      required this.leave_planned,
      required this.lr_id,
      required this.reason,
      required this.requesting_type});
}
