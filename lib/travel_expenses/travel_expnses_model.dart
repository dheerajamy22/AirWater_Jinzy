class Travel_Exp_Model {
  final String trav_req_code;
  final String trav_req_purpose;
  final String trav_req_destination;
  final String trav_req_startdate;
  final String trav_req_enddate;
  final String trav_req_status;
  final String trav_req_requester_name;
  final String trav_req_estimate;

  Travel_Exp_Model(
      {required this.trav_req_code,
      required this.trav_req_purpose,
      required this.trav_req_destination,
      required this.trav_req_startdate,
      required this.trav_req_enddate,
      required this.trav_req_status,
      required this.trav_req_requester_name,
      required this.trav_req_estimate});
}
