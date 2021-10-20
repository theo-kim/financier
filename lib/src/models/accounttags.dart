import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accounttags.g.dart';

class AccountTag extends EnumClass {
  const AccountTag._(String name) : super(name);

  static const AccountTag credit_card = _$credit_card;
  static const AccountTag mortgage = _$mortgage;
  static const AccountTag loan = _$loan;
  static const AccountTag line_of_credit = _$line_of_credit;
  static const AccountTag accounts_payable = _$accounts_payable;

  static const AccountTag bank_account = _$back_account;
  static const AccountTag bonds = _$bonds;
  static const AccountTag investments = _$investments;
  static const AccountTag inventory = _$inventory;
  static const AccountTag equity = _$equity;
  static const AccountTag cash = _$cash;
  static const AccountTag accounts_receivable = _$accounts_receivable;

  static const AccountTag interest_earned = _$interest_earned;
  static const AccountTag capital_gains = _$capital_gains;
  static const AccountTag appreciation = _$appreciation;
  static const AccountTag taxable_income = _$taxable_income;
  static const AccountTag nontaxable_income = _$nontaxable_income;

  static const AccountTag interest_paid = _$interest_paid;
  static const AccountTag living_expense = _$living_expense;
  static const AccountTag tax_deductable = _$tax_deductable;
  static const AccountTag recurring = _$recurring;
  static const AccountTag rent = _$rent;
  static const AccountTag depreciation = _$depreciation;
  static const AccountTag insurance_premium = _$insurance_premium;
  static const AccountTag taxes = _$taxes;
  static const AccountTag vehicle_expenses = _$vehicle_expense;

  static BuiltSet<AccountTag> get values => _$values;
  static AccountTag valueOf(String name) => _$valueOf(name);
  static Serializer<AccountTag> get serializer => _$accountTagSerializer;
}
