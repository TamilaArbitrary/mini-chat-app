import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_thread.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatThread chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}
//на чому зупинилась: зробила чати і повідомлення, відредагувати стиль цих чатів під застосунок,
//подумати чи реалізую я matches чи хоча б в картку підтягну з бази даних користувача
//вирішити чи забрати imageUrl з користувача, перевірити чи зможу через це додати фотографії хоча
//б локально
//заповнити базу даних: матчі, чати і повідомлення
//почитати методичку до 7, щоб розуміти що робити треба буде
//спробувати завтра додати storage ще раз, а раптом піде

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Відкриваємо потік повідомлень через провайдер
    Future.microtask(() =>
        context.read<ChatProvider>().openChat(widget.chat.id));
  }

  void _onSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(text);
      _controller.clear();
      // Прокрутка вниз після відправки - МОЖЕ ЗРОБЛЮ
      // Timer(const Duration(milliseconds: 300), () {
      //   if (_scrollController.hasClients) {
      //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final myId = context.read<AuthProvider>().currentUser?.uid;
    final messages = chatProvider.currentMessages;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1918)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.chat.otherUserImageUrl.isNotEmpty
                  ? NetworkImage(widget.chat.otherUserImageUrl)
                  : const AssetImage("assets/images/default_user.png") as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              widget.chat.otherUserName,
              style: const TextStyle(color: Color(0xFF1B1918), fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.senderId == myId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF1B1918) : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 18),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Поле вводу повідомлення
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 15, right: 15, top: 10, 
        bottom: MediaQuery.of(context).padding.bottom + 10
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _onSend,
            child: const CircleAvatar(
              backgroundColor: Color(0xFF1B1918),
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}