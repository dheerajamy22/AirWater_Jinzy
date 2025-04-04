class Workflow {
  // final String wtxn_id;
  final String wtxn_code;
  final String wtxn_requester_emp_name;
  final String wtxn_request_datetime;
  final String ccl_type;
  final String ccl_inout_ip;
  final String checkio_reason;
  final String wtxn_ref_request_no;
  final String emp_photo;

  Workflow(
      {
        // required this.wtxn_id,
      required this.wtxn_code,
      required this.wtxn_requester_emp_name,
      required this.wtxn_request_datetime,
      required this.ccl_type,
      required this.ccl_inout_ip,
      required this.checkio_reason,
      required this.wtxn_ref_request_no,
      required this.emp_photo,
      });
}
