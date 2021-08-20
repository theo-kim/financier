import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:financier/src/models/account.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/transaction.dart';

part 'serializer.g.dart';

@SerializersFor(const [BuiltDocumentReference])
final Serializers referenceSerializers = _$referenceSerializers;

@SerializersFor(const [Account, AccountType, Transaction, TransactionSplit])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
