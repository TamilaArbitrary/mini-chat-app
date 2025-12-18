import 'package:flutter/material.dart';
import 'package:mini_chat_app/utils/filter_navigator.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

 @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>{

Map<String, dynamic> activeFilters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Explore',
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
              final result = await openFilters(context, activeFilters);
              if (result != null) {
                setState(() => activeFilters = result);
              }
            }
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/image10.png', 
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  left: 16,
                  top: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5,
                        ),
                        child: const Text(
                          "Ihor, 23",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(196, 106, 188, 255),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "I'm looking for communication",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "Kyiv",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1B1918),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.04,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _circleButton(
                        icon: Icons.close,
                        onTap: () {},
                      ),
                      _circleButton(
                        icon: Icons.handshake,
                        onTap: () {},
                        isMain: true,
                      ),
                      _circleButton(
                        icon: Icons.favorite_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isMain = false,
  }) {
    double size = MediaQuery.of(context).size.width * 0.16;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMain ? Color(0xFF0049BD) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: isMain ? Colors.white : Color(0xFF0049BD),
        iconSize: size * 0.55,
        onPressed: onTap,
      ),
    );
  }
}