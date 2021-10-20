// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounttags.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountTag _$credit_card = const AccountTag._('credit_card');
const AccountTag _$mortgage = const AccountTag._('mortgage');
const AccountTag _$loan = const AccountTag._('loan');
const AccountTag _$line_of_credit = const AccountTag._('line_of_credit');
const AccountTag _$accounts_payable = const AccountTag._('accounts_payable');
const AccountTag _$back_account = const AccountTag._('bank_account');
const AccountTag _$bonds = const AccountTag._('bonds');
const AccountTag _$investments = const AccountTag._('investments');
const AccountTag _$inventory = const AccountTag._('inventory');
const AccountTag _$equity = const AccountTag._('equity');
const AccountTag _$cash = const AccountTag._('cash');
const AccountTag _$accounts_receivable =
    const AccountTag._('accounts_receivable');
const AccountTag _$interest_earned = const AccountTag._('interest_earned');
const AccountTag _$capital_gains = const AccountTag._('capital_gains');
const AccountTag _$appreciation = const AccountTag._('appreciation');
const AccountTag _$taxable_income = const AccountTag._('taxable_income');
const AccountTag _$nontaxable_income = const AccountTag._('nontaxable_income');
const AccountTag _$interest_paid = const AccountTag._('interest_paid');
const AccountTag _$living_expense = const AccountTag._('living_expense');
const AccountTag _$tax_deductable = const AccountTag._('tax_deductable');
const AccountTag _$recurring = const AccountTag._('recurring');
const AccountTag _$rent = const AccountTag._('rent');
const AccountTag _$depreciation = const AccountTag._('depreciation');
const AccountTag _$insurance_premium = const AccountTag._('insurance_premium');
const AccountTag _$taxes = const AccountTag._('taxes');
const AccountTag _$vehicle_expense = const AccountTag._('vehicle_expenses');

AccountTag _$valueOf(String name) {
  switch (name) {
    case 'credit_card':
      return _$credit_card;
    case 'mortgage':
      return _$mortgage;
    case 'loan':
      return _$loan;
    case 'line_of_credit':
      return _$line_of_credit;
    case 'accounts_payable':
      return _$accounts_payable;
    case 'bank_account':
      return _$back_account;
    case 'bonds':
      return _$bonds;
    case 'investments':
      return _$investments;
    case 'inventory':
      return _$inventory;
    case 'equity':
      return _$equity;
    case 'cash':
      return _$cash;
    case 'accounts_receivable':
      return _$accounts_receivable;
    case 'interest_earned':
      return _$interest_earned;
    case 'capital_gains':
      return _$capital_gains;
    case 'appreciation':
      return _$appreciation;
    case 'taxable_income':
      return _$taxable_income;
    case 'nontaxable_income':
      return _$nontaxable_income;
    case 'interest_paid':
      return _$interest_paid;
    case 'living_expense':
      return _$living_expense;
    case 'tax_deductable':
      return _$tax_deductable;
    case 'recurring':
      return _$recurring;
    case 'rent':
      return _$rent;
    case 'depreciation':
      return _$depreciation;
    case 'insurance_premium':
      return _$insurance_premium;
    case 'taxes':
      return _$taxes;
    case 'vehicle_expenses':
      return _$vehicle_expense;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AccountTag> _$values =
    new BuiltSet<AccountTag>(const <AccountTag>[
  _$credit_card,
  _$mortgage,
  _$loan,
  _$line_of_credit,
  _$accounts_payable,
  _$back_account,
  _$bonds,
  _$investments,
  _$inventory,
  _$equity,
  _$cash,
  _$accounts_receivable,
  _$interest_earned,
  _$capital_gains,
  _$appreciation,
  _$taxable_income,
  _$nontaxable_income,
  _$interest_paid,
  _$living_expense,
  _$tax_deductable,
  _$recurring,
  _$rent,
  _$depreciation,
  _$insurance_premium,
  _$taxes,
  _$vehicle_expense,
]);

Serializer<AccountTag> _$accountTagSerializer = new _$AccountTagSerializer();

class _$AccountTagSerializer implements PrimitiveSerializer<AccountTag> {
  @override
  final Iterable<Type> types = const <Type>[AccountTag];
  @override
  final String wireName = 'AccountTag';

  @override
  Object serialize(Serializers serializers, AccountTag object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  AccountTag deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountTag.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
