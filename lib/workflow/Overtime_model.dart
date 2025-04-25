class OvertimeModel {
  String ReqNo;
  String requester_id;
  String EmpName;
  String AssignDate;
  String status;
  String overtime_date;
  String from_time;
  String to_time;
  String total_time;
  String overtime_explanation;
  String Image;
  String created_at;

  OvertimeModel(
      {required this.ReqNo,
      required this.requester_id,
      required this.EmpName,
      required this.AssignDate,
      required this.status,
      required this.overtime_date,
      required this.from_time,
      required this.to_time,
      required this.total_time,
      required this.overtime_explanation,
      required this.Image,
      required this.created_at,
      });
}
