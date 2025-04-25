class ExpenseClaimModel{
  String ReqNo;
  String requester_id;
  String EmpName;
  String AssignDate;
  String status;
  String from_date;
  String to_date;
  String total_amount;
  String description;
  String Image;
  String created_at;
  ExpenseClaimModel(
      {required this.ReqNo,
        required this.requester_id,
        required this.EmpName,
        required this.AssignDate,
        required this.status,
        required this.from_date,
        required this.to_date,
        required this.total_amount,
        required this.description,
        required this.Image,
        required this.created_at,
      });


}