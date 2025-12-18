import 'package:flutter/material.dart';

Widget buildAuthButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: const Color(0xFF1B1918)),
              label: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1B1918),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent, 
                side: const BorderSide(color: Color(0xFF1B1918), width: 1.5), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: const Color(0xFF1B1918)), 
              label: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1B1918),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
                  side: const BorderSide(color: Color(0xFF1B1918), width: 1.5),
                ),
                elevation: 0, // Прибираємо тінь
              ),
            ),
    );
  }