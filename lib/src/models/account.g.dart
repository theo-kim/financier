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

class _$AccountSerializer implements StructuredSerializer<Account> {
  @override
  final Iterable<Type> types = const [Account, _$Account];
  @override
  final String wireName = 'Account';

  @override
  Iterable<Object?> serialize(Serializers serializers, Account object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'startingBalance',
      serializers.serialize(object.startingBalance,
          specifiedType: const FullType(double)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(AccountType)),
      'children',
      serializers.serialize(object.children,
          specifiedType: const FullType(
              BuiltList, const [const FullType(BuiltDocumentReference)])),
      'id',
      serializers.serialize(object.id,
          specifiedType: const FullType(BuiltDocumentReference)),
    ];
    Object? value;
    value = object.memo;
    if (value != null) {
      result
        ..add('memo')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
        case 'startingBalance':
          result.startingBalance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'memo':
          result.memo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(AccountType)) as AccountType;
          break;
        case 'children':
          result.children.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(BuiltDocumentReference)
              ]))! as BuiltList<Object?>);
          break;
        case 'id':
          result.id.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltDocumentReference))!
              as BuiltDocumentReference);
          break;
      }
    }

    return result.build();
  }
}

class _$Account extends Account {
  @override
  final double startingBalance;
  @override
  final String name;
  @override
  final String? memo;
  @override
  final AccountType type;
  @override
  final BuiltList<BuiltDocumentReference> children;
  @override
  final BuiltDocumentReference id;

  factory _$Account([void Function(AccountBuilder)? updates]) =>
      (new AccountBuilder()..update(updates)).build();

  _$Account._(
      {required this.startingBalance,
      required this.name,
      this.memo,
      required this.type,
      required this.children,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        startingBalance, 'Account', 'startingBalance');
    BuiltValueNullFieldError.checkNotNull(name, 'Account', 'name');
    BuiltValueNullFieldError.checkNotNull(type, 'Account', 'type');
    BuiltValueNullFieldError.checkNotNull(children, 'Account', 'children');
    BuiltValueNullFieldError.checkNotNull(id, 'Account', 'id');
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
        startingBalance == other.startingBalance &&
        name == other.name &&
        memo == other.memo &&
        type == other.type &&
        children == other.children &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, startingBalance.hashCode), name.hashCode),
                    memo.hashCode),
                type.hashCode),
            children.hashCode),
        id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Account')
          ..add('startingBalance', startingBalance)
          ..add('name', name)
          ..add('memo', memo)
          ..add('type', type)
          ..add('children', children)
          ..add('id', id))
        .toString();
  }
}

class AccountBuilder implements Builder<Account, AccountBuilder> {
  _$Account? _$v;

  double? _startingBalance;
  double? get startingBalance => _$this._startingBalance;
  set startingBalance(double? startingBalance) =>
      _$this._startingBalance = startingBalance;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  AccountType? _type;
  AccountType? get type => _$this._type;
  set type(AccountType? type) => _$this._type = type;

  ListBuilder<BuiltDocumentReference>? _children;
  ListBuilder<BuiltDocumentReference> get children =>
      _$this._children ??= new ListBuilder<BuiltDocumentReference>();
  set children(ListBuilder<BuiltDocumentReference>? children) =>
      _$this._children = children;

  BuiltDocumentReferenceBuilder? _id;
  BuiltDocumentReferenceBuilder get id =>
      _$this._id ??= new BuiltDocumentReferenceBuilder();
  set id(BuiltDocumentReferenceBuilder? id) => _$this._id = id;

  AccountBuilder();

  AccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startingBalance = $v.startingBalance;
      _name = $v.name;
      _memo = $v.memo;
      _type = $v.type;
      _children = $v.children.toBuilder();
      _id = $v.id.toBuilder();
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
              startingBalance: BuiltValueNullFieldError.checkNotNull(
                  startingBalance, 'Account', 'startingBalance'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'Account', 'name'),
              memo: memo,
              type: BuiltValueNullFieldError.checkNotNull(
                  type, 'Account', 'type'),
              children: children.build(),
              id: id.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'children';
        children.build();
        _$failedField = 'id';
        id.build();
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
