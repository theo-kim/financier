// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountType _$asset = const AccountType._('asset');
const AccountType _$liability = const AccountType._('liability');
const AccountType _$income = const AccountType._('income');
const AccountType _$expense = const AccountType._('expense');
const AccountType _$none = const AccountType._('none');

AccountType _$valueOf(String name) {
  switch (name) {
    case 'asset':
      return _$asset;
    case 'liability':
      return _$liability;
    case 'income':
      return _$income;
    case 'expense':
      return _$expense;
    case 'none':
      return _$none;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AccountType> _$values =
    new BuiltSet<AccountType>(const <AccountType>[
  _$asset,
  _$liability,
  _$income,
  _$expense,
  _$none,
]);

Serializer<AccountType> _$accountTypeSerializer = new _$AccountTypeSerializer();
Serializer<AccountTransaction> _$accountTransactionSerializer =
    new _$AccountTransactionSerializer();
Serializer<Account> _$accountSerializer = new _$AccountSerializer();

class _$AccountTypeSerializer implements PrimitiveSerializer<AccountType> {
  @override
  final Iterable<Type> types = const <Type>[AccountType];
  @override
  final String wireName = 'AccountType';

  @override
  Object serialize(Serializers serializers, AccountType object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  AccountType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountType.valueOf(serialized as String);
}

class _$AccountTransactionSerializer
    implements StructuredSerializer<AccountTransaction> {
  @override
  final Iterable<Type> types = const [AccountTransaction, _$AccountTransaction];
  @override
  final String wireName = 'AccountTransaction';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AccountTransaction object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'transaction',
      serializers.serialize(object.transaction,
          specifiedType: const FullType(String)),
      'runningTotal',
      serializers.serialize(object.runningTotal,
          specifiedType: const FullType(double)),
      'report',
      serializers.serialize(object.report,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AccountTransaction deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccountTransactionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'transaction':
          result.transaction = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'runningTotal':
          result.runningTotal = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'report':
          result.report = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AccountSerializer implements StructuredSerializer<Account> {
  @override
  final Iterable<Type> types = const [Account, _$Account];
  @override
  final String wireName = 'Account';

  @override
  Iterable<Object?> serialize(Serializers serializers, Account object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'startingBalance',
      serializers.serialize(object.startingBalance,
          specifiedType: const FullType(double)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(AccountType)),
      'children',
      serializers.serialize(object.children,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(AccountTag)])),
    ];
    Object? value;
    value = object.memo;
    if (value != null) {
      result
        ..add('memo')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.parent;
    if (value != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.transactions;
    if (value != null) {
      result
        ..add('transactions')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                BuiltList, const [const FullType(AccountTransaction)])));
    }
    return result;
  }

  @override
  Account deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccountBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'memo':
          result.memo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'startingBalance':
          result.startingBalance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(AccountType)) as AccountType;
          break;
        case 'parent':
          result.parent = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'children':
          result.children.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(AccountTag)]))!
              as BuiltList<Object?>);
          break;
        case 'transactions':
          result.transactions.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(AccountTransaction)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$AccountTransaction extends AccountTransaction {
  @override
  final String transaction;
  @override
  final double runningTotal;
  @override
  final String report;

  factory _$AccountTransaction(
          [void Function(AccountTransactionBuilder)? updates]) =>
      (new AccountTransactionBuilder()..update(updates)).build();

  _$AccountTransaction._(
      {required this.transaction,
      required this.runningTotal,
      required this.report})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        transaction, 'AccountTransaction', 'transaction');
    BuiltValueNullFieldError.checkNotNull(
        runningTotal, 'AccountTransaction', 'runningTotal');
    BuiltValueNullFieldError.checkNotNull(
        report, 'AccountTransaction', 'report');
  }

  @override
  AccountTransaction rebuild(
          void Function(AccountTransactionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountTransactionBuilder toBuilder() =>
      new AccountTransactionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountTransaction &&
        transaction == other.transaction &&
        runningTotal == other.runningTotal &&
        report == other.report;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, transaction.hashCode), runningTotal.hashCode),
        report.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AccountTransaction')
          ..add('transaction', transaction)
          ..add('runningTotal', runningTotal)
          ..add('report', report))
        .toString();
  }
}

