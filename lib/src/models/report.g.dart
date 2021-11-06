// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Report> _$reportSerializer = new _$ReportSerializer();

class _$ReportSerializer implements StructuredSerializer<Report> {
  @override
  final Iterable<Type> types = const [Report, _$Report];
  @override
  final String wireName = 'Report';

  @override
  Iterable<Object?> serialize(Serializers serializers, Report object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'endBalance',
      serializers.serialize(object.endBalance,
          specifiedType: const FullType(double)),
      'start',
      serializers.serialize(object.start,
          specifiedType: const FullType(BuiltTimestamp)),
      'end',
      serializers.serialize(object.end,
          specifiedType: const FullType(BuiltTimestamp)),
      'account',
      serializers.serialize(object.account,
          specifiedType: const FullType(String)),
      'composite',
      serializers.serialize(object.composite,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Report)])),
    ];
    Object? value;
    value = object.previous;
    if (value != null) {
      result
        ..add('previous')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Report deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ReportBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'previous':
          result.previous = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'endBalance':
          result.endBalance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'start':
          result.start.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltTimestamp))!
              as BuiltTimestamp);
          break;
        case 'end':
          result.end.replace(serializers.deserialize(value,
                  specifiedType: const FullType(BuiltTimestamp))!
              as BuiltTimestamp);
          break;
        case 'account':
          result.account = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'composite':
          result.composite.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Report)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$Report extends Report {
  @override
  final String id;
  @override
  final String? previous;
  @override
  final double endBalance;
  @override
  final BuiltTimestamp start;
  @override
  final BuiltTimestamp end;
  @override
  final String account;
  @override
  final BuiltList<Report> composite;

  factory _$Report([void Function(ReportBuilder)? updates]) =>
      (new ReportBuilder()..update(updates)).build();

  _$Report._(
      {required this.id,
      this.previous,
      required this.endBalance,
      required this.start,
      required this.end,
      required this.account,
      required this.composite})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Report', 'id');
    BuiltValueNullFieldError.checkNotNull(endBalance, 'Report', 'endBalance');
    BuiltValueNullFieldError.checkNotNull(start, 'Report', 'start');
    BuiltValueNullFieldError.checkNotNull(end, 'Report', 'end');
    BuiltValueNullFieldError.checkNotNull(account, 'Report', 'account');
    BuiltValueNullFieldError.checkNotNull(composite, 'Report', 'composite');
  }

  @override
  Report rebuild(void Function(ReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportBuilder toBuilder() => new ReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Report &&
        id == other.id &&
        previous == other.previous &&
        endBalance == other.endBalance &&
        start == other.start &&
        end == other.end &&
        account == other.account &&
        composite == other.composite;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), previous.hashCode),
                        endBalance.hashCode),
                    start.hashCode),
                end.hashCode),
            account.hashCode),
        composite.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Report')
          ..add('id', id)
          ..add('previous', previous)
          ..add('endBalance', endBalance)
          ..add('start', start)
          ..add('end', end)
          ..add('account', account)
          ..add('composite', composite))
        .toString();
  }
}

class ReportBuilder implements Builder<Report, ReportBuilder> {
  _$Report? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _previous;
  String? get previous => _$this._previous;
  set previous(String? previous) => _$this._previous = previous;

  double? _endBalance;
  double? get endBalance => _$this._endBalance;
  set endBalance(double? endBalance) => _$this._endBalance = endBalance;

  BuiltTimestampBuilder? _start;
  BuiltTimestampBuilder get start =>
      _$this._start ??= new BuiltTimestampBuilder();
  set start(BuiltTimestampBuilder? start) => _$this._start = start;

  BuiltTimestampBuilder? _end;
  BuiltTimestampBuilder get end => _$this._end ??= new BuiltTimestampBuilder();
  set end(BuiltTimestampBuilder? end) => _$this._end = end;

  String? _account;
  String? get account => _$this._account;
  set account(String? account) => _$this._account = account;

  ListBuilder<Report>? _composite;
  ListBuilder<Report> get composite =>
      _$this._composite ??= new ListBuilder<Report>();
  set composite(ListBuilder<Report>? composite) =>
      _$this._composite = composite;

  ReportBuilder();

  ReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _previous = $v.previous;
      _endBalance = $v.endBalance;
      _start = $v.start.toBuilder();
      _end = $v.end.toBuilder();
      _account = $v.account;
      _composite = $v.composite.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Report other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Report;
  }

  @override
  void update(void Function(ReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Report build() {
    _$Report _$result;
    try {
      _$result = _$v ??
          new _$Report._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Report', 'id'),
              previous: previous,
              endBalance: BuiltValueNullFieldError.checkNotNull(
                  endBalance, 'Report', 'endBalance'),
              start: start.build(),
              end: end.build(),
              account: BuiltValueNullFieldError.checkNotNull(
                  account, 'Report', 'account'),
              composite: composite.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'start';
        start.build();
        _$failedField = 'end';
        end.build();

        _$failedField = 'composite';
        composite.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Report', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
