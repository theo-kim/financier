import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Entity {
  Entity({
    required this.id,
  });

  final String id;
  late DocumentReference<Map<String, dynamic>> _self;

  void setSelfReference(DocumentReference<Map<String, dynamic>> ref) {
    this._self = ref;
  }

  bool compareReference(DocumentReference<Map<String, dynamic>> ref) {
    return ref == this._self;
  }

  DocumentReference<Map<String, dynamic>> getReference() {
    return this._self;
  }

  Map<String, Object?> toJson();
}
