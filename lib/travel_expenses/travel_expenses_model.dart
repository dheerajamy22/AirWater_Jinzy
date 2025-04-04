class ExpensesModel {

  final String expense_amount;
  final String expense_currency;
  final String expense_estdate;
  final String expense_estamt;
  final String expense_exrate;
  final String expense_exp_cate_name;

  ExpensesModel(
      {
      required this.expense_amount,
      required this.expense_currency,
      required this.expense_estdate,
      required this.expense_estamt,
      required this.expense_exrate,
      required this.expense_exp_cate_name});
}
