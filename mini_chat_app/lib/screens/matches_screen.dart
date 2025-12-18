import 'package:flutter/material.dart';
import 'package:mini_chat_app/utils/filter_navigator.dart';
import 'package:mini_chat_app/models/profile.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/providers/profiles_provider.dart';
import 'package:mini_chat_app/providers/auth_provider.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedTabIndex = 0;
  Map<String, dynamic> activeFilters = {};
  
bool _isInitialFetch = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_isInitialFetch) {
      final authProvider = context.read<AuthProvider>();
      final profilesProvider = context.read<ProfilesProvider>();
      
      final userId = authProvider.currentUser?.uid;

      if (userId != null) {
          // ВИКЛИКАЄМО НОВИЙ МЕТОД ІНІЦІАЛІЗАЦІЇ
          // Використовуємо addPostFrameCallback, щоб уникнути помилки setState/markNeedsBuild
          WidgetsBinding.instance.addPostFrameCallback((_) {
              profilesProvider.initialize(userId);
          });
      }
      _isInitialFetch = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final profilesProvider = context.watch<ProfilesProvider>();
    final profiles = profilesProvider.filteredProfiles;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text(
          'Matches',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1918),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_sharp, color: Color(0xFF1B1918), size: 28),
            onPressed: () async {
              final newFilters = await openFilters(context, context.read<ProfilesProvider>().activeFilters);
              if (newFilters != null) {
                context.read<ProfilesProvider>().setFilters(newFilters);
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Start chatting before a mutual match.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF424242),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          _buildTabs(), 
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                itemCount: profiles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, 
                  crossAxisSpacing: 8.0, 
                  mainAxisSpacing: 10.0, 
                  childAspectRatio: 0.65, 
                ),
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return ProfileGridItem(profile: profile);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTabButton(0, 'All'),
          _buildTabButton(1, 'For you'),
          const Expanded(child: SizedBox.shrink()), 
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1B1918) : Colors.transparent,
              width: 3.0, 
            ),
          ),
        ),
        
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0), 
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1B1918) : const Color(0xFF424242),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 18, 
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileGridItem extends StatelessWidget {
  final Profile profile;
  const ProfileGridItem({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              profile.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${profile.name}, ${profile.age}',
          style: const TextStyle(
            color: Color(0xFF1B1918),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}