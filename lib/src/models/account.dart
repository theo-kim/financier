import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/accounttags.dart';

part 'account.g.dart';

class AccountType extends EnumClass {
  static const AccountType asset = _$asset;
  static const AccountType liability = _$liability;
  static const AccountType income = _$income;
  static const AccountType expense = _$expense;
  static const AccountType none = _$none;

  const AccountType._(String name) : super(name);

  static BuiltSet<AccountType> get values => _$values;
  static AccountType valueOf(String name) => _$valueOf(name);

  static Serializer<AccountType> get serializer => _$accountTypeSerializer;
}

abstract class AccountTransaction
    implements Built<AccountTransaction, AccountTransactionBuilder> {
  String get transaction;
  double get runningTotal;
  String get report;

  AccountTransaction._();

  factory AccountTransaction([updates(AccountTransactionBuilder b)]) =
      _$AccountTransaction;
  static Serializer<AccountTransaction> get serializer =>
      _$accountTransactionSerializer;
}

abstract class Account implements Built<Account, AccountBuilder> {
  String get name;
  String? get memo;
  double get startingBalance;
  AccountType get type;
  String? get parent;
  BuiltList<String> get children;
  BuiltList<AccountTag> get tags;
  BuiltList<AccountTransaction>? get transactions;

  String get id =>
      "${type.toString()}-${name.replaceAll(" ", "_").toLowerCase()}";

  Account._();

  factory Account([updates(AccountBuilder b)]) = _$Account;
  static Serializer<Account> get serializer => _$accountSerializer;
}
