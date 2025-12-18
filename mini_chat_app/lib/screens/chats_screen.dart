import 'package:flutter/material.dart';
import 'package:mini_chat_app/models/chat_thread.dart';
import 'package:mini_chat_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/screens/chat_detail_screen.dart';


const Color _bgColor = Color(0xFFFFFAFA);
const Color _primaryColor = Color(0xFF1B1918);
const Color _hintColor = Color(0xFF6A6A6A); 
const Color _secondaryColor = Color(0xFF424242);

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {

  // Допоміжна функція для визначення, чи чат є просто "Матчем"
  // У Firebase ми можемо визначити це за текстом першого повідомлення.
  bool _isJustMatch(ChatThread chat) {
    // Припустимо, що чат, який має лише "Chat started" як останнє повідомлення, є Match.
    // У реальності, тут може бути потрібне додаткове поле 'isNew' у моделі.
    return chat.lastMessage == 'Chat started' || chat.lastMessage == 'No messages yet' || chat.lastMessage == 'Goodbye';
  }

  // --- Оновлено _buildMatchItem ---
  Widget _buildMatchItem(ChatThread match) {
    // Використовуємо NetworkImage, оскільки URL приходить з Firestore
    final imageUrl = match.otherUserImageUrl.isNotEmpty 
            ? NetworkImage(match.otherUserImageUrl) as ImageProvider
            : const AssetImage("assets/images/default_match.png"); // Fallback
            
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageUrl,
          onBackgroundImageError: (exception, stackTrace) {
            return; 
          },
        ),
        const SizedBox(height: 4),
        // Відображаємо ім'я
        Text(
          match.otherUserName.split(' ').first, // Тільки перше слово імені
          style: const TextStyle(fontSize: 12, color: _secondaryColor),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // --- Оновлено _buildMessageItem ---
  Widget _buildMessageItem(ChatThread chat) {
    // Логіка для hasUnread повинна ґрунтуватися на даних із Firebase (наприклад, поле 'unreadCount'), 
    // але для демонстрації ми припускаємо, що це поки false.
    // hasUnread тепер відсутнє у ChatThread, тому використовуємо константний стиль.
    final lastMessageStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400, // Встановлюємо w400, поки не буде логіки hasUnread
      color: _hintColor,
    );
    
    // Використовуємо NetworkImage
    final imageUrl = chat.otherUserImageUrl.isNotEmpty 
            ? NetworkImage(chat.otherUserImageUrl) as ImageProvider
            : const AssetImage("assets/images/default_user.png"); // Fallback

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage: imageUrl,
              child: null, 
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.otherUserName, // << ВИКОРИСТОВУЄМО otherUserName
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage, // << ВИКОРИСТОВУЄМО lastMessageText
                    style: lastMessageStyle,
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            
            // Час останнього повідомлення
            // Text(
            //   // Форматування часу (потрібен пакет intl)
            //   '${chat.lastMessageTime.hour}:${chat.lastMessageTime.minute.toString().padLeft(2, '0')}',
            //   style: const TextStyle(fontSize: 12, color: _hintColor),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    // Отримуємо єдиний список потоків чату
    final allThreads = chatProvider.chatThreads;
    final isLoading = chatProvider.isLoadingThreads;
    
    // 1. Розділяємо єдиний список на "Matches" та "Messages"
    final matches = allThreads.where(_isJustMatch).toList();
    final messages = allThreads.where((chat) => !_isJustMatch(chat)).toList();


    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        // ... (AppBar залишається незмінним)
        backgroundColor: _bgColor,
        automaticallyImplyLeading: false, 
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 26, 
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _primaryColor, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) // 2. Обробка завантаження
        : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Likes and matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
            ),
            
            // 3. Секція Matches (використовуємо розділений список)
            SizedBox(
              height: 100, // Збільшуємо висоту, щоб вмістити ім'я
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: matches.length, // Тільки matches
                itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _buildMatchItem(matches[index]),
                    );
                },
              ),
            ),
            
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 4. Секція Messages (використовуємо розділений список)
            ...messages.map((chat) => _buildMessageItem(chat)).toList(),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}