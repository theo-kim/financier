import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'reference.g.dart';

abstract class BuiltDocumentReference
    implements Built<BuiltDocumentReference, BuiltDocumentReferenceBuilder> {
  DocumentReference<Object?>? get reference;

  BuiltDocumentReference._();

  factory BuiltDocumentReference([updates(BuiltDocumentReferenceBuilder b)]) =
      _$BuiltDocumentReference;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuiltDocumentReference> get serializer =>
      FirestoreReferenceSerializer();
}

class FirestoreReferenceSerializer
    implements PrimitiveSerializer<BuiltDocumentReference> {
  @override
  BuiltDocumentReference deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BuiltDocumentReferenceBuilder();

    result.reference = serialized as DocumentReference<Map<String, Object?>>;

    return result.build();
  }

  @override
  Object serialize(Serializers serializers, BuiltDocumentReference object,
      {FullType specifiedType = FullType.unspecified}) {
    return object.reference!;
  }

  @override
  Iterable<Type> get types =>
      [BuiltDocumentReference, _$BuiltDocumentReference];

  @override
  String get wireName => "BuiltDocumentReference";
}

// class DocumentReferencePlugin implements SerializerPlugin {
//   @override
//   Object? afterDeserialize(Object? object, FullType specifiedType) {
//     // TODO: implement afterDeserialize
//     throw UnimplementedError();
//   }

//   @override
//   Object? afterSerialize(Object? object, FullType specifiedType) {
//     // TODO: implement afterSerialize
//     throw UnimplementedError();
//   }

//   @override
//   Object? beforeDeserialize(Object? object, FullType specifiedType) {
//     // TODO: implement beforeDeserialize
//     throw UnimplementedError();
//   }

//   @override
//   Object? beforeSerialize(Object? object, FullType specifiedType) {
//     // TODO: implement beforeSerialize
//     throw UnimplementedError();
//   }
// }
