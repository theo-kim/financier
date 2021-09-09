import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/reference.dart';

part 'account.g.dart';

class AccountType extends EnumClass {
  static const AccountType asset = _$asset;
  static const AccountType liability = _$liability;
  static const AccountType income = _$income;
  static const AccountType expense = _$expense;
  static const AccountType none = _$none;

  const AccountType._(String name) : super(name);

  static BuiltSet<AccountType> get values => _$values;
  static AccountType valueOf(String name) => _$valueOf(name);

  static Serializer<AccountType> get serializer => _$accountTypeSerializer;
}

abstract class Account implements Built<Account, AccountBuilder> {
  double get startingBalance;
  String get name;
  String? get memo;
  AccountType get type;
  BuiltList<BuiltDocumentReference> get children;
  BuiltDocumentReference get id;
  BuiltDocumentReference? get parent;

  Account._();

  factory Account([updates(AccountBuilder b)]) = _$Account;
  static Serializer<Account> get serializer => _$accountSerializer;
}

// AccountType _accountStringToEnum(String? type) {
//   if (type == "asset")
//     return AccountType.ASSET;
//   else if (type == "liability")
//     return AccountType.LIABILITY;
//   else if (type == "income")
//     return AccountType.INCOME;
//   else if (type == "expense")
//     return AccountType.EXPENSE;
//   else
//     return AccountType.NONE;
// }

// class Account extends Entity {
//   Account(
//       {required String id,
//       required this.name,
//       required this.type,
//       required this.parent,
//       required this.startingBalance,
//       this.memo})
//       : super(id: id);

//   Account.fromJson(String docid, Map<String, Object?> json)
//       : this(
//             id: docid,
//             name: json["name"] as String,
//             type: _accountStringToEnum(json["type"] as String?),
//             startingBalance: json["startingBalance"] as double,
//             memo: json["memo"] as String?,
//             parent: json["parent"]);

//   final String name;
//   final AccountType? type;
//   final dynamic? parent;
//   final double startingBalance;
//   final String? memo;
//   late DocumentReference<Map<String, dynamic>> _self;

//   static dynamic createRef(FirebaseFirestore instance) {
//     return instance.collection("accounts").withConverter<Account>(
//           fromFirestore: (snapshot, _) {
//             return Account.fromJson(snapshot.id, snapshot.data()!);
//           },
//           toFirestore: (account, _) => account.toJson(),
//         );
//   }

//   @override
//   String toString() {
//     return name;
//   }

//   Map<String, Object?> toJson() {
//     String accountType = "";

//     if (type == AccountType.ASSET) {
//       accountType = "asset";
//     }
//     if (type == AccountType.LIABILITY) {
//       accountType = "liability";
//     }
//     if (type == AccountType.INCOME) {
//       accountType = "income";
//     } else {
//       accountType = "expense";
//     }

//     return {
//       "name": name,
//       "type": accountType,
//       "startingBalance": startingBalance,
//       "memo": memo,
//     };
//   }
// }
