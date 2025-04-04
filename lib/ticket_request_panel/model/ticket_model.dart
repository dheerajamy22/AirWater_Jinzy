class TicketModel {
  final String rfticket_code;
  final String rfticket_adddate;
  final String rfticket_startdate;
  final String rfticket_enddate;
  final String rfticket_travel_mode;
  final String rfticket_status;
  final String rfticket_from_country;
  final String rfticket_to_country;

  TicketModel(
      {required this.rfticket_code,
      required this.rfticket_adddate,
      required this.rfticket_startdate,
      required this.rfticket_enddate,
      required this.rfticket_travel_mode,
      required this.rfticket_status,
      required this.rfticket_from_country,
      required this.rfticket_to_country});
}
