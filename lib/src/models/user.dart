import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/timestamp.dart';

part 'user.g.dart';

abstract class BuiltUser implements Built<BuiltUser, BuiltUserBuilder> {
  String get uid;
  String get email;
  String get name;
  BuiltTimestamp get joined;

  BuiltUser._();

  factory BuiltUser([updates(BuiltUserBuilder b)]) = _$BuiltUser;
  static Serializer<BuiltUser> get serializer => _$builtUserSerializer;
}
