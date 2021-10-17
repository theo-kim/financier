// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$referenceSerializers = (new Serializers().toBuilder()
      ..add(BuiltDocumentReference.serializer))
    .build();
Serializers _$userSerializers =
    (new Serializers().toBuilder()..add(BuiltUser.serializer)).build();
Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Account.serializer)
      ..add(AccountType.serializer)
      ..add(BuiltDocumentReference.serializer)
      ..add(BuiltUser.serializer)
      ..add(Transaction.serializer)
      ..add(TransactionSplit.serializer)
      ..add(TransactionType.serializer)
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuiltDocumentReference)]),
          () => new ListBuilder<BuiltDocumentReference>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TransactionSplit)]),
          () => new ListBuilder<TransactionSplit>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TransactionSplit)]),
          () => new ListBuilder<TransactionSplit>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
