import 'package:flutter/material.dart';
import 'package:mini_chat_app/screens/chats_screen.dart';
import 'package:mini_chat_app/screens/matches_screen.dart';
import 'package:mini_chat_app/screens/explore_screen.dart';
import 'package:mini_chat_app/screens/profile_screen.dart';
import 'package:mini_chat_app/widgets/custom_bottom_nav_bar.dart'; 
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/providers/auth_provider.dart';
import 'package:mini_chat_app/providers/profile_provider.dart';
import 'package:mini_chat_app/providers/chat_provider.dart';

class MainScreen extends StatefulWidget {
  final String? userName;
  const MainScreen({super.key, this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; 

  late final List<Widget> _pages;
  //bool _initialized = false;
  @override
  void initState() {
    super.initState();
    _pages = [
      const ChatsScreen(),
      const MatchesScreen(),
      MainContentWidget(), // <<< передаємо
      const ExploreScreen(),
      const ProfileScreen(),
    ];
  }
  //винесла з wrapper і додала сюди зі змінною initialized
  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  // 1. "Слухаємо" зміни в AuthProvider
  final auth = context.watch<AuthProvider>();
  final user = auth.currentUser;

  // 2. Якщо Firebase вже знає користувача і не зайнятий завантаженням
  if (!auth.isLoading && user != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chat = context.read<ChatProvider>();
      final profile = context.read<ProfileProvider>();

      // 3. Ініціалізуємо чати, якщо вони ще не завантажені
      if (chat.chatThreads.isEmpty && chat.isLoadingThreads) {
        print("DEBUG: Triggering initChatThreads for ${user.uid}");
        chat.initChatThreads(user.uid);
      }

      // 4. Завантажуємо профіль користувача, якщо його ще немає
      if (profile.myProfile == null && !profile.isLoading) {
        print("DEBUG: Fetching profile for ${user.uid}");
        profile.fetchMyProfile(user.uid);
      }
    });
  }
}
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // if (_initialized) return;
  //   // _initialized = true;
  //   final auth = context.watch<AuthProvider>(); // використовуємо watch
  //   final user = auth.currentUser;
    
  //   print("DEBUG: MainScreen - isLoading: ${auth.isLoading}, User: ${user?.uid}");

  //   if (!auth.isLoading && user != null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       // Тут використовуємо read, бо ми вже всередині колбеку
  //       final chat = context.read<ChatProvider>();
        
  //       if (chat.chatThreads.isEmpty && chat.isLoadingThreads) {
  //         print("DEBUG: Triggering initChatThreads for ${user.uid}");
  //         chat.initChatThreads(user.uid);
  //       }
  //     });
  //   }
  // }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final auth = context.read<AuthProvider>();
    //   final chat = context.read<ChatProvider>();
    //   final profile = context.read<ProfileProvider>();

    //   final user = auth.currentUser;
    //   if (user != null) {
    //     chat.initChatThreads(user.uid);
    //     profile.fetchMyProfile(user.uid);
    //   }
    // });
 
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainContentWidget extends StatelessWidget {
  const MainContentWidget({super.key});

    void _causeCrash() {
    FirebaseCrashlytics.instance.crash(); 
  }
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    if (auth.isLoading || profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!auth.isAuthenticated) {
      return const Center(child: Text("No user logged in"));
    }

    final currentProfile = profileProvider.myProfile;
    String userName = "User"; // За замовчуванням
    if (currentProfile != null) {
        userName = currentProfile.name;
    } else {
        // Якщо профіль не знайдено, використовуємо ім'я з Firebase Auth
        userName = auth.currentUser!.displayName ?? "New User";
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            Text(
              'Welcome, $userName',
              style: const TextStyle(
                color: Color(0xFF1B1918),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            _buildProfileStack(),
            const SizedBox(height: 60),
            const Text(
              'Do you want to meet more people?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1B1918),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Get more matches by liking profiles you find interesting!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 65,
              child: ElevatedButton(
                onPressed:_causeCrash,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B1918),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Exploring',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String assetPath, double profileSize) {
    return Container(
      width: profileSize,
      height: profileSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.person, size: 50, color: Colors.white)
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileStack() {
    const double size = 125;
    const double centralSize = size + 10;
    const double sideSize = size - 10;

    const String profile1 = 'assets/images/image2.png';
    const String profile2 = 'assets/images/image1.png';
    const String profile3 = 'assets/images/image3.png';

    return SizedBox(
      height: centralSize + 5,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 30,
            top: 25,
            child: _buildProfileImage(profile1, sideSize),
          ),

          Positioned(
            right: 30,
            top: 25,
            child: _buildProfileImage(profile3, sideSize),
          ),

          Positioned(
            top: 0,
            child: _buildProfileImage(profile2, centralSize),
          ),
        ],
      ),
    );
  }
 }