class Team_Trip_RequestModel {
  final String wtxn_id;
  final String wtxn_status;
  final String wtxn_requester_empid;
  final String wtxn_profile_url;
  final String wtxn_request_date;
  final String rfbt_startdate;
  final String rfbt_enddate;
  final String rfbt_desti_type;
  final String rfbt_accomodation;
  final String rfbt_meal;
  final String rfbt_travelwith;
  final String rfbt_ticket_level;
  final String wtxn_request_type;
  final String rfbt_requester_name;

  Team_Trip_RequestModel(
      {required this.wtxn_id,
      required this.wtxn_status,
      required this.wtxn_requester_empid,
      required this.wtxn_profile_url,
      required this.wtxn_request_date,
      required this.rfbt_startdate,
      required this.rfbt_enddate,
      required this.rfbt_desti_type,
      required this.rfbt_accomodation,
      required this.rfbt_meal,
      required this.rfbt_travelwith,
      required this.rfbt_ticket_level,
      required this.wtxn_request_type,
      required this.rfbt_requester_name});
}
