class Trip_Requested_ListModel {
  final String rfbt_code;
  final String rfbt_transdate;
  final String rfbt_startdate;
  final String rfbt_enddate;
  final String rfbt_desti_type;
  final String rfbt_travelwith;
  final String rfbt_ticket_level;
  final String rfbt_status;

  Trip_Requested_ListModel(
      {required this.rfbt_code,
      required this.rfbt_transdate,
      required this.rfbt_startdate,
      required this.rfbt_enddate,
      required this.rfbt_desti_type,
      required this.rfbt_travelwith,
      required this.rfbt_ticket_level,
      required this.rfbt_status});
}
