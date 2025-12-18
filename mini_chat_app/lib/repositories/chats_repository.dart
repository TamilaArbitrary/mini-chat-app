import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_thread.dart';
import '../models/message.dart';
import 'package:mini_chat_app/repositories/profiles_repository.dart';

// --- Абстрактний клас (Інтерфейс) ---
abstract class ChatsRepository {
  // Потік для списку всіх активних чатів поточного користувача
  Stream<List<ChatThread>> getMyChatThreadsStream(String currentUserId);
  
  // Потік для повідомлень у конкретному чаті
  Stream<List<Message>> getMessagesStream(String chatId);
  
  // Відправлення нового повідомлення
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  });
  
  // Початок нового чату (якщо ще не існує)
  Future<String> createChatIfNotExist(String user1Id, String user2Id);
}

// --- Реалізація Firebase ---
class FirebaseChatsRepository implements ChatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _chatsCollection = 'chats';
  
  // 1. ДОДАЄМО ЗАЛЕЖНІСТЬ
  final ProfilesRepository _profilesRepository; 

  // КОНСТРУКТОР
  FirebaseChatsRepository(this._profilesRepository); 
  
  // 1. Потік для списку активних чатів поточного користувача (Виправлено!)
  @override
  Stream<List<ChatThread>> getMyChatThreadsStream(String currentUserId) {
     return _firestore
         .collection(_chatsCollection)
         .where('participants', arrayContains: currentUserId)
         .orderBy('lastTimestamp', descending: true)
         .snapshots()
        // МІНЯЄМО .map НА .asyncMap ДЛЯ АСИНХРОННОГО "ДОТЯГУВАННЯ" ДАНИХ
         .asyncMap((snapshot) async { 
          final threads = await Future.wait(snapshot.docs.map((doc) async {
            
            // 1. Створюємо базовий потік чату
            final baseThread = ChatThread.fromDoc(doc);
            
            // 2. Визначаємо UID співрозмовника
            final otherUserId = baseThread.participants
                .firstWhere((uid) => uid != currentUserId);

            // 3. АСИНХРОННО отримуємо профіль співрозмовника
            try {
              final otherProfile = await _profilesRepository.getMyProfile(otherUserId);
              
              // 4. Повертаємо ПОВНОЦІННИЙ ChatThread (використовуємо .copyWith, якщо він є у ChatThread, 
              // або створюємо новий об'єкт, як у прикладі нижче)

              // Якщо у ChatThread немає .copyWith, використовуємо цю логіку:
              return ChatThread(
                id: baseThread.id,
                participants: baseThread.participants,
                lastMessage: baseThread.lastMessage,
                lastTimestamp: baseThread.lastTimestamp,
                // ЗАПОВНЮЄМО ДАНІ ПРОФІЛЮ
                otherUserName: otherProfile.name, 
                otherUserImageUrl: otherProfile.imageUrl,
              );
            } catch (e) {
              // Якщо профіль не знайдено, використовуємо заглушку
              print("Warning: Profile not found for UID $otherUserId");
              return baseThread;
            }
          }));
          return threads;
        });
  }
  
  // 2. Потік для повідомлень у конкретному чаті
  @override
  Stream<List<Message>> getMessagesStream(String chatId) {
    return _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Сортування від старих до нових
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(Message.fromDoc).toList();
        });
  }
  
  // 3. Відправлення нового повідомлення
  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final messageData = Message(
      id: '', // ID буде згенеровано Firestore
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(), // Тимчасове значення, буде замінено serverTimestamp
    ).toMap();
    
    // 1. Додавання повідомлення в підколекцію 'messages'
    await _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // 2. Оновлення батьківського чату для відображення останнього повідомлення в списку (ChatsScreen)
    await _firestore.collection(_chatsCollection).doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }
  
  // 4. Створення чату (просто приклад, може бути складнішою логіка)
  @override
  Future<String> createChatIfNotExist(String user1Id, String user2Id) async {
    // В реальності тут потрібно знайти, чи існує чат між цими двома UID.
    // Якщо не існує:
    final newChatRef = await _firestore.collection(_chatsCollection).add({
      'participants': [user1Id, user2Id],
      'lastMessage': 'Chat started',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
    return newChatRef.id;
  }
}