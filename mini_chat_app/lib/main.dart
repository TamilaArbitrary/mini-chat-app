import 'package:flutter/material.dart';
import 'package:mini_chat_app/providers/auth_provider.dart';
import 'package:mini_chat_app/providers/profile_provider.dart';
import 'package:mini_chat_app/providers/profiles_provider.dart';
import 'package:mini_chat_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/widgets/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mini_chat_app/repositories/profiles_repository.dart';
import 'package:mini_chat_app/repositories/chats_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ProfilesRepository>(create: (_) => FirebaseProfilesRepository()),
        ChangeNotifierProvider<ProfileProvider>(create: (context) => ProfileProvider(context.read<ProfilesRepository>())),
        ChangeNotifierProvider<ProfilesProvider>(create: (context) => ProfilesProvider(context.read<ProfilesRepository>())),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<ChatsRepository>(create: (context) => FirebaseChatsRepository(context.read<ProfilesRepository>())),
        ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider(context.read<ChatsRepository>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHATTRIX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0049BD), 
        scaffoldBackgroundColor: const Color(0xFF73D7FF), 
        useMaterial3: true,
        fontFamily: 'InstrumentSans',
      ),
      home: const AuthWrapper(),
    );
  }
}