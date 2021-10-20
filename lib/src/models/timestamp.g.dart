// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timestamp.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuiltTimestamp extends BuiltTimestamp {
  @override
  final DateTime date;

  factory _$BuiltTimestamp([void Function(BuiltTimestampBuilder)? updates]) =>
      (new BuiltTimestampBuilder()..update(updates)).build();

  _$BuiltTimestamp._({required this.date}) : super._() {
    BuiltValueNullFieldError.checkNotNull(date, 'BuiltTimestamp', 'date');
  }

  @override
  BuiltTimestamp rebuild(void Function(BuiltTimestampBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltTimestampBuilder toBuilder() =>
      new BuiltTimestampBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltTimestamp && date == other.date;
  }

  @override
  int get hashCode {
    return $jf($jc(0, date.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltTimestamp')..add('date', date))
        .toString();
  }
}

class BuiltTimestampBuilder
    implements Builder<BuiltTimestamp, BuiltTimestampBuilder> {
  _$BuiltTimestamp? _$v;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  BuiltTimestampBuilder();

  BuiltTimestampBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltTimestamp other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuiltTimestamp;
  }

  @override
  void update(void Function(BuiltTimestampBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltTimestamp build() {
    final _$result = _$v ??
        new _$BuiltTimestamp._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, 'BuiltTimestamp', 'date'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
