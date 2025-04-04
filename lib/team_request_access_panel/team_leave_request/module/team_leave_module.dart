class TeamLeave_Module {
  final String wtxn_status;
  final String lr_requester;
  final String lr_from_date;
  final String lr_to_date;
  final String lr_leave_details;
  final String lr_leave_type;
  final String lr_datetime;
  final String wtxn_profile_url;
  final String wtxn_requester_empid;
  final String wtxn_id;
  final String wtxn_comments;

  TeamLeave_Module(
      {required this.wtxn_status,
      required this.lr_requester,
      required this.lr_from_date,
      required this.lr_to_date,
      required this.lr_leave_details,
      required this.lr_leave_type,
      required this.lr_datetime,
      required this.wtxn_profile_url,
      required this.wtxn_requester_empid,
      required this.wtxn_id,
      required this.wtxn_comments});
}
