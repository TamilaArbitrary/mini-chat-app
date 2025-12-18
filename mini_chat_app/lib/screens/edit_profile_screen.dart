import 'package:flutter/material.dart';
import 'package:mini_chat_app/models/profile.dart'; 

const Color _bgColor = Color(0xFFFFFAFA);
const Color _primaryColor = Color(0xFF1B1918);
const Color _hintColor = Color(0xFF6A6A6A); 

class EditProfileScreen extends StatelessWidget {
  final Profile profile;

  const EditProfileScreen({super.key, required this.profile});

  // Допоміжний віджет для елементів редагування
  Widget _buildEditMenuItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isTitlePrimary = false,
  }) {
    final titleColor = isTitlePrimary ? _primaryColor : _hintColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_sharp,
              color: _primaryColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  // Допоміжний віджет для секції заголовка профілю
  Widget _buildProfileImageSection(Profile profile) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: AssetImage(profile.imageUrl), 
            onBackgroundImageError: (exception, stackTrace) {
              return; 
            },
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFF1B1918), // Колір іконки редагування
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit, // Іконка "редагування"
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _primaryColor),
          onPressed: () {
            // TODO: Логіка повернення назад
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        centerTitle: true, // Заголовок по центру, як на макеті
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Секція зображення профілю
            _buildProfileImageSection(profile),
            const SizedBox(height: 25),

            // Ім'я та загальна інформація
            _buildEditMenuItem(
              title: '${profile.name}, ${profile.age}',
              subtitle: 'Female, Lviv', // Це тестові дані, які мають бути динамічними
              onTap: () {},
              isTitlePrimary: true,
            ),

            // Work and education
            _buildEditMenuItem(
              title: 'Work and education',
              subtitle: 'Add your job and education details.',
              onTap: () {},
            ),
            
            // What are your intentions?
            _buildEditMenuItem(
              title: 'What are your intentions?',
              subtitle: 'I\'m looking for communication.', // Тестові дані
              onTap: () {},
              isTitlePrimary: true,
            ),

            // About me
            _buildEditMenuItem(
              title: 'About me',
              subtitle: 'Write something about yourself.',
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}