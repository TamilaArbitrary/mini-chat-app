import 'package:flutter/material.dart';
import 'package:mini_chat_app/models/profile.dart';
import 'package:mini_chat_app/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/providers/auth_provider.dart';
import 'package:mini_chat_app/providers/profile_provider.dart';
import 'package:mini_chat_app/providers/chat_provider.dart';

const Color _bgColor = Color(0xFFFFFAFA);
const Color _primaryColor = Color(0xFF1B1918);
const Color _secondaryColor = Color(0xFF424242);


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // 2. Викликаємо завантаження профілю один раз
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    if (authProvider.isAuthenticated && 
        authProvider.currentUser != null &&
        profileProvider.myProfile == null) 
    {
        // Запускаємо завантаження профілю, використовуючи UID
        profileProvider.fetchMyProfile(authProvider.currentUser!.uid);
    }
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    final color = isLogout ? Colors.redAccent : _primaryColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_sharp,
              color: color,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            // ТЕПЕР ВИКОРИСТОВУЄМО NetworkImage для URL з Firestore
            backgroundImage: profile.imageUrl.isNotEmpty
                ? NetworkImage(profile.imageUrl) as ImageProvider
                : const AssetImage("assets/images/default_profile.png"), // Fallback
            onBackgroundImageError: (exception, stackTrace) {
              // Обробка помилки завантаження зображення
              return; 
            },
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Використовуємо реальні дані
                  '${profile.name}, ${profile.age}', 
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email, // Використовуємо реальні дані
                  style: const TextStyle(
                    fontSize: 16,
                    color: _secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    if (auth.isLoading || profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  
    // якщо юзер не залогінений
    if (!auth.isAuthenticated || auth.currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final currentProfile = profileProvider.myProfile;
    final firebaseUser = auth.currentUser!;

    if (currentProfile == null) {
      final initialProfile = Profile(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? "New User",
        age: 0, gender: "Unspecified",
        email: firebaseUser.email,
        distance: 0.0, imageUrl: "",
      );
      
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Your profile data is missing. Please set up."),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Передаємо ініціалізований профіль для першого редагування
                      builder: (context) => EditProfileScreen(profile: initialProfile),
                    ),
                  );
                },
                child: const Text("Set Up Profile"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor, 
        automaticallyImplyLeading: false, 
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        centerTitle: false,
        actions: [
        IconButton(
          icon: const Icon(Icons.edit_note, color: _primaryColor, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // ПЕРЕДАЄМО ЗАВАНТАЖЕНИЙ ПРОФІЛЬ
                builder: (context) => EditProfileScreen(profile: currentProfile), 
              ),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProfileHeader(currentProfile),
            
            const SizedBox(height: 30),

            _buildProfileMenuItem(
              icon: Icons.favorite,
              title: 'Favourites',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_sharp,
              title: 'Notification',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.location_on_sharp,
              title: 'Location',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.security,
              title: 'Privacy Settings',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.feedback_sharp,
              title: 'Feedback',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.info_sharp,
              title: 'About App',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.live_help_sharp,
              title: 'Help',
              onTap: () {},
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Color(0xFFE0E0E0), height: 1),
            ),

            _buildProfileMenuItem(
              icon: Icons.logout_sharp,
              title: 'Log out',
              onTap: () async {
                context.read<ChatProvider>().clearData(); //додала тут очищення
                await context.read<AuthProvider>().logout();
                context.read<ProfileProvider>().clearProfile(); // ОЧИЩЕННЯ
              },
              isLogout: true, 
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}