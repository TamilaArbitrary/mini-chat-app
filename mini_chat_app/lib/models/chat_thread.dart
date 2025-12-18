import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  final String id; // Document ID (Auto-ID)
  final List<String> participants; // Масив [UID1, UID2]
  final String lastMessage;
  final DateTime? lastTimestamp;
  
  // Додаткові дані, які потрібно отримувати з іншої моделі (Profile)
  final String otherUserName; 
  final String otherUserImageUrl; 

  const ChatThread({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.otherUserName,
    required this.otherUserImageUrl,
  });

  factory ChatThread.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    
    // Тут умовно не витягуємо дані іншого користувача, 
    // оскільки їх треба "дотягувати" в репозиторії
    
    return ChatThread(
      id: doc.id,
      // Приведення динамічного списку до List<String>
      participants: List<String>.from(data['participants'] ?? []),
       lastMessage: data['lastMessage'] ?? 'No messages yet',
      // lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastTimestamp: data['lastTimestamp'] != null
          ? (data['lastTimestamp'] as Timestamp).toDate()
          : null,
      // Ці поля заповнюються в провайдері/репозиторії, 
      // використовуючи UID з 'participants'
      otherUserName: '', 
      otherUserImageUrl: '', 
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      //'lastMessageTime': FieldValue.serverTimestamp(),
      if (isNew) 'lastTimestamp': FieldValue.serverTimestamp(),
    };
  }
}