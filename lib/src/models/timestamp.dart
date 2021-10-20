import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'timestamp.g.dart';

abstract class BuiltTimestamp
    implements Built<BuiltTimestamp, BuiltTimestampBuilder> {
  DateTime get date;

  BuiltTimestamp._();

  factory BuiltTimestamp([updates(BuiltTimestampBuilder b)]) = _$BuiltTimestamp;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuiltTimestamp> get serializer => TimestampSerializer();
}

class TimestampSerializer implements PrimitiveSerializer<BuiltTimestamp> {
  @override
  BuiltTimestamp deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BuiltTimestampBuilder();

    result.date = (serialized as Timestamp).toDate();

    return result.build();
  }

  @override
  Object serialize(Serializers serializers, BuiltTimestamp object,
      {FullType specifiedType = FullType.unspecified}) {
    return Timestamp.fromDate(object.date);
  }

  @override
  Iterable<Type> get types => [BuiltTimestamp, _$BuiltTimestamp];

  @override
  String get wireName => "BuiltTimestamp";
}
