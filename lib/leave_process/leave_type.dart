class LeaveTypeModule{
 final String lc_id;
 final String lc_name;
 final String balance;
 final String halfdayallowed;

 LeaveTypeModule({required this.lc_id, required this.lc_name,required this.balance,required this.halfdayallowed});

 factory LeaveTypeModule.fromJson(Map<String, dynamic> json) {
  return LeaveTypeModule(
   lc_id: json['lc_id'],
   lc_name: json['lc_name'],
   balance: json['balance'],
   halfdayallowed: json['halfdayallowed'],
  );
 }

}