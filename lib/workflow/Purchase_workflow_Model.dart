class PurchaseRequestWorkFlowModel{

  String ReqNo;
  String requester_id;
  String EmpName;
  String AssignDate;
  String status;
  String total_amount;
  String title;
  String Image;
  String created_at;

  PurchaseRequestWorkFlowModel(
  {required this.ReqNo,
  required this.requester_id,
  required this.EmpName,
  required this.AssignDate,
  required this.status,
  required this.total_amount,
  required this.title,
  required this.Image,
  required this.created_at,
  });


}