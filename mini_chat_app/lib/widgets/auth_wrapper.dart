import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart'; 
//import '../providers/chat_provider.dart';
//import '../providers/profile_provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  
  // Ця функція викликається при зміні залежностей (включаючи AuthProvider)
  //ВИДАЛЯЄМО, ВОНА ТУТ НЕ ПОВИННА БУТИ, ТУТ НЕ МАЄ ВИКЛИКАТИСЬ NOTIFYLISTENERS
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Використовуємо context.read, щоб НЕ викликати rebuild
  //   final authProvider = context.read<AuthProvider>();
    
  //   // Перевіряємо, чи користувач залогінився
  //   if (authProvider.isAuthenticated && authProvider.currentUser != null) {
  //     final userId = authProvider.currentUser!.uid;

  //     // 1. Ініціалізація ChatProvider
  //     // Це запускає підписку на потоки чатів для цього користувача.
  //     context.read<ChatProvider>().initChatThreads(userId);

  //     // 2. Ініціалізація ProfileProvider (якщо ви хочете завантажувати профіль одразу)
  //     // Ми вже робили це на ProfileScreen, але можна зробити і тут для раннього кешування.
  //     context.read<ProfileProvider>().fetchMyProfile(userId);
      
  //   } else if (!authProvider.isAuthenticated) {
  //     // 3. Очищення даних при логауті
  //     // Це важливо для безпеки та очищення пам'яті.
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       context.read<ChatProvider>().clearData();
  //       context.read<ProfileProvider>().clearProfile();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Спостерігаємо за змінами в AuthProvider лише для логіки відображення
    final authProvider = context.watch<AuthProvider>();

    // 1. Стан завантаження (перевірка наявності токена Firebase при старті)
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0049BD)),
        ),
      );
    }
    
    // 2. Користувач автентифікований
    if (authProvider.isAuthenticated) {
      return const MainScreen();
    } 
    
    // 3. Користувач не автентифікований
    return const AuthScreen();
  }
}