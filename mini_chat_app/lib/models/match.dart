import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id; // Document ID (Auto-ID)
  final String userAId; // UID першого користувача
  final String userBId; // UID другого користувача
  final DateTime createdAt;
  
  const Match({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.createdAt,
  });

  factory Match.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Match(
      id: doc.id,
      
      userAId: data['userA'] as String,
      userBId: data['userB'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userA': userAId,
      'userB': userBId,
      'createdAt': FieldValue.serverTimestamp(), 
    };
  }
}