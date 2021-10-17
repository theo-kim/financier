import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

part 'user.g.dart';

abstract class BuiltUser implements Built<BuiltUser, BuiltUserBuilder> {
  String get uid;

  BuiltUser._();

  factory BuiltUser([updates(BuiltUserBuilder b)]) = _$BuiltUser;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuiltUser> get serializer => FirebaseUserSerializer();
}

class FirebaseUserSerializer implements PrimitiveSerializer<BuiltUser> {
  @override
  BuiltUser deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BuiltUserBuilder();

    result.uid = serialized as String;

    return result.build();
  }

  @override
  Object serialize(Serializers serializers, BuiltUser object,
      {FullType specifiedType = FullType.unspecified}) {
    return object.uid;
  }

  @override
  Iterable<Type> get types => [BuiltUser, _$BuiltUser];

  @override
  String get wireName => "BuiltUser";
}
