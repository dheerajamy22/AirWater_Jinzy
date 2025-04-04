import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences{

  final String user_name = 'emp_name';

   setEmpName(String emp_name)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.user_name, emp_name);
    prefs.commit();
  }

  getEmp_Name() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_name;
    user_name = pref.getString(this.user_name);
    return user_name;
  }


}