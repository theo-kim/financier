import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:financier/src/models/reference.dart';
import 'package:financier/src/models/user.dart';

part 'transaction.g.dart';

class TransactionType extends EnumClass {
  static const TransactionType credit_card_charge = _$credit_card_charge;
  static const TransactionType check = _$check;
  static const TransactionType transfer = _$transfer;
  static const TransactionType deposit = _$deposit;
  static const TransactionType payment = _$payment;
  static const TransactionType none = _$none;

  const TransactionType._(String name) : super(name);

  static BuiltSet<TransactionType> get values => _$values;
  static TransactionType valueOf(String name) => _$valueOf(name);

  static Serializer<TransactionType> get serializer =>
      _$transactionTypeSerializer;
}

abstract class Transaction implements Built<Transaction, TransactionBuilder> {
  DateTime get date;
  String? get details;
  String get payer;
  BuiltList<TransactionSplit> get credits;
  BuiltList<TransactionSplit> get debits;
  BuiltDocumentReference get id;
  TransactionType? get type;
  BuiltUser get owner;

  Transaction._();

  factory Transaction([updates(TransactionBuilder b)]) = _$Transaction;
  static Serializer<Transaction> get serializer => _$transactionSerializer;
}

abstract class TransactionSplit
    implements Built<TransactionSplit, TransactionSplitBuilder> {
  double get amount;
  BuiltDocumentReference get account;

  TransactionSplit._();

  factory TransactionSplit([updates(TransactionSplitBuilder b)]) =
      _$TransactionSplit;
  static Serializer<TransactionSplit> get serializer =>
      _$transactionSplitSerializer;
}

// class Transaction {
//   Transaction(
//       {this.id,
//       this.date,
//       this.details,
//       this.payer,
//       this.credits,
//       this.debits});
//   Transaction.empty() {
//     this.id = "";
//     this.date = DateTime(1970);
//     this.details = "";
//     this.payer = "";
//     this.credits = [];
//     this.debits = [];
//   }

//   Transaction.fromJson(String id, Map<String, Object?> json) : this();

//   DateTime? date;
//   String? details;
//   String? payer;
//   List<TransactionHalf>? credits;
//   List<TransactionHalf>? debits;
//   String? id;

//   Map<String, Object?> toJson() {
//     return {
//       "date": date!.toUtc(),
//       "details": details,
//       "payer": payer!,
//       "credits": credits!
//           .map<Map<String, Object?>>((credit) => credit.toJson())
//           .toList(),
//       "debits":
//           debits!.map<Map<String, Object?>>((debit) => debit.toJson()).toList()
//     };
//   }

//   static dynamic createRef(FirebaseFirestore instance) {
//     return instance.collection("transactions").withConverter<Transaction>(
//           fromFirestore: (snapshot, _) =>
//               Transaction.fromJson(snapshot.id, snapshot.data()!),
//           toFirestore: (transaction, _) => transaction.toJson(),
//         );
//   }
// }

// class TransactionHalf {
//   TransactionHalf({required this.amount, required this.account});
//   TransactionHalf.empty({this.amount = 0.0}) {
//     this.account = null;
//   }
//   double amount;
//   Account? account;

//   Map<String, Object?> toJson() {
//     return {
//       "amount": amount,
//       "account": null,
//     };
//   }
// }
