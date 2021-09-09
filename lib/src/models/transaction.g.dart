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

Serializer<TransactionType> _$transactionTypeSerializer =
    new _$TransactionTypeSerializer();
Serializer<Transaction> _$transactionSerializer = new _$TransactionSerializer();
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
          specifiedType: const FullType(DateTime)),
      'payer',
      serializers.serialize(object.payer,
          specifiedType: const FullType(String)),
      'credits',
      serializers.serialize(object.credits,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TransactionSplit)])),
      'debits',
      serializers.serialize(object.debits,
          specifiedType: const FullType(
              BuiltList, const [const FullType(TransactionSplit)])),
      'id',
      serializers.serialize(object.id,
          specifiedType: const FullType(BuiltDocumentReference)),
    ];
    Object? value;
    value = object.details;
    if (value != null) {
      result
        ..add('details')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(TransactionType)));
    }
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
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'details':
          result.details = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'payer':
          result.payer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'credits':
          result.credits.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TransactionSplit)]))!
              as BuiltList<Object?>);
          break;
        case 'debits':
          result.debits.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TransactionSplit)]))!
              as BuiltList<Object?>);
          break;
        case 'id':
          result.id.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltDocumentReference))!
              as BuiltDocumentReference);
          break;
        case 'type':
          result.type = serializers.deserialize(value,
                  specifiedType: const FullType(TransactionType))
              as TransactionType?;
          break;
      }
    }

    return result.build();
  }
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
          specifiedType: const FullType(BuiltDocumentReference)),
    ];

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
          result.account.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltDocumentReference))!
              as BuiltDocumentReference);
          break;
      }
    }

    return result.build();
  }
}

class _$Transaction extends Transaction {
  @override
  final DateTime date;
  @override
  final String? details;
  @override
  final String payer;
  @override
  final BuiltList<TransactionSplit> credits;
  @override
  final BuiltList<TransactionSplit> debits;
  @override
  final BuiltDocumentReference id;
  @override
  final TransactionType? type;

  factory _$Transaction([void Function(TransactionBuilder)? updates]) =>
      (new TransactionBuilder()..update(updates)).build();

  _$Transaction._(
      {required this.date,
      this.details,
      required this.payer,
      required this.credits,
      required this.debits,
      required this.id,
      this.type})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(date, 'Transaction', 'date');
    BuiltValueNullFieldError.checkNotNull(payer, 'Transaction', 'payer');
    BuiltValueNullFieldError.checkNotNull(credits, 'Transaction', 'credits');
    BuiltValueNullFieldError.checkNotNull(debits, 'Transaction', 'debits');
    BuiltValueNullFieldError.checkNotNull(id, 'Transaction', 'id');
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
        details == other.details &&
        payer == other.payer &&
        credits == other.credits &&
        debits == other.debits &&
        id == other.id &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, date.hashCode), details.hashCode),
                        payer.hashCode),
                    credits.hashCode),
                debits.hashCode),
            id.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Transaction')
          ..add('date', date)
          ..add('details', details)
          ..add('payer', payer)
          ..add('credits', credits)
          ..add('debits', debits)
          ..add('id', id)
          ..add('type', type))
        .toString();
  }
}

class TransactionBuilder implements Builder<Transaction, TransactionBuilder> {
  _$Transaction? _$v;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  String? _payer;
  String? get payer => _$this._payer;
  set payer(String? payer) => _$this._payer = payer;

  ListBuilder<TransactionSplit>? _credits;
  ListBuilder<TransactionSplit> get credits =>
      _$this._credits ??= new ListBuilder<TransactionSplit>();
  set credits(ListBuilder<TransactionSplit>? credits) =>
      _$this._credits = credits;

  ListBuilder<TransactionSplit>? _debits;
  ListBuilder<TransactionSplit> get debits =>
      _$this._debits ??= new ListBuilder<TransactionSplit>();
  set debits(ListBuilder<TransactionSplit>? debits) => _$this._debits = debits;

  BuiltDocumentReferenceBuilder? _id;
  BuiltDocumentReferenceBuilder get id =>
      _$this._id ??= new BuiltDocumentReferenceBuilder();
  set id(BuiltDocumentReferenceBuilder? id) => _$this._id = id;

  TransactionType? _type;
  TransactionType? get type => _$this._type;
  set type(TransactionType? type) => _$this._type = type;

  TransactionBuilder();

  TransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _details = $v.details;
      _payer = $v.payer;
      _credits = $v.credits.toBuilder();
      _debits = $v.debits.toBuilder();
      _id = $v.id.toBuilder();
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
              date: BuiltValueNullFieldError.checkNotNull(
                  date, 'Transaction', 'date'),
              details: details,
              payer: BuiltValueNullFieldError.checkNotNull(
                  payer, 'Transaction', 'payer'),
              credits: credits.build(),
              debits: debits.build(),
              id: id.build(),
              type: type);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'credits';
        credits.build();
        _$failedField = 'debits';
        debits.build();
        _$failedField = 'id';
        id.build();
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
  final BuiltDocumentReference account;

  factory _$TransactionSplit(
          [void Function(TransactionSplitBuilder)? updates]) =>
      (new TransactionSplitBuilder()..update(updates)).build();

  _$TransactionSplit._({required this.amount, required this.account})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(amount, 'TransactionSplit', 'amount');
    BuiltValueNullFieldError.checkNotNull(
        account, 'TransactionSplit', 'account');
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
        account == other.account;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, amount.hashCode), account.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TransactionSplit')
          ..add('amount', amount)
          ..add('account', account))
        .toString();
  }
}

class TransactionSplitBuilder
    implements Builder<TransactionSplit, TransactionSplitBuilder> {
  _$TransactionSplit? _$v;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  BuiltDocumentReferenceBuilder? _account;
  BuiltDocumentReferenceBuilder get account =>
      _$this._account ??= new BuiltDocumentReferenceBuilder();
  set account(BuiltDocumentReferenceBuilder? account) =>
      _$this._account = account;

  TransactionSplitBuilder();

  TransactionSplitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _account = $v.account.toBuilder();
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
    _$TransactionSplit _$result;
    try {
      _$result = _$v ??
          new _$TransactionSplit._(
              amount: BuiltValueNullFieldError.checkNotNull(
                  amount, 'TransactionSplit', 'amount'),
              account: account.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'account';
        account.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TransactionSplit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
