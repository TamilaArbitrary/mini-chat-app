import 'package:flutter/material.dart';
import 'package:mini_chat_app/screens/filters_screen.dart';

Future<Map<String, dynamic>?> openFilters(BuildContext context, Map<String, dynamic> currentFilters) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FiltersScreen(initialFilters: currentFilters),
    ),
  );
}
