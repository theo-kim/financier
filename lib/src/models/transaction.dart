import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pincher/src/models/timestamp.dart';

part 'transaction.g.dart';

class TransactionType extends EnumClass {
  static const TransactionType credit_card_charge = _$credit_card_charge;
  static const TransactionType check = _$check;
  static const TransactionType transfer = _$transfer;
  static const TransactionType deposit = _$deposit;
  static const TransactionType payment = _$payment;
  static const TransactionType none = _$none;

  const TransactionType._(String name) : super(name);

  static BuiltSet<TransactionType> get values => _$values;
  static TransactionType valueOf(String name) => _$valueOf(name);

  static Serializer<TransactionType> get serializer =>
      _$transactionTypeSerializer;
}

abstract class Transaction implements Built<Transaction, TransactionBuilder> {
  BuiltTimestamp get date;
  String get payer;
  BuiltList<TransactionSplit> get splits;
  String get id;
  TransactionType get type;

  Transaction._();

  factory Transaction([updates(TransactionBuilder b)]) = _$Transaction;
  static Serializer<Transaction> get serializer => _$transactionSerializer;
}

class TransactionSplitType extends EnumClass {
  static const TransactionSplitType debit = _$debit;
  static const TransactionSplitType credit = _$credit;

  const TransactionSplitType._(String name) : super(name);

  static BuiltSet<TransactionSplitType> get values => _$valuesSplit;
  static TransactionSplitType valueOf(String name) => _$valueOfSplit(name);

  static Serializer<TransactionSplitType> get serializer =>
      _$transactionSplitTypeSerializer;
}

abstract class TransactionSplit
    implements Built<TransactionSplit, TransactionSplitBuilder> {
  double get amount;
  String get account;
  String? get details;
  TransactionSplitType get type;

  TransactionSplit._();

  factory TransactionSplit([updates(TransactionSplitBuilder b)]) =
      _$TransactionSplit;
  static Serializer<TransactionSplit> get serializer =>
      _$transactionSplitSerializer;
}
