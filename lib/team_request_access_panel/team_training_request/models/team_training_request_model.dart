class TeamTraining_RequestModel{

 final  String wtxn_id;
 final String wtxn_requester_empid;
 final String rft_requester_name;
 final String wtxn_request_date;
 final String wtxn_profile_url;
 final String wtxn_status;
 final String rft_tm_name;
 final String rft_training_outcome;
 final String rft_startdate;
 final String rft_enddate;
 final String rft_criteria_applied_skill;
 final String rft_tm_fee;

 TeamTraining_RequestModel({
  required this.wtxn_id,
  required this.wtxn_requester_empid,
  required this.rft_requester_name,
  required this.wtxn_request_date,
  required this.wtxn_profile_url,
  required this.wtxn_status,
  required this.rft_tm_name,
  required this.rft_training_outcome,
  required this.rft_startdate,
  required this.rft_enddate,
  required this.rft_criteria_applied_skill,
  required this.rft_tm_fee
});
}