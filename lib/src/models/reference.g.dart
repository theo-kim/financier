// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuiltDocumentReference extends BuiltDocumentReference {
  @override
  final DocumentReference<Object?>? reference;

  factory _$BuiltDocumentReference(
          [void Function(BuiltDocumentReferenceBuilder)? updates]) =>
      (new BuiltDocumentReferenceBuilder()..update(updates)).build();

  _$BuiltDocumentReference._({this.reference}) : super._();

  @override
  BuiltDocumentReference rebuild(
          void Function(BuiltDocumentReferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltDocumentReferenceBuilder toBuilder() =>
      new BuiltDocumentReferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltDocumentReference && reference == other.reference;
  }

  @override
  int get hashCode {
    return $jf($jc(0, reference.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltDocumentReference')
          ..add('reference', reference))
        .toString();
  }
}

class BuiltDocumentReferenceBuilder
    implements Builder<BuiltDocumentReference, BuiltDocumentReferenceBuilder> {
  _$BuiltDocumentReference? _$v;

  DocumentReference<Object?>? _reference;
  DocumentReference<Object?>? get reference => _$this._reference;
  set reference(DocumentReference<Object?>? reference) =>
      _$this._reference = reference;

  BuiltDocumentReferenceBuilder();

  BuiltDocumentReferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reference = $v.reference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltDocumentReference other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuiltDocumentReference;
  }

  @override
  void update(void Function(BuiltDocumentReferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltDocumentReference build() {
    final _$result =
        _$v ?? new _$BuiltDocumentReference._(reference: reference);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
