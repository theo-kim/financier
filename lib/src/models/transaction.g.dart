// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TransactionType _$credit_card_charge =
    const TransactionType._('credit_card_charge');
const TransactionType _$check = const TransactionType._('check');
const TransactionType _$transfer = const TransactionType._('transfer');
const TransactionType _$deposit = const TransactionType._('deposit');
const TransactionType _$payment = const TransactionType._('payment');
const TransactionType _$none = const TransactionType._('none');

TransactionType _$valueOf(String name) {
  switch (name) {
    case 'credit_card_charge':
      return _$credit_card_charge;
    case 'check':
      return _$check;
    case 'transfer':
      return _$transfer;
    case 'deposit':
      return _$deposit;
    case 'payment':
      return _$payment;
    case 'none':
      return _$none;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TransactionType> _$values =
    new BuiltSet<TransactionType>(const <TransactionType>[
  _$credit_card_charge,
  _$check,
  _$transfer,
  _$deposit,
  _$payment,
  _$none,
]);

const TransactionSplitType _$debit = const TransactionSplitType._('debit');
const TransactionSplitType _$credit = const TransactionSplitType._('credit');

TransactionSplitType _$valueOfSplit(String name) {
  switch (name) {
    case 'debit':
      return _$debit;
    case 'credit':
      return _$credit;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TransactionSplitType> _$valuesSplit =
    new BuiltSet<TransactionSplitType>(const <TransactionSplitType>[
  _$debit,
  _$credit,
]);

Serializer<TransactionType> _$transactionTypeSerializer =
    new _$TransactionTypeSerializer();
Serializer<Transaction> _$transactionSerializer = new _$TransactionSerializer();
Serializer<TransactionSplitType> _$transactionSplitTypeSerializer =
    new _$TransactionSplitTypeSerializer();
Serializer<TransactionSplit> _$transactionSplitSerializer =
    new _$TransactionSplitSerializer();

class _$TransactionTypeSerializer
    implements PrimitiveSerializer<TransactionType> {
  @override
  final Iterable<Type> types = const <Type>[TransactionType];
  @override
  final String wireName = 'TransactionType';

  @override
  Object serialize(Serializers serializers, TransactionType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TransactionType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TransactionType.valueOf(serialized as String);
}

class _$TransactionSerializer implements StructuredSerializer<Transaction> {
  @override
  final Iterable<Type> types = const [Transaction, _$Transaction];
  @override
  final String wireName = 'Transaction';

  @override
  Iterable<Object?> serialize(Serializers serializers, Transaction object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'date',
      serializers.serialize(object.date,
          specifiedType: const FullType(BuiltTimestamp)),
      'payer',
      serializers.serialize(object.payer,
          specifiedType: const FullType(String)),
      'splits',
      serializers.serialize(object.splits,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TransactionSplit)])),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(TransactionType)),
    ];

    return result;
  }

  @override
  Transaction deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TransactionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'date':
          result.date.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltTimestamp))!
              as BuiltTimestamp);
          break;
        case 'payer':
          result.payer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'splits':
          result.splits.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TransactionSplit)]))!
              as BuiltList<Object?>);
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
                  specifiedType: const FullType(TransactionType))
              as TransactionType;
          break;
      }
    }

    return result.build();
  }
}

class _$TransactionSplitTypeSerializer
    implements PrimitiveSerializer<TransactionSplitType> {
  @override
  final Iterable<Type> types = const <Type>[TransactionSplitType];
  @override
  final String wireName = 'TransactionSplitType';

  @override
  Object serialize(Serializers serializers, TransactionSplitType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TransactionSplitType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TransactionSplitType.valueOf(serialized as String);
}

class _$TransactionSplitSerializer
    implements StructuredSerializer<TransactionSplit> {
  @override
  final Iterable<Type> types = const [TransactionSplit, _$TransactionSplit];
  @override
  final String wireName = 'TransactionSplit';

  @override
  Iterable<Object?> serialize(Serializers serializers, TransactionSplit object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'amount',
      serializers.serialize(object.amount,
          specifiedType: const FullType(double)),
      'account',
      serializers.serialize(object.account,
          specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(TransactionSplitType)),
    ];
    Object? value;
    value = object.details;
    if (value != null) {
      result
        ..add('details')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TransactionSplit deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TransactionSplitBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'account':
          result.account = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'details':
          result.details = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
                  specifiedType: const FullType(TransactionSplitType))
              as TransactionSplitType;
          break;
      }
    }

    return result.build();
  }
}

class _$Transaction extends Transaction {
  @override
  final BuiltTimestamp date;
  @override
  final String payer;
  @override
  final BuiltList<TransactionSplit> splits;
  @override
  final String id;
  @override
  final TransactionType type;