class AccountTransactionBuilder
    implements Builder<AccountTransaction, AccountTransactionBuilder> {
  _$AccountTransaction? _$v;

  String? _transaction;
  String? get transaction => _$this._transaction;
  set transaction(String? transaction) => _$this._transaction = transaction;

  double? _runningTotal;
  double? get runningTotal => _$this._runningTotal;
  set runningTotal(double? runningTotal) => _$this._runningTotal = runningTotal;

  String? _report;
  String? get report => _$this._report;
  set report(String? report) => _$this._report = report;

  AccountTransactionBuilder();

  AccountTransactionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _transaction = $v.transaction;
      _runningTotal = $v.runningTotal;
      _report = $v.report;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountTransaction other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AccountTransaction;
  }

  @override
  void update(void Function(AccountTransactionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AccountTransaction build() {
    final _$result = _$v ??
        new _$AccountTransaction._(
            transaction: BuiltValueNullFieldError.checkNotNull(
                transaction, 'AccountTransaction', 'transaction'),
            runningTotal: BuiltValueNullFieldError.checkNotNull(
                runningTotal, 'AccountTransaction', 'runningTotal'),
            report: BuiltValueNullFieldError.checkNotNull(
                report, 'AccountTransaction', 'report'));
    replace(_$result);
    return _$result;
  }
}

class _$Account extends Account {
  @override
  final String name;
  @override
  final String? memo;
  @override
  final double startingBalance;
  @override
  final AccountType type;
  @override
  final String? parent;
  @override
  final BuiltList<String> children;
  @override
  final BuiltList<AccountTag> tags;
  @override
  final BuiltList<AccountTransaction>? transactions;

  factory _$Account([void Function(AccountBuilder)? updates]) =>
      (new AccountBuilder()..update(updates)).build();

  _$Account._(
      {required this.name,
      this.memo,
      required this.startingBalance,
      required this.type,
      this.parent,
      required this.children,
      required this.tags,
      this.transactions})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'Account', 'name');
    BuiltValueNullFieldError.checkNotNull(
        startingBalance, 'Account', 'startingBalance');
    BuiltValueNullFieldError.checkNotNull(type, 'Account', 'type');
    BuiltValueNullFieldError.checkNotNull(children, 'Account', 'children');
    BuiltValueNullFieldError.checkNotNull(tags, 'Account', 'tags');
  }

  @override
  Account rebuild(void Function(AccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountBuilder toBuilder() => new AccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Account &&
        name == other.name &&
        memo == other.memo &&
        startingBalance == other.startingBalance &&
        type == other.type &&
        parent == other.parent &&
        children == other.children &&
        tags == other.tags &&
        transactions == other.transactions;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, name.hashCode), memo.hashCode),
                            startingBalance.hashCode),
                        type.hashCode),
                    parent.hashCode),
                children.hashCode),
            tags.hashCode),
        transactions.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Account')
          ..add('name', name)
          ..add('memo', memo)
          ..add('startingBalance', startingBalance)
          ..add('type', type)
          ..add('parent', parent)
          ..add('children', children)
          ..add('tags', tags)
          ..add('transactions', transactions))
        .toString();
  }
}

class AccountBuilder implements Builder<Account, AccountBuilder> {
  _$Account? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  double? _startingBalance;
  double? get startingBalance => _$this._startingBalance;
  set startingBalance(double? startingBalance) =>
      _$this._startingBalance = startingBalance;

  AccountType? _type;
  AccountType? get type => _$this._type;
  set type(AccountType? type) => _$this._type = type;

  String? _parent;
  String? get parent => _$this._parent;
  set parent(String? parent) => _$this._parent = parent;

  ListBuilder<String>? _children;
  ListBuilder<String> get children =>
      _$this._children ??= new ListBuilder<String>();
  set children(ListBuilder<String>? children) => _$this._children = children;

  ListBuilder<AccountTag>? _tags;
  ListBuilder<AccountTag> get tags =>
      _$this._tags ??= new ListBuilder<AccountTag>();
  set tags(ListBuilder<AccountTag>? tags) => _$this._tags = tags;

  ListBuilder<AccountTransaction>? _transactions;
  ListBuilder<AccountTransaction> get transactions =>
      _$this._transactions ??= new ListBuilder<AccountTransaction>();
  set transactions(ListBuilder<AccountTransaction>? transactions) =>
      _$this._transactions = transactions;

  AccountBuilder();

  AccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _memo = $v.memo;
      _startingBalance = $v.startingBalance;
      _type = $v.type;
      _parent = $v.parent;
      _children = $v.children.toBuilder();
      _tags = $v.tags.toBuilder();
      _transactions = $v.transactions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Account other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Account;
  }

  @override
  void update(void Function(AccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Account build() {
    _$Account _$result;
    try {
      _$result = _$v ??
          new _$Account._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'Account', 'name'),
              memo: memo,
              startingBalance: BuiltValueNullFieldError.checkNotNull(
                  startingBalance, 'Account', 'startingBalance'),
              type: BuiltValueNullFieldError.checkNotNull(
                  type, 'Account', 'type'),
              parent: parent,
              children: children.build(),
              tags: tags.build(),
              transactions: _transactions?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'children';
        children.build();
        _$failedField = 'tags';
        tags.build();
        _$failedField = 'transactions';
        _transactions?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Account', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
