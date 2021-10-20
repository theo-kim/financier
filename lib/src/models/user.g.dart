// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuiltUser> _$builtUserSerializer = new _$BuiltUserSerializer();

class _$BuiltUserSerializer implements StructuredSerializer<BuiltUser> {
  @override
  final Iterable<Type> types = const [BuiltUser, _$BuiltUser];
  @override
  final String wireName = 'BuiltUser';

  @override
  Iterable<Object?> serialize(Serializers serializers, BuiltUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'joined',
      serializers.serialize(object.joined,
          specifiedType: const FullType(BuiltTimestamp)),
    ];

    return result;
  }

  @override
  BuiltUser deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'joined':
          result.joined.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltTimestamp))!
              as BuiltTimestamp);
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltUser extends BuiltUser {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String name;
  @override
  final BuiltTimestamp joined;

  factory _$BuiltUser([void Function(BuiltUserBuilder)? updates]) =>
      (new BuiltUserBuilder()..update(updates)).build();

  _$BuiltUser._(
      {required this.uid,
      required this.email,
      required this.name,
      required this.joined})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uid, 'BuiltUser', 'uid');
    BuiltValueNullFieldError.checkNotNull(email, 'BuiltUser', 'email');
    BuiltValueNullFieldError.checkNotNull(name, 'BuiltUser', 'name');
    BuiltValueNullFieldError.checkNotNull(joined, 'BuiltUser', 'joined');
  }

  @override
  BuiltUser rebuild(void Function(BuiltUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltUserBuilder toBuilder() => new BuiltUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltUser &&
        uid == other.uid &&
        email == other.email &&
        name == other.name &&
        joined == other.joined;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, uid.hashCode), email.hashCode), name.hashCode),
        joined.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltUser')
          ..add('uid', uid)
          ..add('email', email)
          ..add('name', name)
          ..add('joined', joined))
        .toString();
  }
}

class BuiltUserBuilder implements Builder<BuiltUser, BuiltUserBuilder> {
  _$BuiltUser? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  BuiltTimestampBuilder? _joined;
  BuiltTimestampBuilder get joined =>
      _$this._joined ??= new BuiltTimestampBuilder();
  set joined(BuiltTimestampBuilder? joined) => _$this._joined = joined;

  BuiltUserBuilder();

  BuiltUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _email = $v.email;
      _name = $v.name;
      _joined = $v.joined.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltUser other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuiltUser;
  }

  @override
  void update(void Function(BuiltUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltUser build() {
    _$BuiltUser _$result;
    try {
      _$result = _$v ??
          new _$BuiltUser._(
              uid: BuiltValueNullFieldError.checkNotNull(
                  uid, 'BuiltUser', 'uid'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'BuiltUser', 'email'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'BuiltUser', 'name'),
              joined: joined.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'joined';
        joined.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
