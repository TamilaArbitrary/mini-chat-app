import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id; // Document ID (Auto-ID)
  final String senderId; // UID відправника (критично для write rules)
  final String text;
  final DateTime? timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return Message(
      id: doc.id,
      senderId: data['senderId'] as String,
      text: data['text'] as String,
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}