  factory _$Transaction([void Function(TransactionBuilder)? updates]) =>
      (new TransactionBuilder()..update(updates)).build();

  _$Transaction._(
      {required this.date,
      required this.payer,
      required this.splits,
      required this.id,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(date, 'Transaction', 'date');
    BuiltValueNullFieldError.checkNotNull(payer, 'Transaction', 'payer');
    BuiltValueNullFieldError.checkNotNull(splits, 'Transaction', 'splits');
    BuiltValueNullFieldError.checkNotNull(id, 'Transaction', 'id');
    BuiltValueNullFieldError.checkNotNull(type, 'Transaction', 'type');
  }

  @override
  Transaction rebuild(void Function(TransactionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransactionBuilder toBuilder() => new TransactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transaction &&
        date == other.date &&
        payer == other.payer &&
        splits == other.splits &&
        id == other.id &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, date.hashCode), payer.hashCode), splits.hashCode),
            id.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Transaction')
          ..add('date', date)
          ..add('payer', payer)
          ..add('splits', splits)
          ..add('id', id)
          ..add('type', type))
        .toString();
  }
}

class TransactionBuilder implements Builder<Transaction, TransactionBuilder> {
  _$Transaction? _$v;

  BuiltTimestampBuilder? _date;
  BuiltTimestampBuilder get date =>
      _$this._date ??= new BuiltTimestampBuilder();
  set date(BuiltTimestampBuilder? date) => _$this._date = date;

  String? _payer;
  String? get payer => _$this._payer;
  set payer(String? payer) => _$this._payer = payer;

  ListBuilder<TransactionSplit>? _splits;
  ListBuilder<TransactionSplit> get splits =>
      _$this._splits ??= new ListBuilder<TransactionSplit>();
  set splits(ListBuilder<TransactionSplit>? splits) => _$this._splits = splits;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  TransactionType? _type;
  TransactionType? get type => _$this._type;
  set type(TransactionType? type) => _$this._type = type;

  TransactionBuilder();

  TransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date.toBuilder();
      _payer = $v.payer;
      _splits = $v.splits.toBuilder();
      _id = $v.id;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Transaction other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Transaction;
  }

  @override
  void update(void Function(TransactionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Transaction build() {
    _$Transaction _$result;
    try {
      _$result = _$v ??
          new _$Transaction._(
              date: date.build(),
              payer: BuiltValueNullFieldError.checkNotNull(
                  payer, 'Transaction', 'payer'),
              splits: splits.build(),
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'Transaction', 'id'),
              type: BuiltValueNullFieldError.checkNotNull(
                  type, 'Transaction', 'type'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'date';
        date.build();

        _$failedField = 'splits';
        splits.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Transaction', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TransactionSplit extends TransactionSplit {
  @override
  final double amount;
  @override
  final String account;
  @override
  final String? details;
  @override
  final TransactionSplitType type;

  factory _$TransactionSplit(
          [void Function(TransactionSplitBuilder)? updates]) =>
      (new TransactionSplitBuilder()..update(updates)).build();

  _$TransactionSplit._(
      {required this.amount,
      required this.account,
      this.details,
      required this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(amount, 'TransactionSplit', 'amount');
    BuiltValueNullFieldError.checkNotNull(
        account, 'TransactionSplit', 'account');
    BuiltValueNullFieldError.checkNotNull(type, 'TransactionSplit', 'type');
  }

  @override
  TransactionSplit rebuild(void Function(TransactionSplitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransactionSplitBuilder toBuilder() =>
      new TransactionSplitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransactionSplit &&
        amount == other.amount &&
        account == other.account &&
        details == other.details &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, amount.hashCode), account.hashCode), details.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TransactionSplit')
          ..add('amount', amount)
          ..add('account', account)
          ..add('details', details)
          ..add('type', type))
        .toString();
  }
}

class TransactionSplitBuilder
    implements Builder<TransactionSplit, TransactionSplitBuilder> {
  _$TransactionSplit? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  String? _account;
  String? get account => _$this._account;
  set account(String? account) => _$this._account = account;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  TransactionSplitType? _type;
  TransactionSplitType? get type => _$this._type;
  set type(TransactionSplitType? type) => _$this._type = type;

  TransactionSplitBuilder();

  TransactionSplitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _account = $v.account;
      _details = $v.details;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransactionSplit other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TransactionSplit;
  }

  @override
  void update(void Function(TransactionSplitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TransactionSplit build() {
    final _$result = _$v ??
        new _$TransactionSplit._(
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, 'TransactionSplit', 'amount'),
            account: BuiltValueNullFieldError.checkNotNull(
                account, 'TransactionSplit', 'account'),
            details: details,
            type: BuiltValueNullFieldError.checkNotNull(
                type, 'TransactionSplit', 'type'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
