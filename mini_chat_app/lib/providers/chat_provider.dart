import 'package:flutter/material.dart';
import 'dart:async'; // Для роботи зі StreamSubscription
import '../models/chat_thread.dart';
import '../models/message.dart';
import '../repositories/chats_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatsRepository _chatsRepository;
  
  // ID поточного користувача (потрібен для фільтрації чатів)
  String? _currentUserId; 

  // Список активних чатів
  List<ChatThread> _chatThreads = []; 
  bool _isLoadingThreads = true;
  
  // Повідомлення в поточному відкритому чаті
  List<Message> _currentMessages = [];
  String? _currentThreadId;
  StreamSubscription<List<ChatThread>>? _threadsSubscription;
  StreamSubscription<List<Message>>? _messagesSubscription;

  // ----------------------------------------------------------------------
  // 1. КОНСТРУКТОР ТА ІНІЦІАЛІЗАЦІЯ
  // ----------------------------------------------------------------------

  ChatProvider(this._chatsRepository);

  // ----------------------------------------------------------------------
  // 2. ГЕТЕРИ
  // ----------------------------------------------------------------------

  List<ChatThread> get chatThreads => _chatThreads;
  bool get isLoadingThreads => _isLoadingThreads;
  List<Message> get currentMessages => _currentMessages;

  // УВАГА: Ваші старі списки matches та messages тепер об'єднані
  // в _chatThreads. На UI їх можна розділити за критеріями.
  // Наприклад, matches можуть бути чати з 1-2 повідомленнями або без.

  // ----------------------------------------------------------------------
  // 3. МЕТОДИ КЕРУВАННЯ ЧАТАМИ (THREADS)
  // ----------------------------------------------------------------------

  // Викликається ззовні (наприклад, з AuthProvider або AuthWrapper), 
  // коли користувач логіниться.
  void initChatThreads(String userId) {
    print("DEBUG: initChatThreads called for $userId");
    if (_currentUserId == userId) return; 
    _currentUserId = userId;

    _isLoadingThreads = true;
    notifyListeners();

    // Скасовуємо попередню підписку, якщо була
    _threadsSubscription?.cancel();

    // Підписуємося на потік чатів у реальному часі
    _threadsSubscription = _chatsRepository
        .getMyChatThreadsStream(userId)
        .listen((threads) {
          _chatThreads = threads;
          _isLoadingThreads = false;
          notifyListeners();
        }, onError: (error) {
          print("Error fetching chat threads: $error");
          _isLoadingThreads = false;
          notifyListeners();
        });
  }

  // ----------------------------------------------------------------------
  // 4. МЕТОДИ КЕРУВАННЯ ПОВІДОМЛЕННЯМИ
  // ----------------------------------------------------------------------
  
  // Відкриття конкретного чату
  void openChat(String threadId) {
    if (_currentThreadId == threadId) return;
    
    _currentThreadId = threadId;
    _currentMessages = []; // Очищаємо старі повідомлення
    notifyListeners();

    _messagesSubscription?.cancel(); // Скасовуємо попередню підписку

    // Підписуємося на потік повідомлень у реальному часі
    _messagesSubscription = _chatsRepository
        .getMessagesStream(threadId)
        .listen((messages) {
          _currentMessages = messages;
          notifyListeners();
        }, onError: (error) {
          print("Error fetching messages: $error");
        });
  }

  // Відправка повідомлення
  Future<void> sendMessage(String text) async {
    if (_currentThreadId == null || _currentUserId == null || text.trim().isEmpty) return;

    await _chatsRepository.sendMessage(
        chatId: _currentThreadId!, // <--- ВИПРАВЛЕНО
        senderId: _currentUserId!,  // <--- ВИПРАВЛЕНО
        text: text, // <--- ВИПРАВЛЕНО
    );
}
  // ----------------------------------------------------------------------
  // 5. ОЧИЩЕННЯ
  // ----------------------------------------------------------------------

  void clearData() {
    _threadsSubscription?.cancel();
    _messagesSubscription?.cancel();
    _chatThreads = [];
    _currentMessages = [];
    _currentUserId = null;
    _currentThreadId = null;
    _isLoadingThreads = true;
    notifyListeners();
  }

  // Завжди скасовуємо підписки при закритті провайдера
  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}