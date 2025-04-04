class leave_workflow {
  final String ReqNo;
  final String EmpId;
  final String requester_id;
  final String EmpCode;
  final String EmpName;
  final String AssignDate;
  final String Type;
  final String Image;
  final String lr_ref_no;
  final String tbl_leavecode_id;
  final String lr_from_date;
  final String lr_to_date;
  final String lr_total_days;
  final String tbl_employee_id;
  final String req_type;
  final String created_at;
  final String lr_status;
  final String lr_reason;
  final String leave_type;
  final String lr_leave_planed;
  leave_workflow(
      {required this.ReqNo,
      required this.AssignDate,
      required this.EmpCode,
      required this.EmpId,
      required this.EmpName,
      required this.Image,
      required this.Type,
      required this.created_at,
      required this.lr_from_date,
      required this.lr_ref_no,
      required this.lr_status,
      required this.lr_to_date,
      required this.lr_total_days,
      required this.req_type,
      required this.requester_id,
      required this.tbl_employee_id,
      required this.tbl_leavecode_id,
      required this.lr_reason,
      required this.leave_type,
      required this.lr_leave_planed,
      });
}
