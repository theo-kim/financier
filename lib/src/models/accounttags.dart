import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/account.dart';

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

  static List<String> get readable => AccountTag.values
      .toList()
      .map<String>((t) => t.toString().replaceAll("_", " "))
      .toList();

  static List<AccountTag> get liability => [
        credit_card,
        mortgage,
        loan,
        line_of_credit,
        accounts_payable,
      ];

  static List<AccountTag> get asset => [
        bank_account,
        bonds,
        investments,
        inventory,
        equity,
        cash,
        accounts_receivable,
      ];

  static List<AccountTag> get income => [
        interest_earned,
        capital_gains,
        appreciation,
        taxable_income,
        nontaxable_income,
      ];

  static List<AccountTag> get expense => [
        interest_paid,
        living_expense,
        tax_deductable,
        recurring,
        rent,
        depreciation,
        insurance_premium,
        taxes,
        vehicle_expenses,
      ];

  static List<AccountTag> valuesByType(AccountType? type) {
    if (type == AccountType.liability) return liability;
    if (type == AccountType.asset) return asset;
    if (type == AccountType.income) return income;
    if (type == AccountType.expense)
      return expense;
    else
      return [];
  }
}
